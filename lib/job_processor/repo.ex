defmodule JobProcessor.Repo do
  use Ecto.Repo,
    otp_app: :job_processor,
    adapter: Ecto.Adapters.Postgres
end
