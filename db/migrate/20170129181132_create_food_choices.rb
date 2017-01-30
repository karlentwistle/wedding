class CreateFoodChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :food_choices do |t|
      t.belongs_to :person, index: true
      t.belongs_to :food, index: true
      t.integer :sitting

      t.timestamps
    end
  end
end
