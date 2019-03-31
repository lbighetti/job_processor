defmodule JobProcessor.Core.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :command, :string
    field :name, :string
    field :requires, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :command, :requires])
    |> validate_required([:name, :command])
  end
end
