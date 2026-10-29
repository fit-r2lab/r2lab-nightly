#!/bin/bash
#
# Apply the current checkout: sync the uv environment in .venv
#
# Called by r2lab-embedded/services/run-updates.sh after it has moved this
# repo to the latest origin commit; can also be run by hand.
# The git update itself is NOT done here.
#
# This does not touch the systemd units at all; they are symlinked by hand
# into /etc/systemd/system, see the README. Also, the services are oneshot
# and run from timers, so they just pick up the new code next time.
#
# rhubarbe comes from /opt/rhubarbe (see pyproject.toml), which run-updates
# must have updated before this repo, see services/hosts/<host>.repos
#

set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")/.."

export PATH="/root/.local/bin:$PATH"

uv sync
