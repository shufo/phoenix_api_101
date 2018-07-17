defmodule PhoenixApi101Web.PostController do
  use PhoenixApi101Web, :controller

  alias PhoenixApi101.Blogs
  alias PhoenixApi101.Blogs.Post
  alias JaSerializer.Params
  alias PhoenixApi101.Repo

  action_fallback(PhoenixApi101Web.FallbackController)

  def index(conn, params) do
    #    posts = Blogs.list_posts()

    page =
      Post
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json-api", data: page.entries)
  end

  def create(conn, %{"data" => data = %{"type" => "post", "attributes" => post_params}}) do
    with {:ok, %Post{} = post} <- Blogs.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json-api", data: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)
    render(conn, "show.json-api", data: post)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "post", "attributes" => post_params}
      }) do
    post = Blogs.get_post!(id)

    with {:ok, %Post{} = post} <- Blogs.update_post(post, post_params) do
      render(conn, "show.json-api", data: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blogs.get_post!(id)

    with {:ok, %Post{}} <- Blogs.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
