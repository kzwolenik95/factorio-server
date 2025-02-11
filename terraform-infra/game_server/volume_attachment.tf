data "terraform_remote_state" "factorio_volume" {
  backend = "remote"

  config = {
    organization = "factorio-kzwolenik"
    workspaces = {
      name = "factorio-volume"
    }
  }
}

resource "digitalocean_volume_attachment" "factorio_vol_attachment" {
  droplet_id = digitalocean_droplet.fedora.id
  volume_id  = data.terraform_remote_state.factorio_volume.outputs.volume_id

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = digitalocean_droplet.fedora.ipv4_address
      user        = "root"
      private_key = var.pvt_key
    }
    inline = [
      "idlink=$(lsblk --noheadings --filter 'SERIAL == \"factorio-saves\"' -o ID-LINK)",
      "mount_entry=\"/dev/disk/by-id/$idlink /mnt/factorio_saves ext4 defaults 0 1\" >> /etc/fstab",
      "grep -qxF \"$mount_entry\" /etc/fstab || echo \"$mount_entry\" >> /etc/fstab",
      "mkdir -p /mnt/factorio_saves",
      "systemctl daemon-reload",
      "mount -a"
    ]
  }
}