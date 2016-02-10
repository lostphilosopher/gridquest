RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include Devise::TestHelpers, type: :helper

  config.before do
    @request.env['devise.mapping'] = Devise.mappings[:user] if @request
  end
end
