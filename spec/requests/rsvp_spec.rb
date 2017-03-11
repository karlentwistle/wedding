require "rails_helper"

RSpec.describe "RSVP", :type => :request do
  let(:rsvp_code) { create(:rsvp_code, ceremony: false, reception: true) }
  let(:secret) { rsvp_code.secret }

  describe 'root path' do
    it "redirects to 'enter_code'" do
      get "/rsvp"
      expect(response).to redirect_to(rsvp_path('enter_code'))
    end
  end

  describe 'enter_code' do
    context 'invalid code' do
      it "renders 'enter_code'" do
        put rsvp_path('enter_code'), params: {
          rsvp_code_form: { secret: '' }
        }
        expect(response).to have_http_status(:success)
      end
    end

    context 'valid code' do
      context 'not responded' do
        it "redirects to attendance" do
          put rsvp_path('enter_code'), params: {
            rsvp_code_form: { secret: secret }
          }
          expect(response).to redirect_to(rsvp_path('attendance'))
        end
      end

      context 'already responded to' do
        before { rsvp_code.close }
        it "redirects to confirmation" do
          put rsvp_path('enter_code'), params: {
            rsvp_code_form: { secret: secret }
          }
          expect(response).to redirect_to(rsvp_path('confirmation'))
        end
      end
    end
  end

  describe 'attendance' do
    context 'no rsvp_code_secret (cookie)' do
      it "redirects to 'enter_code'" do
        get rsvp_path('attendance')
        expect(response).to redirect_to(rsvp_path('enter_code'))
      end
    end

    context 'valid rsvp_code_secret (cookie)' do
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

  describe 'food' do
    context 'no rsvp_code_secret (cookie)' do
      it "raises ActionController::RoutingError" do
        expect {
          get rsvp_path('food')
        }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'valid rsvp_code_secret (cookie)' do
      before do
        put rsvp_path('enter_code'), params: {
          rsvp_code_form: { secret: secret }
        }
      end

      context 'rsvp_code not ceremony invite' do
        it "raises ActionController::RoutingError" do
          expect {
            get rsvp_path('food')
          }.to raise_error(ActionController::RoutingError)
        end
      end

      context 'rsvp_code ceremony invite' do
        let(:rsvp_code) { create(:rsvp_code, ceremony: true, reception: true) }

        context 'attendance step not completed' do
          it "redirects to 'attendance'" do
            get rsvp_path('food')
            expect(response).to redirect_to(rsvp_path('attendance'))
          end
        end

        context 'attendance step completed' do
          let(:person) { create(:person, attending_ceremony: true, attending_reception: true) }
          before { rsvp_code.people << person }

          it "renders 'food'" do
            get rsvp_path('food')
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end

  describe 'confirmation' do
    context 'no rsvp_code_secret (cookie)' do
      it "redirects to 'attendance'" do
        get rsvp_path('confirmation')
        expect(response).to redirect_to(rsvp_path('attendance'))
      end
    end

    context 'valid rsvp_code_secret (cookie)' do
      before do
        rsvp_code.people << person
        put rsvp_path('enter_code'), params: {
          rsvp_code_form: { secret: secret }
        }
      end

      context 'attendance step not completed (not invited to ceremony)' do
        let(:person) { create(:person) }

        it "redirects to 'attendance'" do
          get rsvp_path('confirmation')
          expect(response).to redirect_to(rsvp_path('attendance'))
        end
      end

      context 'attendance step not completed (are invited to ceremony)' do
        let(:rsvp_code) { create(:rsvp_code, ceremony: true, reception: true) }
        let(:person) { create(:person) }

        it "redirects to 'attendance'" do
          get rsvp_path('confirmation')
          expect(response).to redirect_to(rsvp_path('food'))
        end
      end

      context 'attendance step completed' do
        let(:person) { create(:person, attending_ceremony: true, attending_reception: true) }

        it "renders 'confirmation'" do
          get rsvp_path('confirmation')
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
