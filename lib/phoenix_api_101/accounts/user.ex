defmodule PhoenixApi101.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias PhoenixApi101.Accounts.User
  alias Comeonin.Bcrypt

  @timestamps_opts [usec: false]

  schema "users" do
    field(:password, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 8)
    |> validate_format(:username, ~r/^[a-zA-Z0-9\s]+$/)

    # |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = chgset) do
    change(chgset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(chgset), do: chgset
end
