defmodule FederationBot.Mastodon do
  def client() do
    ExMastodon.REST.API.client(
      Application.get_env(:federation_bot, :mastodon)[:base_url],
      Application.get_env(:federation_bot, :mastodon)[:access_token]
    )
  end

  def follow(%{"id" => id} = _account) do
    client()
    |> ExMastodon.REST.API.post("/api/v1/#{id}/follow")
  end
end
