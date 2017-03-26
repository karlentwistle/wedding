class RemoveConfirmedFromRsvpCode < ActiveRecord::Migration[5.0]
  def change
    remove_column :rsvp_codes, :confirmed
  end
end
