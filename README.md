# Home Assistant VibraVid Add-on

Packages [VibraVid](https://github.com/AstraeLabs/VibraVid) (web UI for searching and downloading
from streaming sites, with Sonarr/Radarr/Seerr integration) as a Home Assistant Supervisor add-on.

## Why a wrapper

Upstream publishes a multi-arch image (`ghcr.io/astraelabs/vibravid`), so this add-on doesn't
rebuild anything. `run.sh` only moves the app's state out of the container layer before handing off
to the image's own entrypoint:

| In the image | In the add-on | Holds |
|---|---|---|
| `/app/Conf` | `/config` (the add-on's `addon_config` folder, `/addon_configs/local_vibravid` from HA) | `config.json`, `login.json` (TMDB API key, provider logins), `domains.json` |
| `/app/data` | `/data/django` | Django SQLite DB (Arr request/queue history) and its secret key |

Both are included in Home Assistant backups of the add-on. On first start `/config` is seeded from
the image's defaults.

## Configuration

| Option | Description |
|---|---|
| `timezone` | Container timezone, e.g. `Europe/Rome` |

Everything else is VibraVid's own config, in `config.json`/`login.json` under the add-on config
folder (or via the web UI). `/share` is the host's Home Assistant `share` folder, i.e. the same
path the Sonarr/Radarr add-ons see, so set `OUTPUT.root_path` to match their root folders (e.g.
`/share/share`).

The web UI and the webhook endpoint for Sonarr/Radarr/Seerr are on host port `8088` by default.

The in-app "Update now" button needs the Docker socket and doesn't work here. To update, bump
the image tag in `Dockerfile` and `version` in `config.json`.

## Installing

Add this repository in Settings → Add-ons → Add-on Store → ⋮ → Repositories, or clone it into
`/addons/` for a local add-on.
