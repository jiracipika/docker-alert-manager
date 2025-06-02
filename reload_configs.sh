#!/bin/bash

echo "Reloading Prometheus configuration..."
docker exec prometheus ash -c "kill -HUP 1"

if [ $? -eq 0 ]; then
  echo "Prometheus configuration reloaded successfully."
else
  echo "Failed to reload Prometheus configuration."
fi

echo "Reloading Alertmanager configuration..."
docker exec alertmanager ash -c "kill -HUP 1"

if [ $? -eq 0 ]; then
  echo "Alertmanager configuration reloaded successfully."
else
  echo "Failed to reload Alertmanager configuration."
fi

echo "Grafana dashboards are provisioned automatically on container start or file changes in the mounted volume."
echo "No explicit reload command is typically needed for Grafana provisioning."
echo "Loki and Promtail do not have a direct reload endpoint via SIGHUP; changes require container restart."
