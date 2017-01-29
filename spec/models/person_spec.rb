require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { build(:person) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe 'validations' do
    it 'is invalid without a full_name' do
      subject.full_name = ''
      expect(subject.save).to be false
    end

    it 'is invalid without an rsvp_code' do
      subject.rsvp_code = nil
      expect(subject.save).to be false
    end
  end
end
