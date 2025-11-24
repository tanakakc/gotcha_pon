# frozen_string_literal: true

require "rails/generators/active_record"

module GotchaPon
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Creates GotchaPon migration and initializer"

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def create_history_migration
        migration_template "create_gotcha_pon_histories.rb", "db/migrate/create_gotcha_pon_histories.rb"
      end

      def create_initializer
        template "gotcha_pon.rb", "config/initializers/gotcha_pon.rb"
      end
    end
  end
end
