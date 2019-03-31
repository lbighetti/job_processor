defmodule JobProcessorWeb.JobView do
  use JobProcessorWeb, :view
  alias JobProcessorWeb.JobView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{id: job.id,
      name: job.name,
      command: job.command,
      requires: job.requires}
  end
end
