# frozen_string_literal: true

module Api
  module Site
    module V1
      class NotificationsController < BaseController
        def index
          notifications = Notification.opened.where(user: current_user).order(created_at: :desc)

          render json: Api::Common::NotificationBlueprint.render_as_hash(notifications)
        end

        def read_all
          notifications = Notification.opened.where(user: current_user)
          notifications.update_all(status: :read)

          render json: Api::Common::NotificationBlueprint.render_as_hash(notifications)
        end

        def read
          notification.update(status: :read)

          render json: Api::Common::NotificationBlueprint.render_as_hash(notification)
        end

        def close
          notification.update(status: :closed)

          render json: Api::Common::NotificationBlueprint.render_as_hash(notification)
        end

        private

        def notification
          @notification ||= Notification.find_by!(uuid: params[:uuid], user_id: current_user.id)
        end
      end
    end
  end
end
