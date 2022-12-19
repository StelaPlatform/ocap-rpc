defmodule OcapRpc.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = []
    opts = [strategy: :one_for_one, name: OcapRpc.Supervisor]

    OcapRpc.ChainConfigs.update_config()

    Supervisor.start_link(children, opts)
  end
end
