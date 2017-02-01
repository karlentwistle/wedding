class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :full_name, null: false
      t.boolean :attending_breakfast
      t.belongs_to :rsvp_code, index: true

      t.timestamps
    end
  end
end
