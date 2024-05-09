defmodule Pantry.Food do
  import Ecto.Query
  alias Phoenix.PubSub
  alias Pantry.Repo
  alias Pantry.Food.Item

  @topic "inventory"

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
    insert_result =
      %Item{}
      |> Item.changeset(attrs)
      |> Repo.insert()

    case insert_result do
      {:ok, result} ->
        PubSub.broadcast(Pantry.PubSub, @topic, {:food, list_items()})
        {:ok, result}
      insert_result ->
        insert_result
    end
  end

  def remove_item(%Item{} = item) do
    case Repo.delete(item) do
      {:ok, result} ->
        PubSub.broadcast(Pantry.PubSub, @topic, {:food, list_items()})
        {:ok, result}
      result ->
        result
    end
  end
end
