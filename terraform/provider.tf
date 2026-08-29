# Provider configuration 
#
# Add AWS for S3 Backups of Proxmox Nodes. Investigate Backups v Proxmox Backup Server

terraform {
  required_version = ">= 1.7.0"

  required_providers {
    proxmox = {
      # bpg/proxmox is the actively maintained provider as of this writing;
      # telmate/proxmox is the older alternative used in a lot of older
      # tutorials. Confirm which one before filling this in.
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }

    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }


    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 6.0"
    # }
  }
}

provider "proxmox" {
  endpoint  = ephemeral.sops_file.proxmox.data["api_url"] # var.proxmox_api_url
  api_token = ephemeral.sops_file.proxmox.data["api_token"] # var.proxmox_api_token
  insecure  = true # install a real cert
  ssh {
    agent    = true
    username = ephemeral.sops_file.proxmox.data["user"] # var.proxmox_user
    password = ephemeral.sops_file.proxmox.data["password"] # var.proxmox_password
  }
}

provider "sops" {}

# Provider for the AWS backups of Proxmox Nodes
# provider "aws" {
#   region  = var.aws_region
#   profile = "awslab-remote-state"
# }
