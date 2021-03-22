import Config

config :logger, :console,
  format: "[$date $time] - $level - $message $metadata\n"

config :prometheus, MetricsPlugExporter,
  path: "/metrics",
  format: :text,
  registry: :default,
  auth: false

import_config "#{config_env()}.exs"
