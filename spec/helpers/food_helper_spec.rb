require "rails_helper"

RSpec.describe FoodHelper, :type => :helper do
  context 'no food' do
    it 'returns empty array' do
      expect(helper.food_for_sitting('dessert')).to be_empty
    end
  end

  context 'food' do
    let(:desserts) { [double(sitting: 'dessert')] }
    let(:mains) { [double(sitting: 'main')] }
    let(:foods) { desserts + mains }

    before { allow(Food).to receive(:all).and_return(foods) }

    it 'returns food corresponding to sitting passed' do
      expect(helper.food_for_sitting('dessert')).to eql(desserts)
    end
  end
end
