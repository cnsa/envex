use Mix.Config

config :envex, :envex,
  endpoint: Some

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
  boolean: true,
  integer: "5",
  some: Some,
  map: %{some: :key},
  boolean_map: %{some: "true", other: ""},
  integer_map: %{some: "5", other: ""}
