# frozen_string_literal: true

module GotchaPon
  class History < ActiveRecord::Base
    self.table_name = "gotcha_pon_histories"

    # Polymorphic associations
    belongs_to :user, polymorphic: true, optional: true
    belongs_to :gotchable, polymorphic: true

    def user
      super || GotchaPon::NullUser.instance
    end

    # Validations
    validates :gotchable, presence: true

    # Scopes
    scope :recent, -> { order(created_at: :desc) }
    scope :for_user, ->(user) { where(user: user) }
    scope :for_gotchable_type, ->(type) { where(gotchable_type: type) }

    # Instance methods
    def self.record_gotcha(user:, items:)
      transaction do
        Array(items).map do |item|
          create!(
            user: user,
            gotchable: item,
            executed_at: Time.current
          )
        end
      end
    end
  end
end
