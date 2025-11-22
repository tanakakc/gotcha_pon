# frozen_string_literal: true

require_relative "test_helper"

class PonnableTest < Minitest::Test
  def setup
    @model_class = Class.new(TestItem)
  end

  def test_includes_ponnable_concern
    assert @model_class.include?(GachaPon::Ponnable)
  end

  def test_has_gacha_pon_configuration_attribute
    assert_respond_to @model_class, :gacha_pon_configuration
  end

  def test_gacha_pon_config_method_exists
    assert_respond_to @model_class, :gacha_pon_config
  end

  def test_gacha_pon_method_exists
    assert_respond_to @model_class, :gacha_pon
  end

  def test_gacha_pon_config_sets_configuration
    @model_class.gacha_pon_config(
      rules: { test: [] },
      default_rule: :test
    )

    config = @model_class.gacha_pon_configuration
    assert_equal :test, config[:default_rule]
    assert_equal({ test: [] }, config[:rules])
  end

  def test_gacha_pon_method_raises_not_implemented
    assert_raises NotImplementedError do
      @model_class.gacha_pon(user: "test_user")
    end
  end
end
