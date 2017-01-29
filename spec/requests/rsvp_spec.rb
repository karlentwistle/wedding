require "rails_helper"

RSpec.describe "RSVP", :type => :request do
  describe 'root path' do
    it "redirects to 'enter_code'" do
      get "/rsvp"
      expect(response).to redirect_to(rsvp_path('enter_code'))
    end
  end

  describe 'enter_code' do
    context 'invalid code' do
      it "renders 'enter_code'" do
        get rsvp_path('enter_code')
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'attendance' do
    context 'no rsvp_code_secret' do
      it "redirects to 'enter_code'" do
        get rsvp_path('attendance')
        expect(response).to redirect_to(rsvps_path)
      end
    end

    context 'valid rsvp_code_secret' do
      let(:secret) { create(:rsvp_code).secret }
      before do
        put rsvp_path('enter_code'), params: {
          rsvp_code_form: { secret: secret }
        }
      end

      it "renders 'attendance'" do
        get rsvp_path('attendance')
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'confirmation' do
    context 'no rsvp_code_secret' do
      it "redirects to 'enter_code'" do
        get rsvp_path('confirmation')
        expect(response).to redirect_to(rsvps_path)
      end
    end

    context 'valid rsvp_code_secret' do
      let(:rsvp_code) { create(:rsvp_code) }
      let(:secret) { rsvp_code.secret }
      let(:person) { create(:person) }

      before do
        rsvp_code.people << person
        put rsvp_path('enter_code'), params: {
          rsvp_code_form: { secret: secret }
        }
      end

      context 'attendance step not completed' do
        it "redirects to 'attendance'" do
          get rsvp_path('confirmation')
          expect(response).to redirect_to(rsvp_path('attendance'))
        end
      end

      context 'attendance step completed' do
        let(:attending) { ['0', '1'].sample }

        before do
          put rsvp_path('attendance'), params: {
            rsvp_attendance_form: {
              people_attributes: {
                "0": { attending: attending, id: person.id }
              }
            }
          }
        end

        it "renders 'confirmation'" do
          get rsvp_path('confirmation')
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
