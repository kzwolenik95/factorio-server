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
resource "digitalocean_volume_attachment" "factorio_vol_attachment" {
  droplet_id = digitalocean_droplet.fedora.id
  volume_id  = digitalocean_volume.factorio_saves.id

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
