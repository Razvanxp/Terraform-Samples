# Assigned variables

virtualNetworkName = "skunk-network"
subnetName = "default"
resourceGroupName = "test-resources"
# VM Params
admin_username = "adminuser"
admin_password = "P@$$w0rd1234!" # in future secure this, use Azure Pipelines to store it or even better, variable groups with Keyvaults.
VMName = "test-machine" 
NetworInterfeceController = "test-machine-nic"