use Mix.Config

config :envex, :envex,
  endpoint: Some

config :envex, :other,
  some: Some,
  map: %{some: :key}

config :envex, Some,
  some: :key,
  map: %{some: :key}
