defmodule JobProcessorWeb.Router do
  use JobProcessorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JobProcessorWeb do
    pipe_through :api

    post "/process_job", TaskController, :process_job
  end
end
