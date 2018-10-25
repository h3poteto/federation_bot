defmodule FederationBot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(FederationBot.Bot, [[]]),
    ]

    opts = [strategy: :one_for_one, name: FederationBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
