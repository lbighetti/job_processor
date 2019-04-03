# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :job_processor,
  ecto_repos: []

# Configures the endpoint
config :job_processor, JobProcessorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lJAvTN5rU1fz+x4nqfPTu68D9+4XV1CXuFXA+GhqHD8V17jezK1F8grjyHN1nFgp",
  render_errors: [view: JobProcessorWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: JobProcessor.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :job_processor, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: JobProcessorWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: JobProcessorWeb.Endpoint
    ]
  }
