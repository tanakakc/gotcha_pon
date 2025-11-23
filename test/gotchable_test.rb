# frozen_string_literal: true

require_relative "test_helper"

class GotchableTest < Minitest::Test
  def setup
    @model_class = Class.new(TestItem)
    TestItem.delete_all  # Clean up test data
  end

  def test_includes_gotchable_concern
    assert @model_class.include?(GotchaPon::Gotchable)
  end

  def test_gotcha_pon_method_exists
    assert_respond_to @model_class, :gotcha_pon
  end

  def test_gotcha_pon_returns_single_item_for_count_1
    # Create test items
    3.times { |i| TestItem.create!(name: "item_#{i}") }

    result = TestItem.gotcha_pon
    assert_instance_of TestItem, result
  end

  def test_gotcha_pon_returns_array_for_multiple_count
    # Create test items
    5.times { |i| TestItem.create!(name: "item_#{i}") }

    results = TestItem.gotcha_pon(count: 3)
    assert_instance_of Array, results
    assert_equal 3, results.length
    results.each { |item| assert_instance_of TestItem, item }
  end

  def test_gotcha_pon_returns_nil_when_no_items
    result = TestItem.gotcha_pon
    assert_nil result
  end

  def test_track_gotcha_pon_history_enables_history
    @model_class.track_gotcha_pon_history
    assert @model_class.gotcha_pon_track_history
  end
end