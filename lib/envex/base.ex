defmodule Envex.Base do
  @moduledoc """
  This module handles fetching values from the config with some additional niceties
  """

  defmacro __using__(_) do
    default_app       = Mix.Project.config[:app]
    default_namespace = Application.get_env(:envex, :endpoint, nil)

    quote bind_quoted: [default_app: default_app, default_namespace: default_namespace] do
      @doc """
      Fetches key from the default namespace config, and prepare it with get/3.
      """
      @spec endpoint(atom, term | nil) :: term
      def endpoint(key, default \\ nil), do:
        Envex.Base.get(unquote(default_app), {unquote(default_namespace), key}, default)

      @doc """
      Fetches key from the default namespace config, and prepare it with _prepare_map/3.
      """
      @spec endpoint_map(atom, term | nil) :: Keyword.t
      def endpoint_map(key, default \\ nil), do:
        Envex.Base.get_map(unquote(default_app), {unquote(default_namespace), key}, default)

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
      @spec integer(atom() | term, atom(), integer()) :: integer
      def integer(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get(app, key, default, :integer)

      @doc """
      Same as integer/3, but when you have integer values in the map.
      """
      @spec integer_map(atom() | term, atom(), integer()) :: Keyword.t
      def integer_map(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get_map(app, key, default, :integer)

      @doc """
      Same as get/3, but returns the result as an boolean.
      If the value cannot be converted to an boolean, the
      default is returned instead.
      """
      @spec boolean(atom() | term, atom(), boolean()) :: boolean
      def boolean(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get(app, key, default, :boolean)

      @doc """
      Same as boolean/3, but when you have boolean values in the map.
      """
      @spec boolean_map(atom() | term, atom(), boolean()) :: Keyword.t
      def boolean_map(key, app \\ unquote(default_app), default \\ nil), do:
        Envex.Base.get_map(app, key, default, :boolean)
    end
  end

  @doc false
  def get(app, {namespace, key}, default) do
    Application.get_env(app, namespace)[key]
    |> _get(default)
  end

  def get(app, key, default) when is_atom(app) and is_atom(key) do
    Application.get_env(app, key)
    |> _get(default)
  end

  @doc false
  def get(app, {_, _} = key, default, type) do
    value = get(app, key, nil)
    _coerce(type, value, default)
  end

  @doc false
  def get(app, key, default, type) do
    value = get(app, key, nil)
    _coerce(type, value, default)
  end

  @doc false
  def get_map(app, {namespace, key}, default) do
    Application.get_env(app, namespace)[key]
    |> _prepare_map(default)
  end

  @doc false
  def get_map(app, key, default) when is_atom(app) and is_atom(key) do
    Application.get_env(app, key)
    |> _prepare_map(default)
  end

  @doc false
  def get_map(app, {_, _} = key, default, type) do
    get_map(app, key, nil)
    |> _prepare_map(default, &_coerce(type, &1, &2))
  end

  @doc false
  def get_map(app, key, default, type) do
    get_map(app, key, nil)
    |> _prepare_map(default, &_coerce(type, &1, &2))
  end

  # HELPERS

  @doc false
  defp _prepare_map(map, default, converter \\ &_get/2)
  defp _prepare_map(map, default, converter) when is_list(map) or is_map(map) do
    map |> Enum.map(fn({key, value}) -> {key, converter.(value, default)} end)
  end
  defp _prepare_map(map, _, _), do: map

  @doc false
  defp _get(value, default) do
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
  defp _coerce(type, value, default) do
    case value do
      n when is_bitstring(n) ->
        case Coercion.coerce(n, type) do
          {:ok, result} -> result
          _ -> value
        end
      n -> default || n
    end
  end
end
