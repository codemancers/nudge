defmodule NudgeWeb.SessionControllerTest do
  use NudgeWeb.ConnCase
  use Plug.Test
  alias Nudge.Accounts

  describe "login/2" do
    test "render login page", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :login))
      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "create_session/2" do
    setup [:create_user]

    test "login and redirect to welcome page", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.session_path(conn, :create_session),
          session: %{email: "valid@example.com", password: "password"}
        )

      assert get_flash(conn, :info) == "Welcome back!"
      assert redirected_to(conn) == Routes.page_path(conn, :welcome)
    end

    test "flash when email is invalid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.session_path(conn, :create_session),
          session: %{email: "invalid@example.com", password: "password"}
        )

      assert html_response(conn, 200) =~ "Login"
      assert get_flash(conn, :error) == "Sorry! We couldn't find the user"
    end

    test "flash when password is incorrect", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.session_path(conn, :create_session),
          session: %{email: "valid@example.com", password: "invalid"}
        )

      assert html_response(conn, 200) =~ "Login"
      assert get_flash(conn, :error) == "Invalid email/password combination"
    end
  end

  describe "signup/2" do
    test "render signup page", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :login))
      assert html_response(conn, 200) =~ "Signup"
    end
  end

  describe "create_user/2" do
    test "signup and render welcome page", %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create_user),
          user: %{email: "email@example.com", password: "password", name: "name"}
        )

      assert get_flash(conn, :info) == "Yey! You are signed up!"
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "render signup page when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create_user), user: %{email: nil, password: nil, name: "name"})

      assert html_response(conn, 200) =~ "Signup"
    end
  end

  describe "logout/2" do
    setup [:create_user]

    test "logout to index page", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> get(Routes.session_path(conn, :logout))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp fixture(:user) do
    user_attrs = %{
      "email" => "valid@example.com",
      "password" => "password",
      "name" => "name"
    }

    {:ok, user} = Nudge.Accounts.create_user(user_attrs)
    user
  end
end
