defmodule PhoenixApi101.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [usec: false]

  schema "posts" do
    field(:body, :string)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
