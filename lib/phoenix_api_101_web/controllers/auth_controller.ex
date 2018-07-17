defmodule PhoenixApi101Web.AuthController do
  use PhoenixApi101Web, :controller
  alias PhoenixApi101.Accounts.User

  plug(:action)

  def create(conn, params) do
    user = User.create(params)

    render(conn, "user.json", %{token: Phoenix.Token.sign(conn, "user salt", user.id), user: user})
  end

  def callback(conn, %{"code" => code}) do
  end
end
