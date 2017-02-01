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

  describe '#viewable?' do
    let(:rsvp_code) { create(:rsvp_code) }
    let(:cookies) { {rsvp_code_secret: rsvp_code.secret} }
    before { rsvp_code.people << people }

    context 'valid rsvp_code' do
      context 'and peoples attendance marked' do
        let(:people) do
          [
            create(:person, attending_breakfast: true),
            create(:person, attending_breakfast: false)
          ]
        end

        it 'returns true' do
          expect(subject.viewable?).to be true
        end
      end

      context 'a persons attendance not marked' do
        let(:people) do
          [
            create(:person),
            create(:person, attending_breakfast: false)
          ]
        end

        it 'returns true' do
          expect(subject.viewable?).to be false
        end
      end
    end
  end
end
