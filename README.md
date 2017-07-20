# Envex

Environment configuration parser. Purely functional, server free.
Full support for projects with `REPLACE_OS_VARS=true` in mind. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `envex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:envex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `envex` is started before your application:

    ```elixir
    def application do
      [applications: [:envex]]
    end
    ```

