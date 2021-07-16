defmodule Nudge.Factory do
  alias Nudge.Accounts

  def user_valid_attrs(attrs \\ %{email: random_email(), name: "some name", password: "some password"}),
    do: attrs

  def user_update_attrs(
        attrs \\ %{
          email: random_email(),
          name: "some updated name",
          password: "some updated password"
        }
      ),
      do: attrs

  def user_invalid_attrs(attrs \\ %{email: nil, name: nil, password: nil}), do: attrs

  def site_valid_attrs(attrs \\ %{active: true, tz: "UTC+0000", url: "https://test.com"}) do
    unless attrs[:user] do
      user = fixture(:user)
      Map.put(attrs, :user_id, user.id)
    else
      attrs
    end
  end

  def site_update_attrs(attrs \\ %{active: false, tz: "UTC+0530", url: "https://updated.test.com"}) do
    unless attrs[:user] do
      user = fixture(:user)
      Map.put(attrs, :user_id, user.id)
    else
      attrs
    end
  end

  def site_invalid_attrs(attrs \\ %{active: nil, tz: nil, url: nil, user_id: nil}), do: attrs

  def fixture(kind, attrs \\ %{})

  def fixture(:user, attrs) do
    {:ok, user} =
      attrs
      |> Enum.into(user_valid_attrs())
      |> Accounts.create_user()

    user
  end

  def fixture(:site, attrs) do
    {:ok, site} =
      attrs
      |> Enum.into(site_valid_attrs())
      |> Accounts.create_site()

    site
  end

  defp random_string_of_len(n, set \\ "abcdefghijklmnopqrstuvwxyz") do
    set
    |> String.split("", trim: true)
    |> Enum.take_random(n)
    |> Enum.join()
  end

  defp random_email() do
    name = random_string_of_len(4)
    domain = random_string_of_len(5)
    "#{name}@#{domain}.com"
  end
end
