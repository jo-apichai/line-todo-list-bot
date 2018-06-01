module RequestHelpers
  def authenticate_user(user)
    user = user.with_indifferent_access

    allow(LoginService).to receive(:get_request_token).
      and_return({ 'sub' => user['id'], 'name' => user['name'] })

    get '/auth'
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request

  config.before(:each, mobile: true) do
    allow_any_instance_of(ActionDispatch::Request).to receive(:variant).
      and_return(ActiveSupport::ArrayInquirer.new([:phone]))

    allow_any_instance_of(Browser::Device).to receive(:mobile?).
      and_return(true)
  end
end
