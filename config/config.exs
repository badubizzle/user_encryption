# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :user_encryption,
  ecto_repos: [UserEncryption.Repo]

# Configures the endpoint
config :user_encryption, UserEncryptionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NxGtVqAKnUkzz5PmpB52q33sDv3HZSEifnJg96eBEj13TP0oNKu/vxKgoNiGgyeV",
  render_errors: [view: UserEncryptionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UserEncryption.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
