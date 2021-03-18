import Config

config :prometheus, MetricsPlugExporter,
  path: "/metrics",
  format: :text,
  registry: :default,
  auth: false

import_config "#{config_env()}.exs"
