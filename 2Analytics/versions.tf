terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.33.0"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.6.3"
    }
    }
    backend "azurerm" {
       # resource_group_name   = "rg-terraform-state-dev"
       # storage_account_name  = "stb66hggfsdv"
       # container_name        = "tfstate"
       # key                   = "observability-dev" 
      
    
    
    }
  
    
  
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
  subscription_id = "xyz"
  
}

