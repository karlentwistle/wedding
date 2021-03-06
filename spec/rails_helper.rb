ENV["RAILS_ENV"] = "test"
ENV["ADMIN_NAME"] = "admin"
ENV["ADMIN_PASSWORD"] = "password"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end
