defmodule JobProcessor.Core.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :command, :string
    field :name, :string
    field :requires, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :command, :requires])
    |> validate_required([:name, :command, :requires])
  end
end
