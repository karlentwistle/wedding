class CreateRsvpCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :rsvp_codes do |t|
      t.string :secret, null: false, index: true
      t.boolean :breakfast, null: false
      t.boolean :reception, null: false
      t.boolean :confirmed, null: false, default: false

      t.timestamps
    end
  end
end
