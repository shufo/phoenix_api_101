defmodule PhoenixApi101Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  失敗したときの処理
  """
  use PhoenixApi101Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PhoenixApi101Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(PhoenixApi101Web.ErrorView, :"404")
  end

  def call(conn, {:error, :conflict}) do
    conn
    |> put_status(:conflict)
    |> render(PhoenixApi101Web.ErrorView, :"409")
  end

  def call(conn, {:error, 422}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(PhoenixApi101Web.ErrorView, :"422")
  end
end
