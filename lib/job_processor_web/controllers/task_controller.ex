defmodule JobProcessorWeb.TaskController do
  use JobProcessorWeb, :controller
  use PhoenixSwagger

  alias JobProcessor.Core

  action_fallback JobProcessorWeb.FallbackController

  def swagger_definitions do
    %{
      Task:
        swagger_schema do
          title("Task")
          description("A task to be run by the OS")

          properties do
            command(:string, "The actual bash command to be run by the OS", required: true)
            name(:string, "A task given name as a unique identifier", required: true)
            requires(array(:string), "The tasks required before this task can execute")
          end

          example(%{
            name: "task-2",
            command: "cat /tmp/file1",
            requires: [
              "task-3"
            ]
          })
        end,
      ProcessedTask:
        swagger_schema do
          title("Processed Task")
          description("A task to be run by the OS")

          properties do
            command(:string, "The actual bash command to be run by the OS")
            name(:string, "A task given name as a unique identifier")
          end

          example(%{
            name: "task-2",
            command: "cat /tmp/file1"
          })
        end,
      TasksResponse:
        swagger_schema do
          title("Tasks Response")
          description("Response schema for displaying multiple for tasks")
          property(:tasks, Schema.array(:ProcessedTask), "A task to be run by the OS")
        end,
      TasksRequest:
        swagger_schema do
          title("Tasks Request")
          description("Response schema for requesting multiple for tasks")
          property(:tasks, Schema.array(:Task), "A task to be run by the OS")
        end
    }
  end

  swagger_path(:process_job) do
    post("/process_job")
    summary("This service orders the task list in a suitable order")
    description(
      "The service will parse the given tasks and order them so they're suitable order for execution"
    )
    consumes("application/json")
    produces("application/json")
    deprecated(false)

    parameter(:tasks, :body, Schema.ref(:TasksRequest), "The task details",
      example: %{
        tasks: [
          %{
            name: "task-1",
            command: "touch /tmp/file1"
          },
          %{
            name: "task-2",
            command: "cat /tmp/file1",
            required: ["task-3"]
          },
          %{
            name: "task-3",
            command: "echo 'Hello World!' > /tmp/file1",
            required: ["task-1"]
          },
          %{
            name: "task-4",
            command: "rm /tmp/file1",
            required: ["task-2", "task-3"]
          }
        ]
      }
    )

    response(200, "OK", Schema.ref(:TasksResponse),
      example: %{
        tasks: [
          %{
            name: "task-1",
            command: "touch /tmp/file1"
          },
          %{
            name: "task-3",
            command: "echo 'Hello World!' > /tmp/file1"
          },
          %{
            name: "task-2",
            command: "cat /tmp/file1"
          },
          %{
            name: "task-4",
            command: "rm /tmp/file1"
          }
        ]
      }
    )
  end

  def process_job(conn, %{"tasks" => params}) do

    with {:ok, tasks} <- Core.process_job(params) do
      case get_format(conn) do
        "json" ->
          conn
          |> put_status(:ok)
          |> render("tasks.json", tasks: tasks)
        "text" ->
          bash_script = format_bash_script(tasks)
          conn
          |> put_status(:ok)
          |> text(bash_script)
      end
    end
  end

  defp format_bash_script(tasks) do
    command_list =
      tasks
      |> Enum.map(fn task -> "#{task.command}\r\n" end)
    header = "#!/usr/bin/env bash\r\n\r\n"
    [header | command_list]
  end
end
