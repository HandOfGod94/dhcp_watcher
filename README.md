# DhcpWatcher

Watch DHCP file and publish lease assignments with prometheus metrics.
This can then be visualized as table on `grafana`.

## Commands

```sh
# run tests
mix test

# start server
mix run --no-halt

# create raspberry-pi-4 build
earthly +build
```

## Pre-requisite

- `inotify-tools` if you are running on linux
- earthly
- elixir v1.11

## Deploy to prometheus to pi (using ansible)

```sh
# deploy prometheus
ansible-playbook -i playbooks/hosts playbooks/prometheus.yml -k
```