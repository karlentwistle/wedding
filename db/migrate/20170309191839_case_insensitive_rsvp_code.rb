class CaseInsensitiveRsvpCode < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'citext'
    change_column :rsvp_codes, :secret, :citext
  end

  def down
    change_column :rsvp_codes, :secret, :text
  end
end
