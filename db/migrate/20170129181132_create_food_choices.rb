class CreateFoodChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :food_choices do |t|
      t.belongs_to :person, index: true, null: false
      t.belongs_to :food, index: true, null: false
      t.integer :sitting, null: false

      t.timestamps
    end
  end
end
