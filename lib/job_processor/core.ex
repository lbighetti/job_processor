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

  def process_job (tasks) do
    # tasks = parse_tasks(tasks)
    # case tasks do
    #   {:ok, tasks} ->

    # end
  end
end
