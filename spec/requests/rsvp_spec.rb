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
        get "/rsvp/enter_code"
        expect(response).to have_http_status(:success)
      end
    end
  end
end
