# Locals 

locals {
  # Needs validation for content. Data will not be show in plan for verification.
  env_file_content = data.sops_file.tailscale_env.raw
  pihole_hosts     = ["pi", "pi2"]
  pihole_sops      = yamldecode(data.sops_file.pihole.raw)

}
