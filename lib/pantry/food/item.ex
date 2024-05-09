defmodule Pantry.Food.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :unit, :string
    field :amount, :decimal
    field :tags, {:array, :string}
    field :frozen_on, :date
    field :defrosted_on, :date
    field :best_before, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :amount, :unit, :best_before, :frozen_on, :defrosted_on])
    |> validate_required([:name, :amount, :unit, :best_before])
  end
end
