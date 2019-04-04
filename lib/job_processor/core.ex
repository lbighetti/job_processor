defmodule JobProcessor.Core do
  @moduledoc """
  The Core context, which is the entry point for the application.
  """

  import Ecto.Query, warn: false

  alias JobProcessor.Core.Task
  alias JobProcessor.Core

  @doc """
  Parses a map with tasks parameters into the `JobProcessor.Core.Task` struct.

  ## Examples

      iex> parse_task(%{name: "task-1", command: "touch /tmp/file1"})
      {:ok, %Task{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec parse_task(map()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def parse_task(attrs) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.apply_action(:insert)
  end

  @spec parse_tasks(map()) :: [{:ok, Task.t()} | {:error, Ecto.Changeset.t()}]
  def parse_tasks(tasks) do
    tasks
    |> Enum.map(&Core.parse_task/1)
  end

  @spec process_job(map()) :: {:error, [Ecto.Changeset.t()]} | {:ok, [Task.t()]}
  def process_job(params) do
    parsed_tasks = parse_tasks(params)


    parse_errors =
      parsed_tasks
      |> Enum.filter(fn {status, _task} -> status == :error end)

    case parse_errors do
      [] ->
        tasks =
          parsed_tasks
          |> Enum.reduce(%{}, fn {_status, task}, acc -> Map.put(acc, task.name, task) end)
          |> order_tasks

        {:ok, tasks}

      parse_errors ->
        errors =
          parse_errors
          |> Enum.map(fn {_status, task} -> task end)

        {:error, errors}
    end
  end

  @spec order_tasks(map()) :: [Task.t()]
  def order_tasks(task_map) do
    graph = build_graph(task_map)
    generate_ordered_task_list(graph, task_map)
  end

  defp generate_ordered_task_list(graph, task_map) do
    Elixir.Graph.Reducers.Bfs.reduce(graph,
      [],
      fn task_name, acc -> {:next, [Map.get(task_map, task_name) | acc]} end
    )
    |> Enum.reverse()
  end


  defp build_graph(task_map) do
    g = Graph.new()
    tasks = Map.values(task_map)

    tasks
    |> Enum.reduce(g, fn task, acc ->
      if task.requires == nil or task.requires == [] do
        Graph.add_vertex(acc, task.name)
      else
        Graph.add_edges(
          acc,
          Enum.map(task.requires, fn required_task -> {required_task, task.name} end)
        )
      end
    end)
  end
end
