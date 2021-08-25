defmodule NudgeWeb.SiteController do
  use NudgeWeb, :controller

  def index(conn, _params) do
    sites = Nudge.Accounts.list_sites()
    render(conn, "index.html", sites: sites)
  end

  def new(conn, _params) do
    changeset = Nudge.Accounts.change_site(%Nudge.Accounts.Site{})
    render(conn, "new.html", changeset: changeset)
  end
  def create(conn, %{"site" => %{"active" => active, "tz" => tz, "url" => url}}) do
    case Nudge.Accounts.create_site(%{active: active, tz: tz, url: url, user_id: conn.assigns.current_user.id}) do
      {:ok, site} ->
        conn
        |> put_flash(:info, "Site created successfully.")
        |> redirect(to: Routes.site_path(conn, :show, site))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  def show(conn, %{"id" => id}) do
    site = Nudge.Accounts.get_site!(id)
    render(conn, "show.html", site: site)
  end
end
