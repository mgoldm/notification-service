# frozen_string_literal: true

class NotificationCreator < ApplicationService
  attr_accessor :uuid, :title, :description, :button_title, :button_url,
                :style, :user_ids, :is_closable

  validates :title, :user_ids, presence: true

  def call
    return self unless valid?

    record_attrs = user_ids.map { |id| create_params.merge(user_id: id) }
    Notification.insert_all!(record_attrs)
    self
  rescue StandardError => e
    errors.add(:base, e.message)
    self
  end

  private

  def create_params
    {
      uuid: uuid || SecureRandom.uuid,
      title: title,
      description: description,
      button_title: button_title,
      button_url: button_url,
      style: style || 0,
      is_closable: is_closable.nil? ? true : is_closable
    }
  end
end
