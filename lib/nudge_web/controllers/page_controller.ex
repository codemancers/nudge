defmodule NudgeWeb.PageController do
  use NudgeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end

  def new(conn, _params) do
    changeset = Nudge.Accounts.change_site(%Site{})
    render(conn, "new.html", changeset: changeset)
  end
end
