defmodule Nudge.Accounts.Site do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nudge.Accounts.User
  alias Nudge.Sites.Event

  schema "sites" do
    field :active, :boolean, default: false
    field :tz, :string, default: "UTC"
    field :url, :string

    belongs_to :user, User
    has_many :events, Event

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:url, :tz, :active, :user_id])
    |> validate_required([:url, :tz, :active, :user_id])
    |> validate_url(:url)
  end

  defp validate_url(changeset, field, opts \\ []) do
    validate_change(changeset, field, fn _, value ->
      case URI.parse(value) do
        %URI{scheme: nil} ->
          [{field, Keyword.get(opts, :message, "is missing a scheme (e.g. https)")}]

        %URI{host: host} when host in [nil, ""] ->
          [{field, Keyword.get(opts, :message, "is missing a host")}]

        _ ->
          []
      end
    end)
  end
end
