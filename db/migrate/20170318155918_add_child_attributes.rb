class AddChildAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :child, :boolean, default: false
    add_column :foods, :child, :boolean, default: false
  end
end
