# Remote state backend

terraform {
  backend "s3" {
    bucket       = "awslab-tf-states"
    key          = "proxmox-iac/terraform.tfstate"
    region       = var.aws_region
    encrypt      = true
    use_lockfile = true
    profile      = "awslab-remote-state"
  }
}
