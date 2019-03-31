defmodule JobProcessor.CoreTest do
  use JobProcessor.DataCase

  alias JobProcessor.Core

  describe "jobs" do
    alias JobProcessor.Core.Job

    @valid_attrs %{command: "some command", name: "some name", requires: ["some job"]}
    @invalid_attrs %{command: nil, name: nil, requires: nil}

    def job_fixture(attrs \\ %{}) do
      {:ok, job} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_job()

      job
    end

    test "create_job/1 with valid data creates a job" do
      assert {:ok, %Job{} = job} = Core.create_job(@valid_attrs)
      assert job.command == "some command"
      assert job.name == "some name"
      assert job.requires == ["some job"]
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_job(@invalid_attrs)
    end
  end
end
