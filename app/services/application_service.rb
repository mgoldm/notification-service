# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Model

  def success?
    errors.empty?
  end

  def private_error
    errors.full_messages
  end
end
