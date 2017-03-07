class AddKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key "food_choices", "foods", name: "food_choices_food_id_fk"
    add_foreign_key "food_choices", "people", name: "food_choices_person_id_fk"
    add_foreign_key "people", "rsvp_codes", name: "people_rsvp_code_id_fk"
  end
end
