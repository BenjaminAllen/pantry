defmodule PantryWeb.ItemHTML do
  use PantryWeb, :html

  alias Pantry.Food.Item

  def amount_with_unit(%Item{amount: amount, unit: unit}) do
    "#{amount}#{unit}"
  end

  def best_before(%Item{best_before: best_before}) do
    Calendar.strftime(best_before, "%d-%m-%y")
  end

  def days_remaining(%Item{best_before: best_before}) do
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

  embed_templates "item_html/*"
end
