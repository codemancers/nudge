defmodule Nudge.AccountsTest do
  use Nudge.DataCase

  alias Nudge.Accounts
  import Nudge.Factory

  describe "users" do
    alias Nudge.Accounts.User

    test "list_users/0 returns all users" do
      user = fixture(:user)
      [%User{} = u] = Accounts.list_users()
      assert u.id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = fixture(:user)
      assert Accounts.get_user!(user.id).id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(user_valid_attrs())
      refute is_nil(user.email)
      assert String.starts_with?(user.password_hash, "$pbkdf2-")
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(user_invalid_attrs())
    end

    test "update_user/2 with valid data updates the user" do
      user = fixture(:user)
      assert {:ok, %User{} = updated} = Accounts.update_user(user, user_update_attrs())
      assert updated.email != user.email
      assert updated.password_hash != user.password_hash
      assert String.starts_with?(updated.password_hash, "$pbkdf2-")
      assert updated.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = fixture(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, user_invalid_attrs())
      assert user.id == Accounts.get_user!(user.id).id
    end

    test "delete_user/1 deletes the user" do
      user = fixture(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = fixture(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "sites" do
    alias Nudge.Accounts.Site

    test "list_sites/0 returns all sites" do
      site = fixture(:site)
      assert Accounts.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = fixture(:site)
      assert Accounts.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      user = fixture(:user)
      attrs = Map.put(site_valid_attrs(), :user_id, user.id)
      assert {:ok, %Site{} = site} = Accounts.create_site(attrs)
      assert site.active == true
      assert site.tz == "UTC+0000"
      assert site.url == "https://test.com"
      assert site.user_id == user.id
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_site(site_invalid_attrs())
    end

    test "update_site/2 with valid data updates the site" do
      site = fixture(:site)
      assert {:ok, %Site{} = site} = Accounts.update_site(site, site_update_attrs())
      assert site.active == false
      assert site.tz == "UTC+0530"
      assert site.url == "https://updated.test.com"
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = fixture(:site)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_site(site, site_invalid_attrs())
      assert site == Accounts.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = fixture(:site)
      assert {:ok, %Site{}} = Accounts.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = fixture(:site)
      assert %Ecto.Changeset{} = Accounts.change_site(site)
    end
  end
end
