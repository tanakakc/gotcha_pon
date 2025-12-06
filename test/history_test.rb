# frozen_string_literal: true

require_relative "test_helper"

class HistoryTest < ActiveSupport::TestCase
  setup do
    TestItem.delete_all
    GotchaPon::History.delete_all
    TestUser.delete_all
  end

  test "records history with nil user using NullUser pattern" do
    item = TestItem.create!(name: "test_item")

    assert_difference "GotchaPon::History.count", 1 do
      GotchaPon::History.record_gotcha(user: nil, items: [ item ])
    end

    history = GotchaPon::History.last
    assert_instance_of GotchaPon::NullUser, history.user
    assert_equal item, history.gotchable
  end

  test "records history with actual user" do
    item = TestItem.create!(name: "test_item")
    user = TestUser.create!(name: "test_user")

    assert_difference "GotchaPon::History.count", 1 do
      GotchaPon::History.record_gotcha(user: user, items: [ item ])
    end

    history = GotchaPon::History.last
    assert_equal user, history.user
    assert_equal item, history.gotchable
  end

  test "records multiple items" do
    items = 3.times.map { |i| TestItem.create!(name: "item_#{i}") }
    user = TestUser.create!(name: "test_user")

    assert_difference "GotchaPon::History.count", 3 do
      GotchaPon::History.record_gotcha(user: user, items: items)
    end
  end

  test "recent scope orders by created_at desc" do
    item = TestItem.create!(name: "test_item")
    GotchaPon::History.record_gotcha(user: nil, items: [ item ])
    GotchaPon::History.record_gotcha(user: nil, items: [ item ])

    histories = GotchaPon::History.recent
    assert histories.first.created_at >= histories.last.created_at
  end

  test "for_user scope filters by user" do
    item = TestItem.create!(name: "test_item")
    user1 = TestUser.create!(name: "user1")
    user2 = TestUser.create!(name: "user2")

    GotchaPon::History.record_gotcha(user: user1, items: [ item ])
    GotchaPon::History.record_gotcha(user: user2, items: [ item ])

    assert_equal 1, GotchaPon::History.for_user(user1).count
    assert_equal 1, GotchaPon::History.for_user(user2).count
  end
end
