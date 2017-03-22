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

  describe '.for_sitting' do
    let!(:starter) { create(:food, sitting: 0) }
    let!(:main) { create(:food, sitting: 1) }
    let!(:dessert) { create(:food, sitting: 2) }

    context 'sitting starter' do
      it 'returns only food for starter' do
        expect(
          Food.for_sitting(:starter)
        ).to match_array([starter])
      end
    end

    context 'sitting dessert' do
      it 'returns only food for sitting dessert' do
        expect(
          Food.for_sitting(:dessert)
        ).to match_array([dessert])
      end
    end
  end
end
