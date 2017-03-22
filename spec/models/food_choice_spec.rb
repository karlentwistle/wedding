require 'rails_helper'

RSpec.describe FoodChoice, type: :model do
  subject(:food_choice) { build(:food_choice) }

  it 'has a valid factory' do
    expect(subject.valid?).to be true
  end

  describe 'validations' do
    it 'is invalid without a person' do
      subject.person = nil
      expect(subject.save).to be false
    end

    it 'is invalid without a food' do
      subject.food = nil
      expect(subject.save).to be false
    end

    it 'validates uniqueness of food for person' do
      person = create(:person)
      food = create(:food)
      subject = build(:food_choice, person: person, food: food)

      subject.save!

      expect {
        subject.dup.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'validates only one food per sitting per person' do
      person = create(:person)
      carrot_cake = create(:food, title: 'cc', sitting: 'dessert')
      banana_loaf = create(:food, title: 'bf', sitting: 'dessert')
      create(:food_choice, person: person, food: banana_loaf)

      subject = build(:food_choice, person: person, food: carrot_cake)
      expect(subject.save).to be false
    end

    it 'a child cannot pick adult food' do
      child = create(:person, child: true)
      adult_food = create(:food, child: false)

      food_choice.food = adult_food
      food_choice.person = child

      expect(food_choice).to be_invalid
    end

    it 'a adult cannot pick child food' do
      adult = create(:person, child: true)
      child_food = create(:food, child: false)

      food_choice.food = child_food
      food_choice.person = adult

      expect(food_choice).to be_invalid
    end
  end
end
