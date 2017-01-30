require 'rails_helper'

RSpec.describe Food, type: :model do
  subject { build(:food) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe 'validations' do
    it 'is invalid without a title' do
      subject.title = ''
      expect(subject.save).to be false
    end

    it 'is invalid without a sitting' do
      subject.sitting = nil
      expect(subject.save).to be false
    end
  end
end
