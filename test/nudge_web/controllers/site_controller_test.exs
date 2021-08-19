defmodule NudgeWeb.SiteControllerTest do
  use NudgeWeb.ConnCase

  describe "new detail" do
    test "GET /site", %{conn: conn} do
      conn = get(conn, "/site")
      assert html_response(conn, 302) =~ "<html><body>You are being <a href=\"/login\">redirected</a>.</body></html>"
    end
  end
end
