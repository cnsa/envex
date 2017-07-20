defmodule Envex.Mixfile do
  use Mix.Project

  @project_url "https://github.com/cnsa/envex"
  @version "0.1.1"


  def project do
    [app: :envex,
     version: @version,
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: [publish: ["hex.publish", "hex.publish docs", "tag"], tag: [&git_tag/1]],
     source_url: @project_url,
     homepage_url: @project_url,
     description: "Environment configuration parser. Purely functional, server free.",
     package: package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: cli_env_for(:test, [
       "coveralls", "coveralls.detail", "coveralls.html", "coveralls.post",
     ]),
     docs: docs()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/support"]
  defp elixirc_paths(_),     do: elixirc_paths()
  defp elixirc_paths,        do: ["lib"]

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn(key, acc) -> Keyword.put(acc, :"#{key}", env) end)
  end

  defp deps do
    [
      {:ex_doc, "~> 0.11", only: :dev, runtime: false},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_spec, "~> 2.0.0", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
    ]
  end

  defp package do
    [
      name: :envex,
      maintainers: ["Alexander Merkulov"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @project_url
      }
    ]
  end

  defp git_tag(_args) do
    System.cmd "git", ["tag", "v" <> Mix.Project.config[:version]]
  end

  defp docs do
    [
       main: "Envex",
       source_ref: "v#{@version}",
       source_url: @project_url
    ]
  end
end
