module Admin::Features
  def displayed(resource)
    (resource.class.to_s + "Dashboard").
      constantize.
      new.
      display_resource(resource)
  end
end

RSpec.configure do |config|
  config.include Admin::Features, type: :feature
end
