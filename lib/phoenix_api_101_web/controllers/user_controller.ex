defmodule PhoenixApi101Web.UserController do
  use PhoenixApi101Web, :controller

  alias PhoenixApi101.Accounts
  alias PhoenixApi101.Accounts.User
  alias JaSerializer.Params
  alias PhoenixApi101.Repo

  action_fallback(PhoenixApi101Web.FallbackController)

  def index(conn, params) do
    page =
      User
      |> Repo.paginate(params)

    conn
    |> Scrivener.Headers.paginate(page)
    |> render("index.json-api", data: page.entries)
  end

  def create(conn, %{"data" => data = %{"type" => "user", "attributes" => user_params}}) do
    # if Repo.get_by(User, username: user_params["username"]) == nil do
    #  IO.puts("create")

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json-api", data: user)
    end

    # else
    #  IO.puts("error")

    #  conn
    #  |> put_status(409)
    # end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{
        "id" => id,
        "data" => data = %{"type" => "user", "attributes" => user_params}
      }) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json-api", data: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
