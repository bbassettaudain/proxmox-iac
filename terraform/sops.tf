# SOPS Vaults 

ephemeral "sops_file" "proxmox" {
    source_file = "secrets/proxmox.yaml"
}

data "sops_file" "pihole" {
    source_file = "secrets/pihole.yaml"
}

data "sops_file" "tailscale_env" {
    source_file = var.tailscale_env_path
}