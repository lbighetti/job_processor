defmodule JobProcessorWeb.TaskController do
  use JobProcessorWeb, :controller

  alias JobProcessor.Core

  action_fallback JobProcessorWeb.FallbackController

  def process_job(conn, %{"tasks" => params}) do
    with {:ok, tasks} <- Core.process_job(params) do
      conn
      |> put_status(:ok)
      |> render("tasks.json", tasks: tasks)
    end
  end
end
