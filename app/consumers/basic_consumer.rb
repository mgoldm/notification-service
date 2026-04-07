# frozen_string_literal: true

# Abstract base class for AMQP consumers (uses Bunny).
# Configure queue/exchange settings in subclasses, then override #process.
class BasicConsumer
  class_attribute :queue, :exchange, :routing_key, :durable, :exchange_durable,
                  :manual_ack, :requeue, :shutdown_timeout, :queue_arguments

  def self.start
    connection = Bunny.new(ENV.fetch('AMQP_URL'))
    connection.start

    ch = connection.create_channel
    x  = ch.topic(exchange.to_s, durable: exchange_durable)
    q  = ch.queue(queue.to_s, durable: durable, arguments: queue_arguments || {})
    q.bind(x, routing_key: routing_key.to_s)

    q.subscribe(manual_ack: manual_ack, block: true) do |delivery_info, _meta, payload|
      new.process(JSON.parse(payload, symbolize_names: true))
      ch.ack(delivery_info.delivery_tag) if manual_ack
    rescue StandardError => e
      Sentry.capture_exception(e)
      ch.nack(delivery_info.delivery_tag, false, requeue) if manual_ack
    end
  ensure
    connection&.close
  end

  def process(_message)
    raise NotImplementedError, "#{self.class}#process is not implemented"
  end
end
