defmodule JobProcessorWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: JobProcessorWeb

      import Plug.Conn
      import JobProcessorWeb.Gettext
      alias JobProcessorWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/job_processor_web/templates",
        namespace: JobProcessorWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import JobProcessorWeb.ErrorHelpers
      import JobProcessorWeb.Gettext
      alias JobProcessorWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import JobProcessorWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
