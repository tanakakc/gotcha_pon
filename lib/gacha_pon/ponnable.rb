# frozen_string_literal: true

require "active_support/concern"

module GachaPon
  module Ponnable
    extend ActiveSupport::Concern

    class_methods do
      # Execute gacha - returns a query for random selection
      def gacha_pon(user:, count: 1)
        where(id: pluck(:id).sample(count))
      end
    end
  end
end
