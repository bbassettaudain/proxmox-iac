# Variables

variable "proxmox_node" {
  description = "Name of the target Proxmox node to provision on."
  type        = string
}

variable "template_vmid" {
  description = "VM ID of the cloud-init template to clone (see ../docs/proxmox-install.md)."
  type        = number
}

variable "aws_region" {
  description = "AWS region for backup/storage resources and the state bucket."
  type        = string
  default     = "us-east-1"
}

variable "tailscale_env_path" {
  description = "Path to the encrypted sops file for Tailscale environment variables"
  type        = string
  default     = "../../tailscale/enc.env"
}
