module AuthHelper
  def basic_auth_admin
    encoded_login = ["#{ENV["ADMIN_NAME"]}:#{ENV["ADMIN_PASSWORD"]}"].pack("m*")
    page.driver.header 'Authorization', "Basic #{encoded_login}"
  end
end

RSpec.configure do |config|
  config.include AuthHelper, :type => :feature
end
