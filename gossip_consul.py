"""
Explanation
Register a Service: 

The register_service function registers a service with Consul using the /v1/agent/service/register endpoint.
Check Service Health: The check_service_health function retrieves the health status of the registered service using the /v1/health/service/{service_name} endpoint.
Deregister a Service: The deregister_service function simulates a service failure by deregistering it from Consul.
Main Loop: The script registers the service, checks its health every 5 seconds, and allows you to stop it with a keyboard interrupt (Ctrl+C). When interrupted, it simulates a service failure by deregistering the service.

Performance Considerations
Speed of Detection: 
 The speed of detection in Consul using the Gossip Protocol is generally fast, allowing nodes to detect changes in membership or failures within seconds. The exact timing depends on the configuration (e.g., health check intervals) and network conditions.
Health Checks: Consul's health checks can be configured with different intervals and timeouts, influencing how quickly failures are detected and communicated to other nodes.
"""

import requests
import time

CONSUL_URL = "http://localhost:8500"  # Consul API URL

# Register a service
def register_service(service_name):
    service_definition = {
        "ID": service_name,
        "Name": service_name,
        "Address": "127.0.0.1",
        "Port": 5000,
        "Tags": ["example"]
    }
    response = requests.put(f"{CONSUL_URL}/v1/agent/service/register", json=service_definition)
    return response.status_code == 200

# Check service health
def check_service_health(service_name):
    response = requests.get(f"{CONSUL_URL}/v1/health/service/{service_name}")
    return response.json()

# Deregister a service (simulate failure)
def deregister_service(service_name):
    response = requests.put(f"{CONSUL_URL}/v1/agent/service/deregister/{service_name}")
    return response.status_code == 200

# Main function
if __name__ == "__main__":
    service_name = "example-service"

    # Register the service
    if register_service(service_name):
        print(f"Service '{service_name}' registered successfully.")

    # Periodically check health
    try:
        while True:
            health_status = check_service_health(service_name)
            print(f"Health Status: {health_status}")
            time.sleep(5)  # Check every 5 seconds
    except KeyboardInterrupt:
        print("Deregistering service...")

        # Simulate service failure
        if deregister_service(service_name):
            print(f"Service '{service_name}' deregistered successfully.")