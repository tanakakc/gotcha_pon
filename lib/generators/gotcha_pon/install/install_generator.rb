# frozen_string_literal: true

require "rails/generators/active_record"

module GotchaPon
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Creates GotchaPon initializer and optionally history migration"

      class_option :with_history, type: :boolean, default: false,
        desc: "Generate history tracking migration and model"

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def create_initializer
        template "gotcha_pon.rb", "config/initializers/gotcha_pon.rb"
      end

      def create_history_migration
        return unless options[:with_history]

        migration_template "create_gotcha_pon_histories.rb", "db/migrate/create_gotcha_pon_histories.rb"
      end

      def show_post_install_message
        say ""
        say "GotchaPon installed!", :green
        say ""
        say "Example usage:"
        say "  class Item < ApplicationRecord"
        say "    include GotchaPon::Gotchable"
        say "  end"
        say ""
        say "  Item.gotcha_pon        # => random Item"
        say "  Item.gotcha_pon(count: 3)  # => [Item, Item, Item]"
        say ""

        if options[:with_history]
          say ""
          say "History tracking enabled!", :green
          say "Run `rails db:migrate` to create the gotcha_pon_histories table."
          say ""
          say "Example usage with history:"
          say "  item = Item.gotcha_pon"
          say "  GotchaPon::History.record_gotcha(user: current_user, items: item)"
        else
          say "To enable history tracking, run:"
          say "  rails generate gotcha_pon:install --with-history"
        end
      end
    end
  end
end
