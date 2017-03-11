module PhotosHelper
  def visit_photos
    visit root_path

    within '.centered-navigation' do
      click_link 'Photos'
    end
  end
end

RSpec.configure do |config|
  config.include PhotosHelper, :type => :feature
end
