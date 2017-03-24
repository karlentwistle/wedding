class RemovePersonsRsvpCodeNotNullConstraint < ActiveRecord::Migration[5.0]
  def change
    change_column :people, :rsvp_code_id, :integer, :null => true
  end
end
