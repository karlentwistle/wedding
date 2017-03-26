class AddFoodChoicesCountToFood < ActiveRecord::Migration[5.0]
  class LocalFood < ApplicationRecord
    def self.table_name
      'foods'
    end

    has_many :food_choices, foreign_key: 'food_id'
    has_many :people, through: :food_choices
  end

  def up
    add_column :foods, :food_choices_count, :integer, default: 0

    LocalFood.reset_column_information

    LocalFood.all.each do |food|
      food.food_choices_count = food.food_choices.count
      food.save!
    end
  end

  def down
    remove_column :people, :food_choices_count
  end
end
