defmodule Nudge.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :body, :string
      add :start_date, :string
      add :end_date, :string
      add :kind, :string
      add :respect_dnd, :boolean, default: false, null: false
      add :site_id, references(:sites, on_delete: :nothing)


      timestamps()
    end
  end
end
