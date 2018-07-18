defmodule PhoenixApi101.OAuth2.User do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [usec: false]

  schema "users" do
    field(:password, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(oauth, attrs) do
    oauth
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 8)
    |> validate_format(:username, ~r"^[a-zA-Z\d\s]+$")
    |> unique_constraint(:username, [oauth])
  end
end
