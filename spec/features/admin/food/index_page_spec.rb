require "rails_helper"

describe "food index page" do
  before { basic_auth_admin }

  it "displays foods' title" do
    food = create(:food)

    visit admin_foods_path

    expect(page).to have_header("Food")
    expect(page).to have_content(food.title)
  end

  it "links to the food show page" do
    food = create(:food)

    visit admin_foods_path
    click_show_link_for(food)

    expect(page).to have_header(displayed(food))
  end

  it "links to the edit page" do
    food = create(:food)

    visit admin_foods_path
    click_on "Edit"

    expect(current_path).to eq(edit_admin_food_path(food))
  end

  it "links to the new page" do
    visit admin_foods_path
    click_on("New food")

    expect(current_path).to eq(new_admin_food_path)
  end

  it "paginates records based on a constant" do
    expect_first = create(:food, sitting: 0)
    expect_last = create(:food, sitting: 1)

    visit admin_foods_path(per_page: 1)

    expect(page).not_to have_content(expect_last)
    click_on "Next"
    expect(page).to have_content(expect_last)
  end

  describe "sorting" do
    it "defaults to order by sitting" do
      default_first = create(:food, sitting: 0)
      default_last = create(:food, sitting: 1)

      visit admin_foods_path

      expect_to_appear_in_order(
        default_first.title,
        default_last.title
      )
    end

    it "allows reverse sorting" do
      default_first = create(:food, sitting: 0)
      default_last = create(:food, sitting: 1)

      visit admin_foods_path
      click_on "Sitting"

      expect_to_appear_in_order(
        default_last.title,
        default_first.title
      )
    end

    it "toggles the order" do
      default_first = create(:food, sitting: 0)
      default_last = create(:food, sitting: 1)

      visit admin_foods_path
      2.times { click_on "Sitting" }

      expect_to_appear_in_order(
        default_first.title,
        default_last.title
      )
    end

    it "preserves search" do
      query = "Something"

      visit admin_foods_path(search: query)
      click_on "Title"

      expect(find(".search__input").value).to eq(query)
    end
  end

  def expect_to_appear_in_order(*elements)
    positions = elements.map { |e| page.body.index(e) }
    expect(positions).to eq(positions.sort)
  end
end
