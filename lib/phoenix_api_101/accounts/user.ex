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
    #    exist_users = Ecto.Adapters.SQL.query!(PhoenixApi101.Repo, :username)

    #    unless PhoenixApi101.Repo.get_by(User, username: user),
    #       do: 
    user
    |> cast(attrs, [:username, :password])
    #    |> validate_exclusion(:username, exist_users)
    |> validate_format(:username, ~r"^[a-zA-Z\d\s]+$")
    |> validate_length(:password, min: 8)
    |> validate_required([:username, :password])
  end
end
