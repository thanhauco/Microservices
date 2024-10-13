# Nginx Configuration
# This resource creates a local file with a basic Nginx configuration
# It sets up a load balancer (upstream) and a simple server block
resource "local_file" "nginx_config" {
  filename = "nginx.conf"
  content  = <<-EOT
    http {
      # Define an upstream group for load balancing
      upstream backend {
        server backend1.example.com;
        server backend2.example.com;
      }
      # Configure the server block
      server {
        listen 80;
        location / {
          # Proxy requests to the backend upstream group
          proxy_pass http://backend;
        }
      }
    }
  EOT
}

# Docker Compose Configuration
# This resource generates a Docker Compose file with three services:
# a web server (Nginx), an application, and a database
resource "local_file" "docker_compose" {
  filename = "docker-compose.yml"
  content  = <<-EOT
    version: '3'
    services:
      web:
        image: nginx:latest
        ports:
          - "80:80"
      app:
        image: your-app-image:latest
        environment:
          - DB_HOST=db
      db:
        image: postgres:latest
  EOT
}

# Kubernetes Configuration
# This resource creates a Kubernetes deployment with three replicas
# of an Nginx container
resource "kubernetes_deployment" "example" {
  metadata {
    name = "example-deployment"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "example"
      }
    }
    template {
      metadata {
        labels = {
          app = "example"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "example"
        }
      }
    }
  }
}

# Prometheus Configuration
# This resource creates a local file with a basic Prometheus configuration
# It sets up global scrape intervals and a single scrape job
resource "local_file" "prometheus_config" {
  filename = "prometheus.yml"
  content  = <<-EOT
    global:
      scrape_interval: 15s
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']
  EOT
}

# Grafana Configuration
# This resource creates a simple Grafana dashboard with one panel
# using Prometheus as the data source
resource "grafana_dashboard" "example" {
  config_json = <<EOT
{
  "title": "Example Dashboard",
  "panels": [
    {
      "title": "Panel Title",
      "type": "graph",
      "datasource": "Prometheus"
    }
  ]
}
EOT
}

# Jaeger Configuration
# This resource creates a Kubernetes deployment for Jaeger
# using the all-in-one image for simplicity
resource "kubernetes_deployment" "jaeger" {
  metadata {
    name = "jaeger"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jaeger"
      }
    }
    template {
      metadata {
        labels = {
          app = "jaeger"
        }
      }
      spec {
        container {
          image = "jaegertracing/all-in-one:latest"
          name  = "jaeger"
        }
      }
    }
  }
}

# Kiali Configuration
# This resource creates a Kubernetes deployment for Kiali
# which is a management console for Istio-based service mesh
resource "kubernetes_deployment" "kiali" {
  metadata {
    name = "kiali"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "kiali"
      }
    }
    template {
      metadata {
        labels = {
          app = "kiali"
        }
      }
      spec {
        container {
          image = "quay.io/kiali/kiali:latest"
          name  = "kiali"
        }
      }
    }
  }
}

# Fluentd Configuration
# This resource creates a local file with a basic Fluentd configuration
# It sets up log collection from an Apache access log and forwards to Elasticsearch
resource "local_file" "fluentd_config" {
  filename = "fluentd.conf"
  content  = <<-EOT
    <source>
      @type tail
      path /var/log/httpd-access.log
      pos_file /var/log/td-agent/httpd-access.log.pos
      tag apache.access
      <parse>
        @type apache2
      </parse>
    </source>
    <match apache.access>
      @type elasticsearch
      host elasticsearch.example.com
      port 9200
      logstash_format true
    </match>
  EOT
}

# Vector Configuration
# This resource creates a local file with a basic Vector configuration
# It sets up log collection from Apache logs, parses them, and sends to Elasticsearch
resource "local_file" "vector_config" {
  filename = "vector.toml"
  content  = <<-EOT
    [sources.apache_logs]
    type = "file"
    include = ["/var/log/apache2/*.log"]
    ignore_older = 86400

    [transforms.apache_parser]
    type = "regex_parser"
    inputs = ["apache_logs"]
    patterns = ['^(?P<host>[^ ]*) [^ ]* (?P<user>[^ ]*) \[(?P<timestamp>[^\]]*)\] "(?P<method>\S+)(?: +(?P<path>[^\"]*?)(?: +\S*)?)?" (?P<status>[^ ]*) (?P<size>[^ ]*)(?: "(?P<referer>[^\"]*)" "(?P<agent>[^\"]*)")?$']

    [sinks.elasticsearch_out]
    type = "elasticsearch"
    inputs = ["apache_parser"]
    host = "http://elasticsearch:9200"
    index = "vector-%Y-%m-%d"
  EOT
}

# Tempo Configuration
# This resource creates a Kubernetes deployment for Tempo
# which is a high-volume, minimal-dependency trace storage
resource "kubernetes_deployment" "tempo" {
  metadata {
    name = "tempo"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "tempo"
      }
    }
    template {
      metadata {
        labels = {
          app = "tempo"
        }
      }
      spec {
        container {
          image = "grafana/tempo:latest"
          name  = "tempo"
        }
      }
    }
  }
}

# Loki Configuration
# This resource creates a Kubernetes deployment for Loki
# which is a horizontally-scalable, highly-available log aggregation system
resource "kubernetes_deployment" "loki" {
  metadata {
    name = "loki"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "loki"
      }
    }
    template {
      metadata {
        labels = {
          app = "loki"
        }
      }
      spec {
        container {
          image = "grafana/loki:latest"
          name  = "loki"
        }
      }
    }
  }
}
