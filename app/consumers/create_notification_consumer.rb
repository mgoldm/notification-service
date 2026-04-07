# frozen_string_literal: true

class CreateNotificationConsumer < BasicConsumer
  self.queue = 'notification_center.create_notification'
  self.exchange = 'notification_center'
  self.routing_key = 'notification_center.create_notification'
  self.durable = true
  self.exchange_durable = true
  self.manual_ack = true
  self.requeue = true
  self.shutdown_timeout = 16
  self.queue_arguments = {}

  def process(message)
    service = ::NotificationCreator.new(message).call

    return if service.success?

    Sentry.capture_message(self.class.name, extra: { errors: service.private_error })
  end
end
