# Factorio Server on DigitalOcean

Automated deployment of a Factorio game server using GitHub Actions, Terraform, and Ansible.

## Overview

This project provides infrastructure as code to deploy and manage a Factorio game server on DigitalOcean. The server can be created and destroyed on-demand while preserving game saves on a persistent volume.

### Features

- On-demand server provisioning via GitHub Actions
- Persistent game saves using DigitalOcean Volumes
- DNS configuration with Cloudflare
- Automated server configuration using Ansible
- Performance benchmarking tools included
- Firewall rules for secure access

## Prerequisites

- DigitalOcean account
- Cloudflare account with registered domain
- GitHub repository secrets configured:
  - `DIGITALOCEAN_API_TOKEN`
  - `CLOUDFLARE_API_TOKEN`
  - `SSH_PRIV_KEY`
  - `HCP_TERRAFORM_TOKEN`

## Usage

### Deploying the Server

1. Go to GitHub Actions
2. Select "Provision the server" workflow
3. Click "Run workflow"

The server will be automatically:
- Provisioned on DigitalOcean
- Configured with Factorio
- Connected to persistent storage
- Made accessible via configured domain

### Destroying the Server

1. Go to GitHub Actions
2. Select "Destroy the server" workflow
3. Type "DESTROY" in the confirmation field
4. Click "Run workflow"

This will destroy the server while preserving the game saves on the persistent volume.

## Architecture

- **Infrastructure**: Managed by Terraform
  - DigitalOcean Droplet
  - Volume for game saves
  - Firewall rules
  - DNS configuration

- **Configuration**: Handled by Ansible
  - Base system setup
  - Factorio server installation
  - Service configuration
  - Mod management

## Repository Structure
```sh
.
├── .github/workflows/   # GitHub Actions workflows
├── ansible/             # Ansible playbooks and roles
├─┬ terraform-infra/     # Terraform configuration
│ ├── game_server/       # Server infrastructure
│ └── volume/            # Persistent storage
└── benchmark results/   # Server performance data
```


## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the [MIT License](LICENSE).