# frozen_string_literal: true

require_relative "test_helper"

class PonnableTest < Minitest::Test
  def setup
    @model_class = Class.new(TestItem)
    TestItem.delete_all  # Clean up test data
  end

  def test_includes_ponnable_concern
    assert @model_class.include?(GachaPon::Ponnable)
  end

  def test_gacha_pon_method_exists
    assert_respond_to @model_class, :gacha_pon
  end

  def test_gacha_pon_returns_query_for_single_item
    # Create test items
    3.times { |i| TestItem.create!(name: "item_#{i}") }

    query = TestItem.gacha_pon(user: "test_user")
    assert_respond_to query, :first

    result = query.first
    assert_instance_of TestItem, result
  end

  def test_gacha_pon_returns_query_for_multiple_count
    # Create test items
    5.times { |i| TestItem.create!(name: "item_#{i}") }

    query = TestItem.gacha_pon(user: "test_user", count: 3)
    results = query.to_a

    assert_instance_of Array, results
    assert_equal 3, results.length
    results.each { |item| assert_instance_of TestItem, item }
  end

  def test_gacha_pon_returns_empty_when_no_items
    query = TestItem.gacha_pon(user: "test_user")
    result = query.first
    assert_nil result
  end
end
