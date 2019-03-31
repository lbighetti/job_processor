defmodule JobProcessorWeb.JobController do
  use JobProcessorWeb, :controller

  alias JobProcessor.Core
  alias JobProcessor.Core.Job

  action_fallback JobProcessorWeb.FallbackController

  def create(conn, %{"job" => job_params}) do
    with {:ok, %Job{} = job} <- Core.create_job(job_params) do
      conn
      |> put_status(:created)
      |> render("show.json", job: job)
    end
  end
end
