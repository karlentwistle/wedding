require "rails_helper"

RSpec.describe "person show page" do
  before { basic_auth_admin }

  describe "food choices" do
    context "person has made food choices" do
      it "displays the food choices" do
        person = create(:person)
        food_choices = [
          create(:food_choice, sitting: 0, person: person),
          create(:food_choice, sitting: 1, person: person),
          create(:food_choice, sitting: 2, person: person),
        ]
        foods = food_choices.map(&:food)

        visit admin_person_path(person)

        within('.attribute-data--has-many') do
          foods.each do |food|
            expect(page).to have_food_row(food.title)
          end
        end
      end
    end

    context "person has made no food choices" do
      it "displays none" do
        person = create(:person)

        visit admin_person_path(person)

        within('.attribute-data--has-many') do
          expect(page).to have_content 'None'
        end
      end
    end
  end

  def have_food_row(title)
    have_css('tr td:first-child', text: title)
  end
end
