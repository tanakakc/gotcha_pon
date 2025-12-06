require "test_helper"

class ItemTest < ActiveSupport::TestCase
  setup do
    Item.delete_all
  end

  test "responds to gotcha_pon" do
    assert_respond_to Item, :gotcha_pon
  end

  test "responds to gotcha_pon_with_history" do
    assert_respond_to Item, :gotcha_pon_with_history
  end

  test "gotcha_pon returns random item" do
    3.times { |i| Item.create!(name: "item_#{i}") }

    result = Item.gotcha_pon
    assert_instance_of Item, result
  end

  test "gotcha_pon returns multiple items" do
    5.times { |i| Item.create!(name: "item_#{i}") }

    results = Item.gotcha_pon(count: 3)
    assert_equal 3, results.length
  end
end