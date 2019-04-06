defmodule JobProcessorWeb.FallbackController do
  @moduledoc false
  use JobProcessorWeb, :controller

  def call(conn, {:error, changesets}) when is_list(changesets) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(JobProcessorWeb.ChangesetView)
    |> render("errors.json", changesets: changesets)
  end
end
