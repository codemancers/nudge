defmodule Nudge.Repo do
  use Ecto.Repo,
    otp_app: :nudge,
    adapter: Ecto.Adapters.Postgres
end
