# Envex

[![Hex.pm](https://img.shields.io/hexpm/v/envex.svg?maxAge=2592000)](https://hex.pm/packages/envex)
[![Deps Status](https://beta.hexfaktor.org/badge/prod/github/cnsa/envex.svg)](https://beta.hexfaktor.org/github/cnsa/envex)

Environment configuration parser. Purely functional, server free.
Full support for projects with `REPLACE_OS_VARS=true` in mind. 

See the [docs](https://hexdocs.pm/envex/) for more information.

# TODO:

- [ ] Write API description for README.  
  Currently only via docs.
- [ ] Add Travis CI
- [x] Optimize coercion.  
- [x] Add specs.  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `envex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:envex, "~> 0.1.1"}]
    end
    ``` 
  2. Feel free to use it inside your app, like:
  
    ```elixir
    Envex.map(:ecto_repos)
    ```
