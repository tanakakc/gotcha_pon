# frozen_string_literal: true

require_relative "test_helper"

class GotchableTest < ActiveSupport::TestCase
  setup do
    @model_class = Class.new(TestItem)
    TestItem.delete_all
    GotchaPon::History.delete_all
    TestUser.delete_all
  end

  test "includes gotchable concern" do
    assert @model_class.include?(GotchaPon::Gotchable)
  end

  test "responds to gotcha_pon method" do
    assert_respond_to @model_class, :gotcha_pon
  end

  test "responds to gotcha_pon_with_history method" do
    assert_respond_to @model_class, :gotcha_pon_with_history
  end

  test "returns single item when count is 1" do
    3.times { |i| TestItem.create!(name: "item_#{i}") }

    result = TestItem.gotcha_pon
    assert_instance_of TestItem, result
  end

  test "returns array of items for multiple count" do
    items = 5.times.map { |i| TestItem.create!(name: "item_#{i}") }

    results = TestItem.gotcha_pon(count: 3)
    assert_instance_of Array, results
    assert_equal 3, results.length
    results.each { |item| assert_instance_of TestItem, item }
    assert (results - items).empty?, "Results should be subset of created items"
  end

  test "returns nil when no items exist" do
    result = TestItem.gotcha_pon
    assert_nil result
  end

  test "returns empty array when no items exist and count > 1" do
    result = TestItem.gotcha_pon(count: 3)
    assert_equal [], result
  end

  test "returns fewer items when count exceeds available items" do
    2.times { |i| TestItem.create!(name: "item_#{i}") }

    results = TestItem.gotcha_pon(count: 5)
    assert_equal 2, results.length
  end

  test "gotcha_pon_with_history returns single item and records history" do
    TestItem.create!(name: "test_item")

    assert_difference "GotchaPon::History.count", 1 do
      result = TestItem.gotcha_pon_with_history
      assert_instance_of TestItem, result
    end
  end

  test "gotcha_pon_with_history returns multiple items and records history" do
    3.times { |i| TestItem.create!(name: "item_#{i}") }

    assert_difference "GotchaPon::History.count", 2 do
      results = TestItem.gotcha_pon_with_history(count: 2)
      assert_equal 2, results.length
    end
  end

  test "gotcha_pon_with_history records user" do
    TestItem.create!(name: "test_item")
    user = TestUser.create!(name: "test_user")

    TestItem.gotcha_pon_with_history(user: user)

    history = GotchaPon::History.last
    assert_equal user, history.user
  end

  test "gotcha_pon_with_history records anonymous user when user is nil" do
    TestItem.create!(name: "test_item")

    TestItem.gotcha_pon_with_history

    history = GotchaPon::History.last
    assert_instance_of GotchaPon::NullUser, history.user
  end

  test "responds to gotcha_pon_weight class method" do
    assert_respond_to TestItem, :gotcha_pon_weight
  end

  test "weighted gotcha_pon returns multiple items" do
    WeightedTestItem.delete_all
    3.times { |i| WeightedTestItem.create!(name: "item_#{i}", weight: 10) }

    results = WeightedTestItem.gotcha_pon(count: 2)
    assert_equal 2, results.length
  end

  test "weighted gotcha_pon excludes zero weight items" do
    WeightedTestItem.delete_all
    WeightedTestItem.create!(name: "zero", weight: 0)
    WeightedTestItem.create!(name: "positive", weight: 5)

    100.times do
      result = WeightedTestItem.gotcha_pon
      assert_equal "positive", result.name
    end
  end

  test "weighted gotcha_pon respects weight probability" do
    WeightedTestItem.delete_all
    WeightedTestItem.create!(name: "high", weight: 90)
    WeightedTestItem.create!(name: "low", weight: 10)

    results = Hash.new(0)
    1000.times do
      item = WeightedTestItem.gotcha_pon
      results[item.name] += 1
    end

    # high should be selected significantly more often (around 90%)
    assert results["high"] > results["low"] * 2, "High weight item should be selected much more often"
  end
end
