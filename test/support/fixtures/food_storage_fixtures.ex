defmodule Pantry.FoodStorageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pantry.FoodStorage` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        amount: "some amount",
        best_before: "some best_before",
        name: "some name",
        unit: "some unit"
      })
      |> Pantry.FoodStorage.create_item()

    item
  end
end
