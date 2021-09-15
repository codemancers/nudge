defmodule NudgeWeb.EventController do
  use NudgeWeb, :controller
  alias Nudge.Sites
  alias Nudge.Sites.Event

  def new(conn, _params) do
    changeset = Sites.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{
        "event" => %{
          "title" => title,
          "body" => body,
          "start_date" => start_date,
          "end_date" => end_date,
          "kind" => kind,
          "respect_dnd" => dnd
        }
      }) do
    IO.inspect(conn.assigns)

    case Sites.create_event(%{
           "title" => title,
           "body" => body,
           "start_date" => start_date,
           "end_date" => end_date,
           "kind" => kind,
           "respect_dnd" => dnd,
           "site_id" => 7
         }) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Site created successfully.")
        |> redirect(to: Routes.site_event_path(conn, :index, :id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, %{"site_id" => id}) do
    id = 7
    site_id = Nudge.Accounts.get_site!(id)

    IO.inspect(site_id)
    events = Sites.list_site_events(site_id)
    render(conn, "index.html", sites: events)
  end
end
