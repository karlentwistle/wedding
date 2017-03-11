class RenameBreakfastToCeremony < ActiveRecord::Migration[5.0]
  def change
    rename_column :rsvp_codes, :breakfast, :ceremony
    rename_column :people, :attending_breakfast, :attending_ceremony
  end
end
