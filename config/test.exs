use Mix.Config

config :envex, :other,
  boolean: true,
  integer: "5",
  some: Some,
  map: %{some: :key},
  boolean_map: %{some: "true", other: ""},
  integer_map: %{some: "5", other: ""}

config :envex, Some,
  some: :key,
  map: %{some: :key},
  boolean_map: %{some: "true", other: ""},
  integer_map: %{some: "5", other: ""}

config :envex,
  endpoint: Some,
  boolean: true,
  integer: "5",
  some: Some,
  env: {:system, "SOME_ENV"},
  env_default: {:system, "SOME_OTHER", 5},
  boolean_env: {:system, "SOME_BOOL"},
  integer_env: {:system, "SOME_INTEGER"},
  map: %{some: :key},
  boolean_map: %{some: "true", other: ""},
  integer_map: %{some: "5", other: ""}
