# frozen_string_literal: true

require_relative "test_helper"

class GotchableTest < ActiveSupport::TestCase
  setup do
    @model_class = Class.new(TestItem)
    TestItem.delete_all
    GotchaPon::History.delete_all
    TestUser.delete_all
    # Reset history tracking state
    TestItem.gotcha_pon_track_history = false
  end

  # Basic functionality tests
  test "includes gotchable concern" do
    assert @model_class.include?(GotchaPon::Gotchable)
  end

  test "responds to gotcha_pon method" do
    assert_respond_to @model_class, :gotcha_pon
  end

  test "enables history tracking when track_gotcha_pon_history is called" do
    @model_class.track_gotcha_pon_history
    assert @model_class.gotcha_pon_track_history
  end

  # Gacha execution tests
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

  # History recording tests
  test "records history with nil user using NullUser pattern" do
    item = TestItem.create!(name: "test_item")
    TestItem.track_gotcha_pon_history

    assert_difference "GotchaPon::History.count", 1 do
      TestItem.gotcha_pon
    end

    history = GotchaPon::History.last
    assert_not_nil history
    assert_nil history.read_attribute(:user_id)
    assert_nil history.read_attribute(:user_type)
    assert_instance_of GotchaPon::NullUser, history.user
    assert_equal "anonymous", history.user.name
    assert_nil history.user.id
    assert_not history.user.persisted?
    assert_equal item, history.gotchable
  end

  test "records history with actual user" do
    item = TestItem.create!(name: "test_item")
    TestItem.track_gotcha_pon_history
    user = TestUser.create!(name: "test_user")

    assert_difference "GotchaPon::History.count", 1 do
      TestItem.gotcha_pon(user: user)
    end

    history = GotchaPon::History.last
    assert_not_nil history
    assert_equal user.id, history.read_attribute(:user_id)
    assert_equal "TestUser", history.read_attribute(:user_type)
    assert_equal user, history.user
    assert_equal item, history.gotchable
  end

  test "does not record history when tracking is disabled" do
    TestItem.create!(name: "test_item")
    # Don't enable tracking

    assert_no_difference "GotchaPon::History.count" do
      TestItem.gotcha_pon
    end
  end
end
