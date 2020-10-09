# Declare variables

variable "subnetName" {
    type = string
    default = "default" # Note this refers to the subnet named "default" and is a default variable
    description = "name of the subnet targeted"
}

variable "virtualNetworkName" {
    type = string
    description = "name of existing vnet"
}

variable "resourceGroupName" {
    type = string
    description = ""
}

variable "admin_username" {
    type = string
    description = "admin username for the vm"
}

variable "admin_password" {
    type = string
    description = "password for the admin username for the vm"
}

variable "VMName" {
    type = string
    description = "Name of the VM"
}

variable "NetworInterfeceController" {
    type = string
    default = "nic"
    description = "network interface name"
}

