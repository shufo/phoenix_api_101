defmodule PhoenixApi101.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:password, :string)

      timestamps()
    end

    # 追加
    create(unique_index(:users, [:username]))
  end
end
