defmodule NudgeWeb.SiteChannelTest do
  use NudgeWeb.ChannelCase, async: true
  alias NudgeWeb.SiteSocket
  import Nudge.Factory, only: [fixture: 1]

  setup do
    site = fixture(:site)
    token = Phoenix.Token.sign(NudgeWeb.Endpoint, "site auth", site.id)

    {:ok, socket} = connect(SiteSocket, %{"token" => token})
    {:ok, _, socket} = subscribe_and_join(socket, NudgeWeb.SiteChannel, "sites:#{site.id}")

    %{socket: socket, site: site}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to site:1", %{socket: socket} do
    push(socket, "shout", %{"hello" => "all"})
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end
end
