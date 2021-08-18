defmodule NudgeWeb.SiteController do
  use NudgeWeb, :controller

  def new(conn, _params) do
    changeset = Nudge.Accounts.change_site(%Nudge.Accounts.Site{})
    render(conn, "new.html", changeset: changeset)
  end
end
