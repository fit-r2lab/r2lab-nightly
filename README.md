# r2lab-nightly

Nightly health check of the R2Lab testbed (faraday), plus a safety net for
the V0 testbed (distrait).

## What it does

- `nightly.py` runs hourly at nn:19 from `r2lab-nightly.timer`, and returns at
  once unless the `r2lab-nightly` slice currently holds a lease. When it does,
  for each node it turns it on, pings it, turns it off, checks it is down,
  then loads reference image 1 and checks the node, same with image 2.
  It reports on the sidecar, sends a mail, and ends with
  `rhubarbe bye --nodes --phones --pdus`, which is forked on purpose, for
  process isolation and a hard timeout.
- `nightmail.py` builds and sends the report mail; it is imported by
  `nightly.py`, so the two have to stay together.
- `book-nightly.py` books leases for the `r2lab-nightly` slice over a
  range of dates.
- `turn-off-the-lights` is for distrait **only**: there is no lease system
  there, so this daily timer switches off all the nodes regardless. It plays
  the role of nightly on distrait, and is not suitable in production.

## Python environment

This is a uv project, with its own `.venv`. `rhubarbe` is an editable
dependency on `/opt/rhubarbe` (see `pyproject.toml`), so nightly always runs
the very same rhubarbe code as the rhubarbe services, as maintained by
`r2lab-embedded/services/run-updates.sh`. Do not use a git or pypi
dependency for it: that would pin a separate copy that could diverge.

The units put `.venv/bin` first in their `PATH`, so that the forked
`rhubarbe bye` is the one from this environment.

## Deployment

The repo is cloned in `/root/r2lab-nightly`, and listed in
`r2lab-embedded/services/hosts/<host>.repos`, **after** `/opt/rhubarbe`.
`run-updates.sh` keeps it up to date, and runs `deploy/update.sh` when it
changes, which does a `uv sync`.

`update.sh` does not touch systemd. The units from `deploy/` are linked by
hand, once:

```bash
# on faraday
cd /etc/systemd/system
ln -s /root/r2lab-nightly/deploy/r2lab-nightly.{service,timer} .
systemctl daemon-reload
systemctl enable --now r2lab-nightly.timer

# on distrait
cd /etc/systemd/system
ln -s /root/r2lab-nightly/deploy/turn-off-the-lights.{service,timer} .
systemctl daemon-reload
systemctl enable --now turn-off-the-lights.timer
```

After a unit file is edited, a manual `systemctl daemon-reload` is needed.

## Development

`make r2lab` rsyncs the scripts to `faraday:/tmp/r2lab-dev-embedded/`; see
the `Makefile` for how to run them from there. See also `TODO.md`.
