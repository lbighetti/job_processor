defmodule JobProcessorWeb.TaskControllerTest do
  use JobProcessorWeb.ConnCase

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
  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create job" do
    test "renders job when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :process_job), tasks: @valid_tasks)
      response = json_response(conn, 200)

      assert [
               %{"command" => "touch /tmp/file1", "name" => "task-1"},
               %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
               %{"command" => "cat /tmp/file1", "name" => "task-2"},
               %{"command" => "rm /tmp/file1", "name" => "task-4"}
             ] == response
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :process_job), tasks: @invalid_tasks)

      assert [
               %{"errors" => %{"name" => ["can't be blank"]}},
               %{"errors" => %{"command" => ["can't be blank"]}},
               %{"errors" => %{"name" => ["is invalid"]}}
             ] == json_response(conn, 422)
    end
  end
end
