defmodule DingenWeb.DynamicOrigin.Router do
  @moduledoc """
  Kickstarts generation of the DingenWeb.Router.DynamicOriginHelpers module
  """
  alias Phoenix.Router.Route
  alias DingenWeb.DynamicOrigin.Router.Helpers

  @doc false
  defmacro __using__(_) do
    quote do
      @before_compile unquote(__MODULE__)
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    routes = env.module |> Module.get_attribute(:phoenix_routes) |> Enum.reverse
    routes_with_exprs = Enum.map(routes, &{&1, Route.exprs(&1)})

    Helpers.define(env, routes_with_exprs)

    []
  end
end
