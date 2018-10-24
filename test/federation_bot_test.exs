defmodule FederationBotTest do
  use ExUnit.Case
  doctest FederationBot

  test "greets the world" do
    assert FederationBot.hello() == :world
  end
end
