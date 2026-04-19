# Multistack Server

This repository orchestrates multiple self-hosted service stacks (blog, VPN, LibreTranslate, Minecraft server, Navidrome, etc.) using Docker Compose and Caddy for unified reverse proxy and TLS management. Each stack is modular and can be managed independently or together.

---

## Contents
- [Overview](#overview)
- [Stacks Included](#stacks-included)
- [Directory Structure](#directory-structure)
- [Submodules](#submodules)
- [Global Environment Variables](#global-environment-variables)
- [Running Multiple Stacks](#running-multiple-stacks)
- [Notes](#notes)

---

## Overview
- **Caddy**: Provides HTTPS, reverse proxy, and optional Cloudflare DNS-based TLS for all services.
- **Docker Compose**: Orchestrates containers and networks for each stack.
- **Modular Stacks**: Each service (blog, VPN, etc.) is isolated in its own directory with its own configuration and scripts.

---

## Stacks Included
- **blog/**: Multilingual blog platform (frontend, backend, Caddy)
- **vpn/**: WireGuard VPN with web UI (wg-easy) and Caddy
- **libretranslate/**: LibreTranslate API and web UI with Caddy
- **minecraft-server/**: Minecraft server management (Crafty Controller) with Caddy
- **navidrome/**: Music streaming server with Caddy

---

## Directory Structure
- `blog/`, `vpn/`, `libretranslate/`, `minecraft-server/`, `navidrome/`: Each stack's code, configs, and scripts
- `global-caddy/`: Shared Caddy build and config (if used)
- `.env`, `.env.example`: Global environment variables (if any)
- `.gitmodules`: Git submodule definitions for included stacks
- `docker-compose.yml`: (Optional) Top-level Compose file for orchestration
- `run-multiservers.sh`: Example script to run multiple stacks

---

## Submodules
Some stacks may be included as git submodules. To initialize and update them:
```sh
git submodule update --init --recursive
```

---

## Global Environment Variables
- Each stack has its own `.env` or `.env.example` file for configuration.
- Set global variables in the root `.env` if needed, or manage per-stack.

---

## Running Multiple Stacks
Each stack is managed independently. To run a stack:
```sh
cd <stack-directory>
cp .env.example .env  # if needed
./run.sh up -d
```

To run multiple stacks at once, you can use the provided `run-multiservers.sh` script or run each stack's `run.sh` in parallel.

---

## Notes
- Each stack has its own README with detailed setup and usage instructions.
- Caddy reverse proxy and TLS are managed per stack, but can be unified if desired.
- For production, ensure secrets are set securely and not committed to version control.
- For submodules, always keep them updated with `git submodule update --remote` as needed.

---

## License
See each stack's directory for license details.
