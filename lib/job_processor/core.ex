defmodule JobProcessor.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false

  alias JobProcessor.Core.Task
  alias JobProcessor.Core

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def parse_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.apply_action(:insert)
  end

  def parse_tasks(tasks) do
    tasks
    |> Enum.map(&Core.parse_task/1)
  end

  def process_job(params) do
    parsed_tasks = parse_tasks(params)

    # talvez fazer um função check for errors?
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

  def order_tasks(task_map) do
    # TODO: fazer acyclic test  e essas coisas depois pra ter certeza que é válido o graph
    # varias task não podem ter o mesmo nome, uniq ecto ? acho que não dá sem db. enum.map name enum.uniq

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
    |> Elixir.Graph.Reducers.Bfs.reduce(
      [],
      fn task_name, acc -> {:next, [Map.get(task_map, task_name) | acc]} end
    )
    |> Enum.reverse()
  end
end
