defmodule Nudge.Sites.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :body, :string
    field :end_date, :string
    field :start_date, :string
    field :title, :string

    belongs_to :sites, Site

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :body, :start_date, :end_date, :sites_id])
    |> validate_required([:title, :body, :start_date, :end_date])
  end
end
