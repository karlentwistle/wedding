class CreateRsvpCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :rsvp_codes do |t|
      t.string :secret

      t.timestamps
    end
  end
end
