# defmodule JobProcessorWeb.TaskControllerTest do
#   use JobProcessorWeb.ConnCase

#   alias JobProcessor.Core
#   alias JobProcessor.Core.Job

#   @create_attrs %{
#     command: "some command",
#     name: "some name",
#     requires: []
#   }
#   @update_attrs %{
#     command: "some updated command",
#     name: "some updated name",
#     requires: []
#   }
#   @invalid_attrs %{command: nil, name: nil, requires: nil}

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "create job" do
#     test "renders job when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.job_path(conn, :create), job: @create_attrs)
#       assert %{"id" => id} = json_response(conn, 201)["data"]

#       conn = get(conn, Routes.job_path(conn, :show, id))

#       assert %{
#                "id" => id,
#                "command" => "some command",
#                "name" => "some name",
#                "requires" => []
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.job_path(conn, :create), job: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end


#   defp create_job(_) do
#     job = fixture(:job)
#     {:ok, job: job}
#   end
# end
