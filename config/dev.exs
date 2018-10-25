use Mix.Config

config :federation_bot, :mastodon,
  base_url: System.get_env("MASTODON_URL"),
  access_token: System.get_env("ACCESS_TOKEN")
