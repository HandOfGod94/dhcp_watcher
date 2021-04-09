# DhcpWatcher

Reads DHCP file and exposes at `/lease` endpoint
This can then be visualized as table on `grafana`.

## Commands

```sh
# run tests
mix test

# start server
mix run --no-halt

# create raspberry-pi-4 build
earthly +build

# create background service
mix create_systemd_service
```

## Pre-requisite

- earthly
- elixir v1.11

## Deploy to prometheus to pi (using ansible)

```sh
# deploy app
ansible-playbook -i playbooks/hosts playbooks/deploy.yml -k

# deploy prometheus
ansible-playbook -i playbooks/hosts playbooks/prometheus.yml -k
```
