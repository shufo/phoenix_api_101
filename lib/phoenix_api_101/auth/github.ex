defmodule GitHub do
  use OAuth2.Strategy

  def new do
    client =
      OAuth2.Client.new(
        strategy: __MODULE__,
        # 生成したクライアントID
        client_id: "ece3dac2513db42891a9",
        # 生成したクライアントシークレット
        client_secret: "5912608b345b1e8dac562509f1c2758d9bc07fce",
        # 設定したコールバックURL
        redirect_uri: "http://localhost:4000/auth/callback",
        # GitHub API のサイト
        site: "https://api.github.com",
        # GitHub が提供する認証用 URL
        authorize_url: "https://github.com/login/oauth/authorize",
        # Github が提供するトークン取得用 URL
        token_url: "https://github.com/login/oauth/access_token"
      )
  end

  def authorize_url!(params \\ []) do
    new()
    # スコープはひとまず user のみ
    |> put_param(:scope, "user")
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ [], options \\ []) do
    OAuth2.Client.get_token!(new(), params, headers, options)
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
