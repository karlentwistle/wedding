require "rails_helper"

describe "person index page" do
  before { basic_auth_admin }

  it "displays persons' name" do
    person = create(:person)

    visit admin_people_path

    expect(page).to have_header("People")
    expect(page).to have_content(person.full_name)
  end

  it "links to the person show page" do
    person = create(:person)

    visit admin_people_path
    click_show_link_for(person)

    expect(page).to have_header(displayed(person))
  end

  it "links to the edit page" do
    person = create(:person)

    visit admin_people_path
    click_on "Edit"

    expect(current_path).to eq(edit_admin_person_path(person))
  end

  it "links to the new page" do
    visit admin_people_path
    click_on("New person")

    expect(current_path).to eq(new_admin_person_path)
  end

  it "paginates records based on a constant" do
    expect_first = create(:person, full_name: 'Adam Apple')
    expect_last = create(:person, full_name: 'Zean Zebra')

    visit admin_people_path(per_page: 1)

    expect(page).not_to have_content(expect_last)
    click_on "Next"
    expect(page).to have_content(expect_last)
  end

  describe "sorting" do
    it "defaults to order by full_name" do
      default_first = create(:person, full_name: 'Adam Apple')
      default_last = create(:person, full_name: 'Zean Zebra')

      visit admin_people_path

      expect_to_appear_in_order(
        default_first.full_name,
        default_last.full_name
      )
    end

    it "allows reverse sorting" do
      default_first = create(:person, full_name: 'Adam Apple')
      default_last = create(:person, full_name: 'Zean Zebra')

      visit admin_people_path
      click_on "Full Name"

      expect_to_appear_in_order(
        default_last.full_name,
        default_first.full_name
      )
    end

    it "toggles the order" do
      default_first = create(:person, full_name: 'Adam Apple')
      default_last = create(:person, full_name: 'Zean Zebra')

      visit admin_people_path
      2.times { click_on "Full Name" }

      expect_to_appear_in_order(
        default_first.full_name,
        default_last.full_name
      )
    end

    it "preserves search" do
      query = "Someone"

      visit admin_people_path(search: query)
      click_on "Name"

      expect(find(".search__input").value).to eq(query)
    end
  end

  def expect_to_appear_in_order(*elements)
    positions = elements.map { |e| page.body.index(e) }
    expect(positions).to eq(positions.sort)
  end
end
