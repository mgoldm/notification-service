module Api
  module Common
    class NotificationBlueprint < Blueprinter::Base
      fields :uuid, :title, :description, :button_title,
             :button_url, :status, :style, :created_at, :is_closable
    end
  end
end
