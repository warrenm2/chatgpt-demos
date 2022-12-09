 # Configure the Azure provider
provider "azurerm" {
 # Removed - will be using cloud shell to deploy
}

# Create a resource group
# Updated location and name
resource "azurerm_resource_group" "chatgpt-aks" {
  name     = "chatgpt-aks-rg"
  location = "ukwest"
}

# Create a virtual network
resource "azurerm_virtual_network" "chatgpt-aks" {
  name                = "chatgpt-aks-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.chatgpt-aks.location
  resource_group_name = azurerm_resource_group.chatgpt-aks.name
}

# Updated name and subnet details
# Create a subnet for the AKS cluster
resource "azurerm_subnet" "chatgpt-aks-subnet" {
  name                 = "chatgpt-aks-subnet"
  resource_group_name  = azurerm_resource_group.chatgpt-aks.name
  virtual_network_name = azurerm_virtual_network.chatgpt-aks.name
  address_prefix       = "10.10.1.0/24"
}

# Updated name
# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "chatgpt-aks" {
  name                = "chatgpt-aks-cluster"
  location            = azurerm_resource_group.chatgpt-aks.location
  resource_group_name = azurerm_resource_group.chatgpt-aks.name
  dns_prefix          = "chatgpt-aks-cluster"

  # Updated IPs
  # Configure the AKS cluster
  kubernetes_version = "1.16.9"
  dns_service_ip     = "10.10.0.10"
  service_cidr       = "10.10.0.0/24"

  # Enable Kubernetes dashboard
  enable_dashboard = true

  # Updated IP
  # Use the subnet created earlier for the AKS cluster
  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.10.0.10"
    docker_bridge_cidr = "172.17.0.1/16"

    service_cidr       = "10.10.0.0/24"
    pod_cidr           = "10.244.0.0/16"

    load_balancer_sku  = "standard"

    outbound_type      = "loadBalancer"

    subnet_id          = azurerm_subnet.chatgpt-aks.id
  }
}
