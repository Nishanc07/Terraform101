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
        # key                   = "devops-dev" 
      
    
    
    }
  
    
    
  
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
  subscription_id = "a584d13d-2dd5-4bbf-85ff-b0c51f60baca"
  
}
