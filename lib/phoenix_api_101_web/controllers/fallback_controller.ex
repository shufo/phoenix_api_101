defmodule PhoenixApi101Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
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

  def call(conn, {:error, :created}) do
    conn
    |> put_status(:created)
    |> render(PhoenixApi101Web.PageView, :"201")
  end

  def call(conn, {:error, :conflict}) do
    conn
    |> put_status(:conflict)
    |> render(PhoenixApi101Web.ChangesetView, :"409")
  end
end
