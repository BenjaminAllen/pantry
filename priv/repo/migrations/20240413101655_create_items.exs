defmodule Pantry.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :amount, :decimal
      add :unit, :string
      add :tags, {:array, :string}
      add :best_before, :date

      timestamps(type: :utc_datetime)
    end
  end
end
