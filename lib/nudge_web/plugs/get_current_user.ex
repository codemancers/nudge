defmodule NudgeWeb.Plug.GetCurrentUser do
  import Plug.Conn

  alias NudgeWeb.Router.Helpers, as: Routes
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Nudge.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      put_current_user(conn)
    end
  end

  def put_current_user(conn) do
    user_id = get_session(conn, :user_id)
    user = Accounts.get_user(user_id)

    if user do
      assign(conn, :current_user, user)
    else
      conn
      |> put_flash(:info, "Seems like you are not logged in! Please login to continue")
      |> put_session(:redirect_url, conn.request_path)
      |> redirect(to: Routes.session_path(conn, :login))
      |> halt()
    end
  end
end
