defmodule PhoenixApi101Web.AuthController do
  use PhoenixApi101Web, :controller
  use Phoenix.Socket

  alias PhoenixApi101.Accounts
  alias PhoenixApi101.Accounts.User
  alias JaSerializer.Params
  alias PhoenixApi101.Repo
  alias ExOauth2Provider.Token

  import ExOauth2Provider.Token

  import Ecto.Changeset
  import Plug.Conn
require Logger

  def create(conn, params) do
    case Token.grant(params) do
      {:ok, access_token} ->
        json(conn, access_token)

        {:error, error, status} ->
        conn
        |> put_status(status)
        |> json(error)
    end


 end

  def profile(conn, %{"grant_type" => grant_type, "password" => password, "username" => username}) do
    
    cond do
      grant_type != "password" -> Logger.warn  "gggggg!"

      username == nil || password == nil -> send_resp(conn, :unauthorized, "")

      true -> send_resp(conn, :ok, "")
        
    end


 end 
end
