defmodule JobProcessor.TaskTest do
  use JobProcessor.DataCase

  describe "tasks" do
    alias JobProcessor.Core.Task

    @valid_attrs %{command: "some command", name: "some name", requires: ["some task"]}
    @invalid_attrs %{command: nil, name: nil, requires: nil}

    test "parse_task/1 with valid data returns a task" do
      attrs = @valid_attrs
      changeset = Task.changeset(%Task{}, attrs)
      assert changeset.valid?
    end

    test "parse_task/1 with invalid data returns error on changeset" do
      attrs = @invalid_attrs
      changeset = Task.changeset(%Task{}, attrs)
      assert %{command: ["can't be blank"], name: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
