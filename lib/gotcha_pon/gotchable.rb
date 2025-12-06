# frozen_string_literal: true

require "active_support/concern"

module GotchaPon
  module Gotchable
    extend ActiveSupport::Concern

    class_methods do
      def gotcha_pon(count: 1)
        items = order(random_order).limit(count).to_a
        count == 1 ? items.first : items
      end

      def gotcha_pon_with_history(user: nil, count: 1)
        items = gotcha_pon(count: count)
        GotchaPon::History.record_gotcha(user: user, items: Array(items))
        items
      end

      private

        def random_order
          case connection.adapter_name
          when /mysql/i
            Arel.sql("RAND()")
          else # PostgreSQL, SQLite
            Arel.sql("RANDOM()")
          end
        end
    end
  end
end
