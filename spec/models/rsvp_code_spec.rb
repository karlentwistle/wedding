require 'rails_helper'

RSpec.describe RsvpCode, type: :model do
  subject { build(:rsvp_code) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe 'validations' do
    it 'is invalid without a secret' do
      subject.secret = ''
      expect(subject.save).to be false
    end

    it 'is invalid is another rsvp code shares the same secret' do
      existing_rsvp_code = create(:rsvp_code)
      duplicate_rsvp_code = build(:rsvp_code, secret: existing_rsvp_code.secret)
      expect(duplicate_rsvp_code.save).to be false
    end
  end

  describe '#people' do
    context 'no people associated' do
      it 'is empty' do
        expect(subject.people).to be_empty
      end
    end

    context 'has people associated' do
      let(:associated_a) { create(:person) }
      let(:associated_b) { create(:person) }
      let(:not_associated) { create(:person) }

      before do
        subject.people << [associated_a, associated_b]
      end

      it 'returns associated people' do
        expect(subject.people).to match_array([associated_a, associated_b])
      end
    end
  end
end
