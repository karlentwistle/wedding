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
end
