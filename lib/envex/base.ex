defmodule Envex.Base do
  @moduledoc """
  This module handles fetching values from the config with some additional niceties
  """

  defmacro __using__(_) do
    default_app      = Mix.Project.config[:app]
    opts             = Application.get_env(default_app, :envex, [])
    default_endpoint = Keyword.get(opts, :endpoint)

    quote bind_quoted: [default_app: default_app, default_endpoint: default_endpoint] do
      @doc """
      Fetches key from the default namespace config, and prepare it with _get/3.
      """
      @spec endpoint(atom, term | nil) :: term
      def endpoint(key, default \\ nil), do:
        Envex.Base.endpoint(unquote(default_app), unquote(default_endpoint), key, default)

      @doc """
      Fetches key from the default namespace config, and prepare it with _prepare_map/3.
      """
      @spec endpoint_map(atom, term | nil) :: Keyword.t
      def endpoint_map(key, default \\ nil), do:
        Envex.Base.endpoint_map(unquote(default_app), unquote(default_endpoint), key, default)

      @doc """
      Fetches a value from the config, or from the environment if {:system, "VAR"}
      is provided.
      An optional default value can be provided if desired.
      """
      @spec get(atom, atom, term | nil) :: term
      def get(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get(app, key, default)

      @doc """
      Same as get/3, but when you has map.
      """
      @spec map(atom, atom, term | nil) :: Keyword.t
      def map(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get_map(app, key, default)

      @doc """
      Same as get/3, but returns the result as an integer.
      If the value cannot be converted to an integer, the
      default is returned instead.
      """
      @spec integer(atom(), atom(), integer()) :: integer
      def integer(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get_integer(app, key, default)

      @doc """
      Same as get_integer/3, but when you have integers in the map.
      """
      @spec integer_map(atom(), atom(), integer()) :: Keyword.t
      def integer_map(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get_integer_map(app, key, default)
    end
  end

  @doc false
  def endpoint(app, namespace, key, default \\ nil) do
    Application.get_env(app, namespace)[key]
    |> __get(default)
  end

  @doc false
  def endpoint_map(app, namespace, key, default \\ nil) do
    Application.get_env(app, namespace)[key]
    |> _prepare_map(default)
  end

  @doc false
  def get(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
    Application.get_env(app, key)
    |> __get(default)
  end

  @doc false
  def get_map(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
    Application.get_env(app, key)
    |> _prepare_map(default)
  end

  @doc false
  def get_integer(app, key, default \\ nil) do
    get(app, key, nil)
    |> __to_integer(default)
  end

  @doc false
  def get_integer_map(app, key, default \\ nil) do
    get_map(app, key, nil)
    |> _prepare_map(default, &__to_integer/2)
  end

  # HELPERS

  @doc false
  defp _prepare_map(map, default, converter \\ &__get/2)
  defp _prepare_map(map, default, converter) when is_map(map) do
    map |> Enum.map(fn({key, value}) -> {key, converter.(value, default)} end)
  end
  defp _prepare_map(_, _, _), do: nil

  @doc false
  defp __get(value, default) do
    case value do
      {:system, env_var} ->
        case System.get_env(env_var) do
          nil -> default
          val -> val
        end
      {:system, env_var, preconfigured_default} ->
        case System.get_env(env_var) do
          nil -> preconfigured_default
          val -> val
        end
      nil ->
        default
      val ->
        val
    end
  end

  @doc false
  defp __to_integer(value, default) do
    case value do
      nil -> default
      n when is_integer(n) -> n
      n ->
        case Integer.parse(n) do
          {i, _} -> i
          :error -> value
        end
    end
  end
end
