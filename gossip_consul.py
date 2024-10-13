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