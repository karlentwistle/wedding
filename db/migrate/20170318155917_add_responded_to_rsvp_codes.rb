class AddRespondedToRsvpCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :rsvp_codes, :responded, :boolean, default: false
  end
end
