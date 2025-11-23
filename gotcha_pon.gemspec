# frozen_string_literal: true

require_relative "lib/gotcha_pon/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "gotcha_pon"
  s.version     = GotchaPon::VERSION
  s.summary     = "Add gacha functionality to any Rails model."
  s.description = "GotchaPon brings Japanese gacha culture to Rails. Easily add weighted random selection with history tracking to any model."

  s.required_ruby_version = ">= 3.2.0"
  s.license = "MIT"

  s.author   = "tanakakc"
  s.email    = "tanakakc@example.com"
  s.homepage = "https://github.com/tanakakc/gotcha_pon"

  s.files = Dir["lib/**/*", "README.md"]

  s.metadata = {
    "homepage_uri"      => s.homepage,
    "source_code_uri"   => s.homepage,
    "changelog_uri"     => "#{s.homepage}/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  s.add_dependency "rails", ">= 8.0"
end