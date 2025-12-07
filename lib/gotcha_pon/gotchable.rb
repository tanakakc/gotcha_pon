# frozen_string_literal: true

require "active_support/concern"

module GotchaPon
  module Gotchable
    extend ActiveSupport::Concern

    class_methods do
      def gotcha_pon_weight(column:)
        @gotcha_pon_weight_column = column
      end

      def gotcha_pon(count: 1)
        items =
          if @gotcha_pon_weight_column
            weighted_sample(count)
          else
            random_sample(count)
          end

        if count == 1
          items.first
        else
          items
        end
      end

      def gotcha_pon_with_history(user: nil, count: 1)
        gotcha_pon(count: count).tap do |items|
          GotchaPon::History.record_gotcha(user: user, items: Array(items))
        end
      end

      private

        def random_sample(count)
          order(random_function).limit(count).to_a
        end

        def weighted_sample(count)
          if sqlite?
            weighted_sample_ruby(count)
          else
            weighted_sample_sql(count)
          end
        end

        def weighted_sample_sql(count)
          column = @gotcha_pon_weight_column
          where("#{column} > 0").order(weighted_random_function(column)).limit(count).to_a
        end

        def random_function
          if mysql?
            Arel.sql("RAND()")
          else
            Arel.sql("RANDOM()")
          end
        end

        def weighted_random_function(column)
          quoted = connection.quote_column_name(column)

          if mysql?
            Arel.sql("-LOG(RAND()) / #{quoted}")
          else
            Arel.sql("-LN(RANDOM()) / #{quoted}")
          end
        end

        def weighted_sample_ruby(count)
          column = @gotcha_pon_weight_column
          candidates = where("#{column} > 0").to_a
          selected = []

          count.times do
            break if candidates.empty?

            weights = candidates.map { |item| item.send(column).to_f }
            total = weights.sum
            random = rand * total

            cumulative = 0.0
            candidates.each_with_index do |item, i|
              cumulative += weights[i]
              if random <= cumulative
                selected << item
                candidates.delete(item)
                break
              end
            end
          end

          selected
        end

        def mysql?
          connection.adapter_name =~ /mysql/i
        end

        def sqlite?
          connection.adapter_name =~ /sqlite/i
        end
    end
  end
end
