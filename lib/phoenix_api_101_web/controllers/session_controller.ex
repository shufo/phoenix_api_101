defmodule PhoenixApi101Web.SessionController do
  use PhoenixApi101Web, :controller
  alias PhoenixApi101.Auth
  alias PhoenixApi101.Auth.Guardian
  alias PhoenixApi101.Auth.AuthTokens

  @doc """
  login(create token)
  """
  def login(conn, %{"user" => %{"username" => username, "password" => plain_text_password}}) do
    conn
    |> login_reply(Auth.authenticate_user(username, plain_text_password))
  end

  defp login_reply(conn, {:ok, user}) do
    {:ok, access_token, access_claims, refresh_token, _refresh_claims} = create_token(user)

    response = %{
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: access_claims["exp"]
    }

    render(conn, "login.json", response: response)
  end

  defp login_reply(conn, {:error, _}) do
    response = %{}

    conn
    |> put_status(:unauthorized)
    |> render("login-error.json", response: response)
  end

  defp create_token(user) do
    {:ok, access_token, access_claims} =
      Guardian.encode_and_sign(user, %{}, token_type: "access", ttl: {1, :weeks})

    {:ok, refresh_token, refresh_claims} =
      Guardian.encode_and_sign(
        user,
        %{access_token: access_token},
        token_type: "refresh",
        ttl: {4, :weeks}
      )

    {:ok, _a_token} = AuthTokens.after_encode_and_sign(user, access_claims, access_token)
    {:ok, _r_token} = AuthTokens.after_encode_and_sign(user, refresh_claims, refresh_token)
    {:ok, access_token, access_claims, refresh_token, refresh_claims}
  end

  @doc """
  logout(delete token)
  """
  def logout(conn, %{"refresh_token" => refresh_token}) do
    logout_reply(conn, confirm_token(refresh_token), refresh_token)
  end

  defp logout_reply(conn, {:ok, claims}, refresh_token) do
    case AuthTokens.on_revoke(claims, refresh_token) do
      {:ok, _} ->
        with {:ok, access_claims} <- confirm_token(claims["access_token"]) do
          AuthTokens.on_revoke(access_claims, claims["access_token"])
        end

        render(conn, "logout.json", response: %{})

      {:error, _} ->
        logout_reply(conn, {:error, :revoke_error}, refresh_token)
    end
  end

  defp logout_reply(conn, {:error, _}, _) do
    conn
    |> put_status(:bad_request)
    |> render("logout-error.json", response: %{})
  end

  @doc """
  Confirm token
  """
  def confirm_token(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        AuthTokens.on_verify(claims, token)

      _ ->
        {:error, :not_decode_and_verify}
    end
  end

  @doc """
  Refresh Token
  """
  def refresh_token(conn, %{"refresh_token" => refresh_token}) do
    refresh_token_reply(conn, confirm_token(refresh_token), refresh_token)
  end

  defp refresh_token_reply(conn, {:ok, claims}, refresh_token) do
    user = Auth.get_user!(claims["sub"])
    AuthTokens.on_revoke(claims, refresh_token)

    with {:ok, access_claims} <- confirm_token(claims["access_token"]) do
      AuthTokens.on_revoke(access_claims, claims["access_token"])
    end

    login_reply(conn, {:ok, user})
  end

  defp refresh_token_reply(conn, {:error, _}, _) do
    conn
    |> put_status(:bad_request)
    |> render("expired.json", response: %{})
  end
end
