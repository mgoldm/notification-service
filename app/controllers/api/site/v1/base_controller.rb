# frozen_string_literal: true

module Api
  module Site
    module V1
      class BaseController < ApplicationController
        include ActionController::MimeResponds
        include ActionController::Cookies

        attr_accessor :current_user

        before_action :destroy_session
        before_action :authenticate

        rescue_from ActiveRecord::RecordNotFound, with: -> { not_found('Not Found') }

        private

        def authenticate
          token = api_token || cookie_api_token
          result = AuthService.authenticate(token)

          return render json: { error: result.error }, status: result.status unless result.success?

          @current_user = result.user
        end

        def destroy_session
          request.session_options[:skip] = true
        end

        def access_denied(message = 'Access denied.')
          render json: { error: message }, status: :forbidden
        end

        def api_error(message = 'Authentication Error')
          render json: { error: message }, status: :internal_server_error
        end

        def unauthorized(message = 'Unauthorized')
          render json: { error: message }, status: :unauthorized
        end

        def unprocessable_entity(message = 'Unprocessable')
          render json: { error: message }, status: :unprocessable_content
        end

        def cookie_api_token
          cookies[:api_token]
        end

        def bad_request(message = 'Bad Request')
          render json: { error: message }, status: :bad_request
        end

        def not_found(message = 'Not Found')
          render json: { error: message }, status: :not_found
        end

        def error!(args, status)
          render json: { error: true, **args }, status: status
        end

        def ip
          @ip ||= request.remote_ip
        end

        def api_token
          unless request.headers['Authorization'].nil?
            match_data = request.headers['Authorization'].match(/(?:Bearer|Token)\s(?<api_token>.*)/)
          end
          match_data[:api_token] unless match_data.nil?
        end
      end
    end
  end
end
