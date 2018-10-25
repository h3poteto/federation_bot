defmodule FederationBot.Bot do

  use ExMastodon.Stream

  def start_link(initial_state) do
    ExMastodon.Stream.WebSocket.start_link(
      __MODULE__,
      initial_state,
      "#{Application.get_env(:federation_bot, :mastodon)[:base_url]}/api/v1/streaming/?stream=user",
      Application.get_env(:federation_bot, :mastodon)[:access_token]
    )
  end

  def handle_connect(_conn, state), do: {:ok, state}

  def handle_frame(:text, "update", payload, state) do
    # TODO
    {:ok, state}
  end

  def handle_frame(:text, "notification", %{"type" => "follow", "account" => account} = _payload, state) do
    # Auto re-follow
    {:ok, _json, _headers} = FederationBot.Mastodon.follow(account)
    IO.puts "Follow an account: #{account["acct"]}"
    {:ok, state}
  end

  def handle_frame(_type, _event, _payload, state) do
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end
end
