defmodule NudgeWeb.SessionController do
  use NudgeWeb, :controller

  alias Nudge.Accounts

  def login(conn, _params), do: render(conn, "login.html")

  def create_session(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case login_by_email_and_password(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :welcome))

      {:error, reason, conn} ->
        conn
        |> put_flash(:error, reason)
        |> render("login.html")
    end
  end

  def signup(conn, _params), do: render(conn, "signup.html", changeset: Accounts.change_user(%Accounts.User{}))

  def create_user(conn, %{"user" => %{"email" => email, "password" => pswd, "name" => name}}) do
    case Accounts.create_user(%{email: email, password: pswd, name: name}) do
      {:ok, user} ->
        conn
        |> login_session(user)
        |> put_flash(:info, "Yey! You are signed up!")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "signup.html", changeset: changeset)
    end
  end

  def logout(conn, _params) do
    conn
    |> logout_session()
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  defp login_by_email_and_password(conn, email, given_password) do
    case Accounts.authenticate_user_by_email_passwd(email, given_password) do
      {:ok, user} -> {:ok, login_session(conn, user)}
      {:error, :unauthorized} -> {:error, "Invalid email/password combination", conn}
      {:error, :not_found} -> {:error, "Sorry! We couldn't find the user", conn}
    end
  end

  defp login_session(conn, user) do
    conn
    |> clear_session()
    |> put_session(:user_id, user.id)
    |> put_session(:last_auth_time, DateTime.utc_now())
    |> put_session(:redirect_url, "/")
    |> configure_session(renew: true)
  end

  defp logout_session(conn) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
  end
end
