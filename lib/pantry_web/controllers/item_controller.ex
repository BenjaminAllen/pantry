defmodule PantryWeb.ItemController do
  use PantryWeb, :controller

  alias Pantry.Food

  def new(conn, _params) do
    changeset = Food.Item.changeset(%Food.Item{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"item" => item}) do
    case Food.add_item(item) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "#{item.name} added")
        |> redirect(to: ~p"/inventory")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Food.get_item(id)
    {:ok, _item} = Food.remove_item(item)

    conn
    |> put_flash(:info, "Removed #{item.name}")
    |> redirect(to: ~p"/inventory")
  end
end
