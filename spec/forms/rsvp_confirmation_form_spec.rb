require 'rails_helper'

RSpec.describe RsvpConfirmationForm do
  let(:secret) { nil }
  let(:cookies) { { rsvp_code_secret: secret } }
  let(:params) { { } }
  let(:subject) { described_class.new(cookies: cookies, params: params) }

  describe '#people' do
    let(:people) { [create(:person), create(:person)] }
    let(:rsvp_code) { create(:rsvp_code) }
    let(:cookies) { {rsvp_code_secret: rsvp_code.secret} }
    before { rsvp_code.people << people }

    it 'delegates to rsvp_code assosicated people' do
      expect(subject.people).to match_array(people)
    end
  end
end
