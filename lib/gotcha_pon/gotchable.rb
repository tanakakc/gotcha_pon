# frozen_string_literal: true

require "active_support/concern"

module GotchaPon
  module Gotchable
    extend ActiveSupport::Concern

    included do
      class_attribute :gotcha_pon_track_history, default: false
    end

    class_methods do
      def track_gotcha_pon_history
        self.gotcha_pon_track_history = true
      end

      # Execute gacha - returns items and records history if enabled
      def gotcha_pon(user: nil, count: 1)
        items = where(id: pluck(:id).sample(count)).to_a
        GotchaPon::History.record_gotcha(user: user, items: items) if gotcha_pon_track_history
        count == 1 ? items.first : items
      end
    end
  end
end
