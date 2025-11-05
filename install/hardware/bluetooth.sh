#!/bin/bash
set -euo pipefail

sudo systemctl enable --now bluetooth.service
