defmodule Pantry.Food do
  import Ecto.Query

  alias Pantry.Repo
  alias Pantry.Food.Item

  def get_item(id) do
    Repo.get(Item, id)
  end

  def get_items_by_tag(tag) do
    Item
    |> where([i], ^tag in i.tags)
    |> Repo.all
  end

  def list_items() do
    Item
    |> order_by([i], i.best_before)
    |> Repo.all()
  end

  def add_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def remove_item(%Item{} = item) do
    Repo.delete(item)
  end
end
