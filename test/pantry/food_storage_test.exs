defmodule Pantry.FoodStorageTest do
  use Pantry.DataCase

  alias Pantry.FoodStorage

  describe "items" do
    alias Pantry.FoodStorage.Item

    import Pantry.FoodStorageFixtures

    @invalid_attrs %{name: nil, unit: nil, amount: nil, best_before: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert FoodStorage.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert FoodStorage.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{name: "some name", unit: "some unit", amount: "some amount", best_before: "some best_before"}

      assert {:ok, %Item{} = item} = FoodStorage.create_item(valid_attrs)
      assert item.name == "some name"
      assert item.unit == "some unit"
      assert item.amount == "some amount"
      assert item.best_before == "some best_before"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FoodStorage.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{name: "some updated name", unit: "some updated unit", amount: "some updated amount", best_before: "some updated best_before"}

      assert {:ok, %Item{} = item} = FoodStorage.update_item(item, update_attrs)
      assert item.name == "some updated name"
      assert item.unit == "some updated unit"
      assert item.amount == "some updated amount"
      assert item.best_before == "some updated best_before"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = FoodStorage.update_item(item, @invalid_attrs)
      assert item == FoodStorage.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = FoodStorage.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> FoodStorage.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = FoodStorage.change_item(item)
    end
  end
end
