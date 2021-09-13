defmodule Nudge.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :body, :string
      add :start_date, :string
      add :end_date, :string

      timestamps()
    end
  end
end
