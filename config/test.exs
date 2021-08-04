use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :nudge, Nudge.Repo,
  username: System.get_env("POSTGRES_USER","postgres"),
  password: System.get_env("POSTGRES_PASSWORD","postgres"),
  database: System.get_env("POSTGRES_DB","nudge_test"),
  hostname: System.get_env("POSTGRES_HOST","localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nudge, NudgeWeb.Endpoint,
  http: [port: 4002],
  server: false

# during tests (and tests only), you may want to reduce the number of rounds so it does not slow down your test suite.
config :pbkdf2_elixir, :rounds, 1

# Print only warnings and errors during test
config :logger, level: :warn
