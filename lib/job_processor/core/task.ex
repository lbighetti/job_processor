defmodule JobProcessor.Core.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :command, :string
    field :name, :string
    field :requires, {:array, :string}
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:name, :command, :requires])
    # TODO: name uniq identifier ? talvez has duplicates?
    |> validate_required([:name, :command])
  end
end
