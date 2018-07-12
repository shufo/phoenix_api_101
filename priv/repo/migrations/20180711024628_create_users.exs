defmodule PhoenixApi101.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string

      timestamps()
    end
create(unquote_splicing(:user,[:username]))
  end
end
