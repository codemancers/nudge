defmodule NudgeWeb.SiteSocket do
  use Phoenix.Socket

  alias Nudge.Accounts

  ## Channels
  channel "sites:*", NudgeWeb.SiteChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a site. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :site_id, verified_site_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  # 1 day
  @max_age 60 * 60 * 24 * 1
  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(NudgeWeb.Endpoint, "site auth", token, max_age: @max_age) do
      {:ok, site_id} ->
        site = Accounts.get_site!(site_id)

        socket =
          socket
          |> assign(:current_site_id, site_id)
          |> assign(:current_site, site)

        {:ok, socket}

      {:error, _reason} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given site:
  #
  #     def id(socket), do: "site_socket:#{socket.assigns.site_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given site:
  #
  #     NudgeWeb.Endpoint.broadcast("site_socket:#{site.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(socket) do
    case socket.assigns[:current_site_id] do
      nil -> nil
      site_id -> "sites_socket:#{site_id}"
    end
  end
end
