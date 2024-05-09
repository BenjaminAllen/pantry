defmodule Pantry.Repo.Migrations.AddFrozenDates do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :frozen_on, :date
      add :defrosted_on, :date
    end
  end
end
