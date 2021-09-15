defmodule Nudge.Sites.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nudge.Accounts.Site

  schema "events" do
    field :body, :string
    field :end_date, :string
    field :start_date, :string
    field :title, :string
    field :kind, :string, default: "banner"
    field :respect_dnd, :boolean, default: false

    belongs_to :site, Site

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :body, :start_date, :end_date, :kind, :respect_dnd, :site_id])
    |> validate_required([:title, :body, :start_date, :end_date, :kind, :respect_dnd, :site_id])
  end
end
