# Design Genius, agent guide

You are in a kit for building premium, on-brand landing pages with
AI-generated media. Plain HTML/CSS/JS, no framework, no build step.
Claude-specific instructions live in `CLAUDE.md`, read it too; its rules
(design tokens, gated spending, logging) apply to every agent.

## One-file setup

```
cp .env.example .env     # then paste the kie.ai key into .env
```

That single `.env` powers both ways of calling kie.ai:

1. **kie MCP (preferred)**, bundled at `mcp/kie-mcp/`, wired via `.mcp.json`.
   It starts automatically in clients that read project `.mcp.json`
   (Claude Code does). `mcp/kie-mcp/launch.mjs` reads `.env` itself, so no
   shell exports are needed. Tools appear as `kie_post`, `kie_get`,
   `kie_upload_file`, `kie_download`, `kie_fetch_model_docs`.
2. **`scripts/kie.sh` (fallback, no MCP needed)**, same API, plain curl:
   - `scripts/kie.sh submit '<json body>'` → prints taskId
   - `scripts/kie.sh wait <taskId>...` → polls until done
   - `scripts/kie.sh download <url> <dest>`
   It also reads `.env` on its own.

Costs are billed on submit. ALWAYS persist the taskId immediately and log
every generation (taskId, model, prompt summary, credits) to a `.gen.json`
next to the output. Check the balance with `GET /api/v1/chat/credit`.

## The workflow (short version)

1. Read `design/tokens.css`, `design/brand.md`, and the
   `design-intelligence` skill BEFORE building any page. If `design/` is
   empty, create the design system first, never build without tokens.
2. Copy follows `voice.md`. Pages go in `pages/`; test at desktop AND 390px.
3. Animated heroes: use the `scroll-hero` skill (gated, never spend
   credits on the next step before the current one is approved).
4. Propose → confirm → proceed. Show every paid generation to the human.

## Tools on this machine

| Tool | Needed for | Notes |
| --- | --- | --- |
| kie MCP / kie.sh | image + video generation | just needs `.env` |
| `scripts/setup-matte.sh` + `scripts/matte.py` | background removal (free, local) | run setup once (needs Python 3.10+), then `.venv-matte/bin/python3 scripts/matte.py <in> <out>`. Verify every matte over a magenta background before shipping. |
| `scripts/matte-kie.sh` | background removal (zero installs) | `scripts/matte-kie.sh <image-url> <dest>`, kie's recraft/remove-background, ~1 credit/image, input must be a URL under 5MB. Endpoint has transient 500s; failures cost 0. |
| ffmpeg | ONLY the video→scroll-frames slicing step | not needed for image work |
| Pillow (PIL) | resize/convert images | avoids extra installs |

## Folder map

- `pages/`, finished pages (currently empty, ready for a fresh run)
- `design/`, tokens + brand ("taste as data"); empty until frozen
- `assets/`, shared css/js for pages + generated media when working
- `scripts/`, kie.sh, matte.py, matte-kie.sh, setup-matte.sh
- `mcp/kie-mcp/`, bundled kie MCP server (don't edit `dist/`)
- `completed/<date>-<project>/`, (optional) finished runs, archived whole
  so the working folders can be reset for the next project.

## Archiving a finished run

Copy `pages/`, `design/`, `assets/`, canvas working files, and raw source
media into `completed/<date>-<name>/` keeping the same relative structure
(so `../assets/...` links keep working), verify the copy, THEN reset the
working folders. Never delete before verifying.
