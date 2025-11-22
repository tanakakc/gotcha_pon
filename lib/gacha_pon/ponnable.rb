# frozen_string_literal: true

require "active_support/concern"

module GachaPon
  module Ponnable
    extend ActiveSupport::Concern

    included do
      # Configure gacha settings for this model
      class_attribute :gacha_pon_configuration, default: {}
    end

    class_methods do
      # Configure gacha rules and settings
      def gacha_pon_config(options = {})
        default_config = {
          weight_column: nil,
          default_rule: :standard,
          rules: {}
        }

        self.gacha_pon_configuration = default_config.merge(options)
      end

      # Execute gacha (main method)
      def gacha_pon(user:, count: 1, rule: nil)
        rule ||= gacha_pon_configuration[:default_rule]

        # TODO: Implement gacha logic
        raise NotImplementedError, "gacha_pon method not implemented yet"
      end
    end
  end
end
