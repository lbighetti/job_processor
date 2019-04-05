defmodule JobProcessor.Core.Task do
  @moduledoc """
  The `Ecto.Schema` for Task

  This symbolizes one single task to be executed.
  It draws from the idea that a job is composed of many tasks, so this is the smallest unit of measure.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :command, :string
    field :requires, {:array, :string}
  end

  @type name :: String.t()

  @typedoc """
  The Task struct.

  It contains keys as folows:

  * `:name`: The name to identify the task uniquely.
  * `:command`: Command for the OS to run. Should be bash compatible.
  * `:requires`: Which tasks are required to run before this one can run. This is optional.
  """
  @type t :: %__MODULE__{
          name: name,
          command: String.t(),
          requires: [String.t()]
        }

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :command, :requires])
    |> validate_required([:name, :command])
  end
end
