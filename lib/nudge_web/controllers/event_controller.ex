defmodule NudgeWeb.EventController do
  use NudgeWeb, :controller
  alias Nudge.Sites
  alias Nudge.Sites.Event

  def new(conn, _params) do
    changeset = Sites.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Sites.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Site created successfully.")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def index(conn, _params) do
    events = Sites.list_events()
    render(conn, "index.html", sites: events)
  end
end
