defmodule JobProcessor.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      JobProcessorWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: JobProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    JobProcessorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
