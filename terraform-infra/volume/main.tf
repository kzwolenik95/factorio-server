terraform {
  cloud {
    organization = "factorio-kzwolenik"
    hostname     = "app.terraform.io"

    workspaces {
      name = "factorio-volume"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {}

resource "digitalocean_volume" "factorio_saves" {
  name                     = "factorio-saves"
  size                     = 1
  # initial_filesystem_type  = "ext4"
  # initial_filesystem_label = "factorio-saves"
  region                   = "fra1"


  lifecycle {
    prevent_destroy = true
  }
}

output "volume_id" {
  value = digitalocean_volume.factorio_saves.id
}
