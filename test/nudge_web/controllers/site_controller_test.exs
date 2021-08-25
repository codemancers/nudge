defmodule NudgeWeb.SiteControllerTest do
  use NudgeWeb.ConnCase
  use Plug.Test
  @create_attrs %{active: true, tz: "12.30", url: "https://example.com"}
  @invalid_attrs %{active: nil, tz: nil, url: nil}

  def fixture(:site) do
    {:ok, site} = Nudge.Accounts.create_site(@create_attrs)
    site
  end

  def fixture(:user) do
    user_attrs = %{
      "email" => "abc@email.com",
      "password" => "passworddd",
      "name" => "name"
    }

    {:ok, user} = Nudge.Accounts.create_user(user_attrs)
    user
  end

  describe "create site" do
    setup [:create_user]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = Plug.Test.init_test_session(conn, current_user_id: user.id)
      conn = post(conn, Routes.site_path(conn, :create), site: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.site_path(conn, :show, id)

      conn = get(conn, Routes.site_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Your Site"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = Plug.Test.init_test_session(conn, current_user_id: user.id)
      conn = post(conn, Routes.site_path(conn, :create), site: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Site"
    end

    test "if not logged in", %{conn: conn} do
      conn = post(conn, Routes.site_path(conn, :create), site: @valid_attrs)
      assert html_response(conn, 302) =~ "<html><body>You are being <a href=\"/login\">redirected</a>.</body></html>"
    end
  end

  defp create_site(_) do
    site = fixture(:site)
    %{site: site}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
