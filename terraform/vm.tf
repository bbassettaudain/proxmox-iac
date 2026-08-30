# VM resource definitions
#
# Modularize these VMs and their cloudinit templates. 

resource "proxmox_virtual_environment_vm" "debian13" {
  name      = "streaming"
  node_name = var.proxmox_node

  clone {
    vm_id = var.template_vmid
    full  = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  # disk {

  # }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    # vlan_id = 100  # Homelab VLAN
  }

  #   initialization {
  #     ip_config {
  #       ipv4 {
  #         address = "10.10.100.14/24"
  #         gateway = "10.10.100.1"
  #       }
  #     }
  #   }
  tags = [
    "testing", "aiostreams", "streaming-exit-node", "youtubio"
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "proxmox_virtual_environment_vm" "pihole_primary" {
  name      = "pihole"
  node_name = var.proxmox_node

  clone {
    vm_id = var.template_vmid
    full  = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    # vlan_id = 100  # Homelab VLAN
  }

  lifecycle {
    prevent_destroy = true
  }

  initialization {
    datastore_id = "local-zfs"
    ip_config {
      ipv4 {
        address = "10.10.100.53/24"
        gateway = "10.10.100.1"
      }
    }
    # user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }
  tags = [
    "pihole", "dns", "infra"
  ]
}

resource "proxmox_virtual_environment_vm" "pihole_secondary" {
  name      = "pihole.secondary"
  node_name = var.proxmox_node

  clone {
    vm_id = var.template_vmid
    full  = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    # vlan_id = 100  # Homelab VLAN
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [initialization["user_data_file_id"]]
  }

  initialization {
    datastore_id = "local-zfs"
    ip_config {
      ipv4 {
        address = "10.10.100.54/24"
        gateway = "10.10.100.1"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config[1].id
  }
  tags = [
    "pihole", "dns", "infra"
  ]
}


resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  count        = length(local.pihole_hosts)
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    file_name = "pihole-user-data-${count.index}.yaml"
    data = templatefile("${path.module}/cloud-init/pihole-user-data.yaml.tftpl", {
      deploy_key           = nonsensitive(local.pihole_sops["pihole"]["deploy-key-private"])
      tailscale_deploy_key = nonsensitive(local.pihole_sops["tailscale"]["deploy-key-private"])
      env_file_content     = nonsensitive(local.env_file_content)
      host                 = local.pihole_hosts[count.index]
    })
  }
}

# resource "proxmox_virtual_environment_vm" "debian13-testing" {
#   name      = "pihole.testing"
#   node_name = var.proxmox_node

#   clone {
#     vm_id = var.template_vmid
#     full  = true
#   }

#   cpu {
#     cores = 2
#   }

#   memory {
#     dedicated = 4096
#   }

#   network_device {
#     bridge = "vmbr0"
#     model  = "virtio"
#     # vlan_id = 100  # Homelab VLAN
#   }

#   lifecycle {
#     prevent_destroy = true
#   }

#   initialization {
#     datastore_id = "local-zfs"
#     ip_config {
#       ipv4 {
#         # address = "10.10.100.53/24"
#         gateway = "10.10.100.1"
#       }
#     }
#     # user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
#   }
#   tags = [
#       # "testing", "pihole", "dns"
#   ]
# }

# resource "proxmox_virtual_environment_file" "user_data_cloud_config_stremio" {
#   content_type = "snippets"
#   datastore_id = "local"
#   node_name    = var.proxmox_node

#   source_raw {
#     file_name = "stremio-user-data.yaml"
#     data = templatefile("${path.module}/cloud-init/user-data.yaml.tftpl", {
#       deploy_key = local.github_deploy_key
#       tailscale_deploy_key = local.tailscale_deploy_key
#       env_file_content = local.env_file_content
#     })
#   }
# }