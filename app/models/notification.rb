# frozen_string_literal: true

class Notification < ApplicationRecord
  extend Enumerize

  STYLES = { no: 0, success: 1, warning: 2, error: 3 }.freeze
  STATUSES = { new: 0, read: 1, closed: 2 }.freeze

  belongs_to :user

  scope :opened, -> { where.not(status: :closed) }

  enumerize :status, in: STATUSES, predicates: true
  enumerize :style, in: STYLES, predicates: true
end
