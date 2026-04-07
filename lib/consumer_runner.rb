# frozen_string_literal: true

class ConsumerRunner
  def self.run(name, consumers)
    Rails.logger.info("Starting consumer: #{name}")

    threads = consumers.map do |consumer|
      Thread.new { consumer.start }
    end

    threads.each(&:join)
  end
end
