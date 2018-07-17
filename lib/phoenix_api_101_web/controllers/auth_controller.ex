defmodule PhoenixApi101Web.AuthController do
  use PhoenixApi101Web, :controller
  use Phoenix.Socket

  alias PhoenixApi101.Accounts
  alias PhoenixApi101.Accounts.User
  alias JaSerializer.Params
  alias PhoenixApi101.Repo
  import Ecto.Changeset
  import Plug.Conn
require Logger

  def create(conn, %{"grant_type" => grant_type, "password" => password, "username" => username}) do

    cond do
      grant_type != "password" -> put_status(conn, :unprocessable_entity)

      username == nil || password == nil -> send_resp(conn, :unauthorized, "")

      true
        -> conn
          |> put_status(:created)
          |> render("index.json-api", data: %{"access_token" => "sfdgfhdfs"})
        
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
