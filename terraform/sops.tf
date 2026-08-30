# SOPS Vaults 
#
#

# Provider Related Vaults
ephemeral "sops_file" "proxmox" {
  source_file = "secrets/proxmox.yaml"
}

# Data Related Vaults
data "sops_file" "pihole" {
  source_file = "secrets/pihole.yaml"
}

data "sops_file" "tailscale_env" {
  source_file = var.tailscale_env_path
}