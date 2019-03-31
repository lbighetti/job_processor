defmodule JobProcessor.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false

  alias JobProcessor.Core.Job

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Ecto.Changeset.apply_action(:insert)
  end
end
