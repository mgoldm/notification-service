# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: false do |t|
      t.string :uuid, null: false, index: { unique: true }, primary_key: true
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :description
      t.string :button_title, default: ''
      t.string :button_url, default: ''
      t.integer :status, null: false, default: 0
      t.integer :style, null: false, default: 0
      t.boolean :is_closable, default: true
      t.timestamps null: false
    end
  end
end
