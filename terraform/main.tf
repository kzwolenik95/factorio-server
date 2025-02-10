data "digitalocean_images" "available" {
  filter {
    key    = "distribution"
    values = ["Fedora"]
  }
  filter {
    key    = "regions"
    values = ["fra1"]
  }
  filter {
    key      = "name"
    values   = ["41"]
    match_by = "substring"
  }
  filter {
    key    = "type"
    values = ["base"]
  }
  sort {
    key       = "created"
    direction = "desc"
  }
}

resource "digitalocean_droplet" "fedora" {

  image  = data.digitalocean_images.available.images[0].slug
  name   = var.name
  region = var.region
  size   = var.size
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  tags = ["factorio"]
}

resource "digitalocean_firewall" "allow_all_outbound" {
  name = "Allow-All-Outbound"

  droplet_ids = [digitalocean_droplet.fedora.id]

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "allow_all_factorio" {
  name = "Allow-All-Factorio"

  droplet_ids = [digitalocean_droplet.fedora.id]

  inbound_rule {
    protocol         = "udp"
    port_range       = "34197"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "allow_ssh_admins" {
  name = "Allow-ssh-Admins"

  droplet_ids = [digitalocean_droplet.fedora.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = split(",", var.admin_ips)
  }
}

data "cloudflare_zones" "domain-zone" {
  name = var.apex_domain
}

resource "cloudflare_dns_record" "example_dns_record" {
  zone_id = data.cloudflare_zones.domain-zone.result.0.id
  comment = "Factorio server IP"
  content = resource.digitalocean_droplet.fedora.ipv4_address
  name    = var.subdomain
  proxied = false
  ttl     = 1
  type    = "A"
}

resource "cloudflare_dns_record" "_factorio_udp" {
  zone_id = data.cloudflare_zones.domain-zone.result.0.id
  comment = "Factorio server SRV UDP "
  name    = "_factorio._udp.${var.subdomain}"
  ttl     = 1
  type    = "SRV"

  data = {
    priority = 0
    weight   = 0
    port     = 34197
    target   = "${var.subdomain}.${var.apex_domain}"
  }
}
