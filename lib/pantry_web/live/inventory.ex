defmodule PantryWeb.Inventory do
  use PantryWeb, :live_view
  alias Pantry.Food
  alias Phoenix.PubSub

  @topic "inventory"

  def mount(_params, _session, socket) do
    PubSub.subscribe(Pantry.PubSub, @topic)
    pantry_items(Food.list_items())
    {:ok, assign(socket, :items, Food.list_items())}
  end

  def handle_info({:food, items}, socket) do
    IO.inspect(items, label: :food_updated)
    {:noreply, assign(socket, items: items)}
  end

  def handle_event("freeze", %{"value" => id}, socket) do
    Food.freeze_item(id)
    {:noreply, socket}
  end

  def handle_event("defrost", %{"value" => id}, socket) do
    Food.defrost_item(id)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Pantry
    </.header>

    <.table id="items" rows={pantry_items(@items)}>
      <:col :let={item} label="Name"><%= item.name %></:col>
      <:col :let={item} label="Amount"><%= amount_and_unit(item) %></:col>
      <:col :let={item} label="Best Before"><%= best_before(item) %></:col>
      <:col :let={item} label="Days Remaining"><%= days_remaining(item) %></:col>
      <:col :let={item} label="Previously Frozen"><%= previously_frozen?(item) %></:col>
      <:action :let={item}>
        <.link href={~p"/items/#{item}"} method="delete">
          <.button>Remove</.button>
        </.link>
      </:action>
      <:action :let={item}>
        <.button
          type="submit"
          name="freeze"
          phx-click="freeze"
          value={item.id}
          disabled={previously_frozen?(item)}
        >
          Freeze
        </.button>
      </:action>
    </.table>

    <div>
      <.link href={~p"/items/new"}>
        <.button>Add Item</.button>
      </.link>
    </div>

    <br /><br /><br />
    <.header>
      Frozen
    </.header>

    <.table id="items" rows={frozen_items(@items)}>
      <:col :let={item} label="Name"><%= item.name %></:col>
      <:col :let={item} label="Amount"><%= amount_and_unit(item) %></:col>
      <:col :let={item} label="Frozen On"><%= best_before(item) %></:col>
      <:action :let={item}>
        <.link href={~p"/items/#{item}"} method="delete">
          <.button>Remove</.button>
        </.link>
      </:action>
      <:action :let={item}>
        <.button type="submit" name="defrost" phx-click="defrost" value={item.id}>Defrost</.button>
      </:action>
    </.table>
    """
  end

  defp amount_and_unit(%{amount: amount, unit: unit}) do
    "#{amount} #{unit}"
  end

  defp days_remaining(%{best_before: best_before}) do
    remaining = Timex.diff(best_before, Timex.now(), :days)

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

  def frozen_on(%{frozen_on: frozen_on}) do
    Calendar.strftime(frozen_on, "%d-%m-%y")
  end

  def pantry_items(items) do
    Enum.filter(items, &(&1.frozen_on == nil || &1.defrosted_on != nil))
    |> IO.inspect(label: :pantry_items)
  end

  def frozen_items(items) do
    Enum.filter(items, &(&1.frozen_on != nil && &1.defrosted_on == nil))
    |> IO.inspect(label: :frozen_items)
  end

  defp previously_frozen?(item) do
    item.frozen_on != nil
  end
end
