# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/migration'

module GotchaPon
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path('templates', __dir__)
      
      desc "Creates GotchaPon migration and model"
      
      def self.next_migration_number(dirname)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      
      def create_migration
        migration_template 'create_gotcha_pon_histories.rb.erb',
                         'db/migrate/create_gotcha_pon_histories.rb'
      end
      
      def create_model
        template 'history.rb.erb', 'app/models/gotcha_pon/history.rb'
      end
      
      def create_initializer
        template 'gotcha_pon.rb.erb', 'config/initializers/gotcha_pon.rb'
      end
    end
  end
end