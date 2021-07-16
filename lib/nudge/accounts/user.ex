defmodule Nudge.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @cast_fields ~w(email password password_hash name)a
  @required_fields ~w(email password name)a
  @email_regex ~r(^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,5}$)

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :name, :string
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, Pbkdf2.add_hash(password))

      _ ->
        changeset
    end
  end
end
