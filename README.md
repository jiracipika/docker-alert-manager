# Comprehensive Monitoring Stack with Prometheus, Grafana, Alertmanager, Blackbox, Pushgateway, Loki & Promtail

This repository provides a robust, all-in-one monitoring and logging solution using Docker Compose. It's designed to give you deep insights into your system's health, external service availability, ephemeral job metrics, and centralized logs, all visualized through Grafana.

## ✨ Features

*   **System Metrics (CPU, Memory, Disk)**: Monitored via **Node Exporter**, providing detailed insights into your host machine's resource utilization.
*   **External Endpoint Monitoring**: Utilizes **Blackbox Exporter** to probe and monitor the availability and response times of external services (e.g., websites, APIs).
*   **Ephemeral Job Metrics**: **Pushgateway** allows short-lived or batch jobs to expose their metrics to Prometheus, ensuring no data is lost.
*   **Log Aggregation**: **Loki** and **Promtail** work together to collect, aggregate, and store logs from your Docker containers, making them searchable and viewable in Grafana.
*   **Prometheus Alerting**: Configured with **Alertmanager** to send notifications for critical events (e.g., high CPU/memory, service downtime).
*   **Grafana Dashboards for Visualization**: Pre-configured dashboards for Node Exporter and Blackbox Exporter metrics, providing immediate visual insights.
*   **Automated Configuration Reloading**: A simple Bash script to reload Prometheus and Alertmanager configurations without restarting containers.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed on your system:

*   **Docker**: [Install Docker](https://docs.docker.com/get-docker/)
*   **Docker Compose**: Usually comes bundled with Docker Desktop. If not, [install Docker Compose](https://docs.docker.com/compose/install/)

### Setup

1.  **Clone the repository**:
    \`\`\`bash
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    \`\`\`

2.  **Create the necessary directory structure and files**:
    Ensure your project directory matches this structure. The `docker-compose.yml` and other configuration files will be placed in these locations.

    \`\`\`
    .
    ├── docker-compose.yml
    ├── grafana
    │   ├── dashboards
    │   │   ├── node-exporter-overview.json
    │   │   └── blackbox-overview.json
    │   └── provisioning
    │       ├── dashboards
    │       │   └── dashboard.yml
    │       └── datasources
    │           └── datasource.yml
    ├── prometheus
    │   ├── alert.rules.yml
    │   └── prometheus.yml
    ├── alertmanager
    │   └── alertmanager.yml
    ├── loki
    │   └── loki-config.yml
    ├── promtail
    │   └── promtail-config.yml
    └── reload_configs.sh
    \`\`\`

3.  **Configure Alertmanager (Optional but Recommended)**:
    Edit `alertmanager/alertmanager.yml` to set up your desired notification receiver (e.g., Slack, email, custom webhook).
    **Important**: Replace `'http://your-webhook-url.com/alert'` with your actual webhook URL.

    \`\`\`yaml
    # alertmanager/alertmanager.yml
    receivers:
      - name: 'webhook_receiver'
        webhook_configs:
          - url: 'http://your-webhook-url.com/alert' # <--- REPLACE THIS
            send_resolved: true
    \`\`\`

4.  **Make the reload script executable**:
    \`\`\`bash
    chmod +x reload_configs.sh
    \`\`\`

5.  **Start the services**:
    \`\`\`bash
    docker compose up -d
    \`\`\`
    This command will download the necessary Docker images and start all services in detached mode.

## 🌐 Accessing the Services

Once all services are up and running, you can access them via your web browser:

*   **Grafana**: \`http://localhost:3000\`
*   **Prometheus**: \`http://localhost:9090\`
*   **Alertmanager**: \`http://localhost:9093\`
*   **Blackbox Exporter**: \`http://localhost:9115\`
*   **Pushgateway**: \`http://localhost:9091\`
*   **Node Exporter**: \`http://localhost:9100\`

### Default Credentials

*   **Grafana**:
    *   Username: \`admin\`
    *   Password: \`admin\`
    (You will be prompted to change the password on your first login.)

## ⚙️ Configuration Details

### `docker-compose.yml`

Defines all the services, their images, port mappings, volumes, and dependencies.

### `prometheus/prometheus.yml`

The main configuration for Prometheus, including scrape targets (Node Exporter, Blackbox Exporter, Pushgateway), and integration with Alertmanager.

### `prometheus/alert.rules.yml`

Contains the Prometheus alerting rules for high CPU usage, high memory usage, and service downtime (from Blackbox Exporter).

### `alertmanager/alertmanager.yml`

Configures Alertmanager's routing and notification receivers. Customize the `webhook_receiver` or add other receivers like email.

### `grafana/provisioning/datasources/datasource.yml`

Automatically provisions Prometheus and Loki as data sources in Grafana.

### `grafana/provisioning/dashboards/dashboard.yml`

Automatically provisions the Node Exporter Overview and Blackbox Exporter Overview dashboards in Grafana.

### `grafana/dashboards/node-exporter-overview.json`

A pre-configured Grafana dashboard for visualizing CPU, memory, and disk usage from Node Exporter.

### `grafana/dashboards/blackbox-overview.json`

A pre-configured Grafana dashboard for visualizing service uptime and probe durations from Blackbox Exporter.

### `loki/loki-config.yml`

Basic configuration for Loki, setting up its storage and server ports.

### `promtail/promtail-config.yml`

Configures Promtail to scrape logs from all Docker containers (excluding the monitoring stack's own logs) and send them to Loki.

## 📊 How to Use Pushgateway

To push metrics to Pushgateway, you can use `curl` or any client library that supports the Prometheus text exposition format.

Example:
\`\`\`bash
echo "my_batch_job_duration_seconds 1.23" | curl --data-binary @- http://localhost:9091/metrics/job/my_batch_job
\`\`\`
This will create a metric `my_batch_job_duration_seconds` with a value of `1.23` under the job `my_batch_job`. Prometheus will then scrape this metric from Pushgateway.

## 📝 How to View Logs in Grafana

1.  Navigate to Grafana (\`http://localhost:3000\`).
2.  In the left-hand menu, click on **Explore** (the compass icon).
3.  Select **Loki** from the data source dropdown.
4.  You can now use LogQL queries to explore your container logs. For example, to see all logs: \`{job="docker"}\`. To filter by a specific container name: \`{container_name="your-container-name"}\`.

## 🔄 Automating Configuration Reloads

After making changes to `prometheus/prometheus.yml` or `alertmanager/alertmanager.yml`, you can reload their configurations without restarting the entire Docker Compose stack:

\`\`\`bash
./reload_configs.sh
\`\`\`

**Note**: Grafana dashboards are automatically provisioned on container start or when changes are detected in the mounted provisioning volumes. Loki and Promtail typically require a container restart for their configuration changes to take effect.

## ⚠️ Troubleshooting

*   **Containers not starting**: Check `docker compose logs` for error messages.
*   **Prometheus not scraping**: Verify `prometheus.yml` syntax and ensure target services (Node Exporter, Blackbox, Pushgateway) are running and accessible on their respective ports.
*   **Grafana dashboards not appearing**: Ensure the `.json` files are correctly placed in `grafana/dashboards` and `grafana/provisioning/dashboards/dashboard.yml` is correctly configured. Check Grafana logs for provisioning errors.
*   **Alerts not firing/sending**: Check Prometheus targets for Alertmanager, and Alertmanager logs for issues with receivers. Ensure your webhook URL is correct and accessible from the Alertmanager container.
*   **Loki/Promtail issues**: Check `loki` and `promtail` container logs. Ensure `/var/lib/docker/containers` and `/var/run/docker.sock` are correctly mounted for Promtail.

## 🤝 Contributing

Feel free to fork this repository, open issues, or submit pull requests to improve this monitoring stack.

## 📄 License

This project is open-sourced under the MIT License.
\`\`\`
