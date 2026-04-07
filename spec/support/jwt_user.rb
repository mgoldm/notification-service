# frozen_string_literal: true

require 'rspec/core/shared_context'

module JwtUser
  extend RSpec::Core::SharedContext

  let!(:user) { create(:user) }
  let(:valid_token) { 'my_valid_token' }
  let(:invalid_token) { 'my_invalid_token' }

  before do
    allow(AuthService).to receive(:authenticate).with(valid_token)
      .and_return(AuthService::Result.new(success: true, user: user, status: 200))
    allow(AuthService).to receive(:authenticate).with(invalid_token)
      .and_return(AuthService::Result.new(success: false, error: 'Access denied', status: 401))
    allow(AuthService).to receive(:authenticate).with(nil)
      .and_return(AuthService::Result.new(success: false, error: 'Unauthorized', status: 401))
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{valid_token}"
    request.env['HTTP_ACCEPT'] = 'application/json'
  end
end
