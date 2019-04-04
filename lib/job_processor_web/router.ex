defmodule JobProcessorWeb.Router do
  use JobProcessorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JobProcessorWeb do
    pipe_through :api

    post "/process_job", TaskController, :process_job
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :job_processor,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0.0",
        title: "Job Processor"
      }
    }
  end
end
