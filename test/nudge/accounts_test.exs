defmodule Nudge.AccountsTest do
  use Nudge.DataCase

  alias Nudge.Accounts

  describe "users" do
    alias Nudge.Accounts.User

    @valid_attrs %{email: "user@test.com", name: "some name", password: "some password"}
    @update_attrs %{
      email: "updated@test.com",
      name: "some updated name",
      password: "some updated password"
    }
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      [%User{} = u] = Accounts.list_users()
      assert u.id == user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "user@test.com"
      assert String.starts_with?(user.password_hash, "$pbkdf2-")
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = updated} = Accounts.update_user(user, @update_attrs)
      assert updated.email == "updated@test.com"
      assert updated.password_hash != user.password_hash
      assert String.starts_with?(updated.password_hash, "$pbkdf2-")
      assert updated.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.id == Accounts.get_user!(user.id).id
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
