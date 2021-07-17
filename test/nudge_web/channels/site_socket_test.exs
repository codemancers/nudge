defmodule NudgeWeb.SiteSocketTest do
  use NudgeWeb.ChannelCase, async: true
  alias NudgeWeb.SiteSocket
  import Nudge.Factory

  test "authenticate with valid token" do
    site = fixture(:site)
    token = Phoenix.Token.sign(NudgeWeb.Endpoint, "site auth", site.id)

    assert {:ok, socket} = connect(SiteSocket, %{"token" => token})
    assert socket.assigns.current_site == site
    assert socket.assigns.current_site_id == site.id
  end
end
