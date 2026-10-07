#!/usr/bin/env bash
# Para o pod. Volumes (banco e arquivos do WordPress) continuam intactos.
set -euo pipefail
source "$(dirname "$0")/env.sh"
podman pod stop "$POD"
