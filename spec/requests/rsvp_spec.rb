require "rails_helper"

RSpec.describe "RSVP", :type => :request do
  let(:rsvp_code) { create(:rsvp_code, breakfast: false, reception: true) }
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
      it "raises Wicked::Wizard::InvalidStepError" do
        expect {
          get rsvp_path('food')
        }.to raise_error(Wicked::Wizard::InvalidStepError)
      end
    end

    context 'valid rsvp_code_secret (cookie)' do
      before do
        put rsvp_path('enter_code'), params: {
          rsvp_code_form: { secret: secret }
        }
      end

      context 'rsvp_code not breakfast invite' do
        it "raises Wicked::Wizard::InvalidStepError" do
          expect {
            get rsvp_path('food')
          }.to raise_error(Wicked::Wizard::InvalidStepError)
        end
      end

      context 'rsvp_code breakfast invite' do
        let(:rsvp_code) { create(:rsvp_code, breakfast: true, reception: true) }

        context 'attendance step not completed' do
          it "redirects to 'attendance'" do
            get rsvp_path('food')
            expect(response).to redirect_to(rsvp_path('attendance'))
          end
        end

        context 'attendance step completed' do
          let(:person) { create(:person, attending_breakfast: true, attending_reception: true) }
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

      context 'attendance step not completed (not invited to breakfast)' do
        let(:person) { create(:person) }

        it "redirects to 'attendance'" do
          get rsvp_path('confirmation')
          expect(response).to redirect_to(rsvp_path('attendance'))
        end
      end

      context 'attendance step not completed (are invited to breakfast)' do
        let(:rsvp_code) { create(:rsvp_code, breakfast: true, reception: true) }
        let(:person) { create(:person) }

        it "redirects to 'attendance'" do
          get rsvp_path('confirmation')
          expect(response).to redirect_to(rsvp_path('food'))
        end
      end

      context 'attendance step completed' do
        let(:person) { create(:person, attending_breakfast: true, attending_reception: true) }

        it "renders 'confirmation'" do
          get rsvp_path('confirmation')
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
