# First Person Solana

A customized [Sour](https://github.com/cfoust/sour) (Cube 2: Sauerbraten in the
browser) build — rebranded **First Person Solana**, "Built by Kelby Dishman".

This repo deploys the game as a Docker web service. The prebuilt server binary
and ~294 MB of game assets are stored as a **GitHub Release** (`v1`) rather than
in git, so the `Dockerfile` downloads them at build time.

## Deploy on Render

1. Push this repo to GitHub (already done if you're reading it there).
2. In the [Render dashboard](https://dashboard.render.com): **New +** → **Web Service**.
3. Connect this GitHub repo. Render auto-detects the `Dockerfile`.
4. Settings:
   - **Runtime:** Docker
   - **Instance type:** Starter ($7/mo, always on) recommended. Free works but
     spins down after 15 min of inactivity (slow cold start).
   - No environment variables required — Render injects `PORT` automatically.
5. Click **Create Web Service**. First build takes a few minutes (it downloads
   the release artifacts). When it's live, share the `*.onrender.com` URL —
   anyone can play in their browser.

Alternatively, use the included `render.yaml` Blueprint: **New +** → **Blueprint**
→ select this repo.

## Updating the game

When you rebuild the game (new logo, menus, maps, etc.):

1. Re-tar `assets/dist` and replace the binary in a **new** release (e.g. `v2`).
2. Bump `ARG RELEASE=v2` in the `Dockerfile`.
3. Commit & push — Render auto-deploys.

## Notes

- Web clients connect over HTTP + WebSocket; the client config uses
  origin-relative paths, so it works on any domain with no extra config.
- This is a web-only deployment (no desktop/UDP ingress).
