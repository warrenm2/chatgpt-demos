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
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.chatgpt-aks.location
  resource_group_name = azurerm_resource_group.chatgpt-aks.name
}

# Updated name and subnet details
# Create a subnet for the AKS cluster
resource "azurerm_subnet" "chatgpt-aks-subnet" {
  name                 = "chatgpt-aks-subnet"
  resource_group_name  = azurerm_resource_group.chatgpt-aks.name
  virtual_network_name = azurerm_virtual_network.chatgpt-aks.name
 # chatgpt put 'prefix' instead of 'prefixes'
  address_prefixes       = "10.10.0.0/24"
}

# Updated name
# Create an AKS cluster
# At least one 'default_node_pool' block is required - check documentation
resource "azurerm_kubernetes_cluster" "chatgpt-aks" {
  name                = "chatgpt-aks-cluster"
  location            = azurerm_resource_group.chatgpt-aks.location
  resource_group_name = azurerm_resource_group.chatgpt-aks.name
  dns_prefix          = "chatgpt-aks-cluster"

  # Updated IPs
  # Configure the AKS cluster
  kubernetes_version = "1.16.9"
  # An argument named 'dns_service_ip' is not expected here 
  dns_service_ip     = "10.10.0.10"
  # An argument named 'service_cidr' is not expected here
  service_cidr       = "10.10.0.0/24"
  
  default_node_pool {
    name       = "chatgpt-aks-node-pool"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }
  # This argument was not expected
  # Enable Kubernetes dashboard
  #enable_dashboard = true

  # Use the subnet created earlier for the AKS cluster
  network_profile {
    # suspect this does NOT have to use the subnet created earlier and can be standalone
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "172.17.0.1"
    docker_bridge_cidr = "172.17.0.1/16"

    service_cidr       = "10.10.0.0/24"
    pod_cidr           = "10.244.0.0/16"

    load_balancer_sku  = "standard"

    outbound_type      = "loadBalancer"
    # An argument named "subnet_id" is not expected here
    # subnet_id          = azurerm_subnet.chatgpt-aks.id
  }
}
