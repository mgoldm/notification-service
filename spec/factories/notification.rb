# frozen_string_literal: true

FactoryBot.define do
  factory :notification, class: 'Notification' do
    uuid { SecureRandom.uuid }
    title { 'Payment successful' }
    description { 'Your payment was successful' }
    button_title { 'Learn more' }
    button_url { 'http://example.com' }
    user
    status { :new }
    style { 'success' }
  end
end
