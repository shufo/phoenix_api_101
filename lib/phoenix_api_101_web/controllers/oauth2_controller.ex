defmodule PhoenixApi101Web.OAuth2Controller do
  use PhoenixApi101Web, :controller

  alias PhoenixApi101.OAuth2
  alias PhoenixApi101.OAuth.User
  alias JaSerializer.Params

  action_fallback(PhoenixApi101Web.FallbackController)

  # def index(conn, _parms) do
  #     # render (conn, "token")
  # end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json-api", data: users)
  end

  def create(conn, %{"data" => data = %{"type" => "user", "attributes" => user_params}}) do
    with {:ok, %PhoenixApi101.OAuth2.User{} = user} <- OAuth2.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json-api", data: user)
    end
  end

  #   def update(conn, %{
  #         "id" => id,
  #         "data" => data = %{"type" => "user", "attributes" => user_params}
  #       }) do
  #     user = Accounts.get_user!(id)

  #     with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #       render(conn, "show.json-api", data: user)
  #     end
  #   end
end
