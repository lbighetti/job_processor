defmodule JobProcessor.CoreTest do
  use JobProcessor.DataCase

  alias JobProcessor.Core

  describe "tasks" do
    alias JobProcessor.Core.Task

    @valid_attrs %{command: "some command", name: "some name", requires: ["some task"]}
    @invalid_attrs %{command: nil, name: nil, requires: nil}
    @valid_tasks [
      %{
        "name" => "task-1",
        "command" => "touch /tmp/file1"
      },
      %{
        "name" => "task-2",
        "command" => "cat /tmp/file1",
        "requires" => [
          "task-3"
        ]
      },
      %{
        "name" => "task-3",
        "command" => "echo 'Hello World!' > /tmp/file1",
        "requires" => [
          "task-1"
        ]
      },
      %{
        "name" => "task-4",
        "command" => "rm /tmp/file1",
        "requires" => [
          "task-2",
          "task-3"
        ]
      }
    ]

    @invalid_tasks [
    %{
      "name" => nil,
      "command" => "touch /tmp/file1"
    },
    %{
      "name" => "task-2",
      "command" => "cat /tmp/file1",
      "requires" => [
        "task-3"
      ]
    },
    %{
      "name" => "task-3",
      "command" => nil,
      "requires" => [
        "task-1"
      ]
    },
    %{
      "name" => 213.23,
      "command" => "rm /tmp/file1",
      "requires" => [
        "task-2",
        "task-3"
      ]
    }
  ]

    test "parse_task/1 with valid data returns a task" do
      assert {:ok, %Task{} = task} = Core.parse_task(@valid_attrs)
      assert task.command == "some command"
      assert task.name == "some name"
      assert task.requires == ["some task"]
    end

    test "parse_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.parse_task(@invalid_attrs)
    end

    test "parse_tasks/1 with valid data returns a task" do
      assert parsed_tasks = Core.parse_tasks(@valid_tasks)
      refute parsed_tasks |> Enum.any?(fn {atom, _task} -> atom == :error end)
    end

    test "process_job/1 with valid data returns a task list" do
      {:ok, tasks} = Core.process_job(@valid_tasks)
      task_name_in_order = Enum.map(tasks, fn task -> task.name end)
      assert task_name_in_order == ["task-1", "task-3", "task-2", "task-4"]
    end

    test "process_job/1 with invalid data returns error changesets" do
      {:error, changesets} = Core.process_job(@invalid_tasks)
      assert length(changesets) == 3
    end
  end
end
