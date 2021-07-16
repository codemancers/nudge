defmodule NudgeWeb.PageController do
  use NudgeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
