defmodule NudgeWeb.PageController do
  use NudgeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def welcome(conn, _params) do
    render(conn, "welcome.html")
  end
end
