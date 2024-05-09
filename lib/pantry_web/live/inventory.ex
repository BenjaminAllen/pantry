defmodule PantryWeb.Inventory do
  use PantryWeb, :live_view
  alias Pantry.Food
  alias Phoenix.PubSub

  @topic "inventory"

  def mount(_params, _session, socket) do
    PubSub.subscribe(Pantry.PubSub, @topic)
    {:ok, assign(socket, :items, Food.list_items())}
  end

  def handle_info({:food, items}, socket) do
    {:noreply, assign(socket, items: items)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Items
    </.header>

    <.table id="items" rows={@items}>
      <:col :let={item} label="Name"><%= item.name %></:col>
      <:col :let={item} label="Amount"><%= amount_and_unit(item) %></:col>
      <:col :let={item} label="Best Before"><%= best_before(item) %></:col>
      <:col :let={item} label="Days Remaining"><%= days_remaining(item)%></:col>
      <:action :let={item}>
        <.link href={~p"/items/#{item}"} method="delete">
          <.button>Remove</.button>
        </.link>
      </:action>
    </.table>

    <div>
      <.link href={~p"/items/new"}>
        <.button>Add Item</.button>
      </.link>
    </div>
    """
  end

  defp amount_and_unit(%{amount: amount, unit: unit}) do
    "#{amount} #{unit}"
  end

  defp days_remaining(%{best_before: best_before}) do
    remaining = Timex.diff(best_before, Timex.now, :days)
    cond do
      remaining < 0 ->
       "#{remaining} (Expired!)"
      remaining == 0 ->
        "#{remaining} (Use Today!)"
      true ->
        remaining
    end
  end

  def best_before(%{best_before: best_before}) do
    Calendar.strftime(best_before, "%d-%m-%y")
  end
end
