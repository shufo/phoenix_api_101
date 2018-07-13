defmodule PhoenixApi101.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> validate_length(:password, min: 8)
    |> validate_format(:username, ~r/^[a-zA-Z0-9\s]+$/)

    # |> unique_constraint(:username, name: "users_username_index")
  end
end
