defmodule NudgeWeb.SiteControllerTest do
  use NudgeWeb.ConnCase
  use Plug.Test
  import Nudge.Factory

  @create_attrs %{active: true, tz: "UTC", url: "https://example.com"}
  @invalid_attrs %{active: nil, tz: nil, url: nil}

  describe "create/2" do
    setup [:create_user]

    test "redirects after creating when data is valid", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> post(Routes.site_path(conn, :create), site: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.site_path(conn, :show, id)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> post(Routes.site_path(conn, :create), site: @invalid_attrs)

      assert html_response(conn, 200) =~ "Create Site"
    end
  end

  describe "index/2" do
    setup [:create_user]

    test "lists all sites when signed in", %{conn: conn, user: user} do
      site = fixture(:site, %{user_id: user.id})

      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> get(Routes.site_path(conn, :index))

      assert html_response(conn, 200) =~ site.url
    end
  end

  describe "toggle/2" do
    setup [:create_user]
    setup [:create_site]

    test "redirects and display flash when active is false", %{conn: conn, user: user, site: site} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> post(Routes.site_path(conn, :toggle, site.id, %{active: false}))

      assert redirected_to(conn, 302) =~ "/sites"
      assert get_flash(conn, :info) == "Deactivated"
    end

    test "display flash when active is true", %{conn: conn, user: user, site: site} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user.id)
        |> post(Routes.site_path(conn, :toggle, site.id, %{active: true}))

      assert redirected_to(conn, 302) =~ "/sites"
      assert get_flash(conn, :info) == "Deactivated"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp create_site(_) do
    site = fixture(:site)
    {:ok, site: site}
  end
end
