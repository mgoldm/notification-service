# frozen_string_literal: true

class AuthService
  Result = Struct.new(:success, :user, :error, :status, keyword_init: true) do
    def success? = success
  end

  def self.authenticate(token)
    return Result.new(success: false, error: 'Unauthorized', status: 401) if token.blank?

    payload = JWT.decode(token, ENV.fetch('JWT_SECRET'), true, algorithm: 'HS256').first
    user = User.find_by(id: payload['user_id'])
    return Result.new(success: false, error: 'User not found', status: 401) unless user

    Result.new(success: true, user: user, status: 200)
  rescue JWT::DecodeError => e
    Result.new(success: false, error: e.message, status: 401)
  end
end
