defmodule FederationBot.Mastodon do
  alias ExMastodon.REST.API

  def client() do
    API.client(
      Application.get_env(:federation_bot, :mastodon)[:base_url],
      Application.get_env(:federation_bot, :mastodon)[:access_token]
    )
  end

  def follow(id) do
    if Mix.env == :prod and !following?(id) do
      client()
      |> API.post("/api/v1/#{id}/follow")
    else
      IO.puts("skip")
      {:ok, "skip"}
    end
  end

  def expand_follows(%{"account" => %{"id" => account_id, "locked" => false}, "reblog" => nil} = _payload) do
    follow(account_id)
  end

  def expand_follows(%{"account" => %{"id" => account_id, "locked" => false}, "reblog" => %{"account" => %{"id" => account_id, "locked" => false}}} = _payload) do
    follow(account_id)
  end

  def expand_follow(_payload) do
    {:ok}
  end

  def following?(account_id) do
    with {:ok, [body], _headers} <- client() |> API.get("/api/v1/accounts/relationships", [{"id", account_id}]),
         %{"following" => true, "blocking" => false, "requested" => false, "domain_blocking" => false} <- body do
      true
    else
      _ -> false
    end
  end
end
