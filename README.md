# Design Genius Kit

Ask Claude for a landing page with no setup and you get the page everyone gets:
purple gradient, three feature cards, copy that reads like a press release.
Claude does not design badly. It designs blind. With no taste to draw on it
reaches for the average of the internet.

This folder gives it taste as files. A voice file, a design folder, and three
skills that Claude reads before it builds anything. Open the folder in Claude
Code (or any agent that reads a project folder), run the three levels, and every
page, post, or deck it makes from then on follows your rules.

Plain HTML/CSS/JS. No framework, no build step. Yours to keep and change.

## Setup (one file)

```
git clone https://github.com/mrdainami/design-genius.git
cd design-genius
cp .env.example .env     # paste your kie.ai API key (Level 3 only)
claude                   # or open the folder in your agent of choice
```

`.env` is the whole setup. It powers the bundled kie MCP (`.mcp.json` starts it
automatically in Claude Code; approve the project server when asked) and the
`scripts/kie.sh` fallback. Levels 1 and 2 cost nothing and need no key.

## The three levels

### Level 1: kill the text slop
`voice.md` is your brand voice as rules. The `humanizer` skill strips the
patterns that make copy read as machine written. Edit the voice file, then:

```
Use voice.md and the humanizer skill to improve the copy on pages/your-page.html
and save it as v2, so I can compare it to v1.
```

### Level 2: give it taste
Find a site you wish you had (Pinterest, refero.design, Behance). Then:

```
/design upgrade the design and animation following this reference style: <link or screenshot>
```

Iterate the mockup until it feels right, then freeze it:

```
Freeze this into my design system. Write design/tokens.css and design/brand.md,
and from now on build every page using only those tokens.
```

From now on every build reads `design/` first. The `design-intelligence` skill
holds the palettes, type pairings, and the anti-slop checklist Claude checks
against.

### Level 3: generate your own assets
With a kie.ai key in `.env`, Claude can call Seedance, GPT Image, Nano Banana
and about a hundred other models. The `scroll-hero` skill directs a product
shoot as a gated pipeline (storyboard → product master → storyboard sheet →
clip → frames) and waits for your yes before every paid step:

```
For v3, use kie to generate materials: <people doing the job> in the brand colors,
a <product or machine> for the hero with a faded background that matches the mockup,
and a scroll-stopping animation for the <services> section using the scroll-hero skill.
```

The easy path: drop the generated mp4 in as a full-bleed video hero. The full
effect: run `assets/build-frames.sh <clip.mp4> <name>` (needs ffmpeg, cwebp,
rembg) and wire a `.seq` section per the scroll-hero skill.

## Folder map

| Path | Job |
| --- | --- |
| `voice.md` | Your brand voice as rules. Every line of copy is written against it. |
| `design/` | Your design system. Starts empty; Level 2 fills `tokens.css` + `brand.md`. Drop references in `design/references/`. |
| `.claude/skills/humanizer/` | Removes AI writing patterns from copy. |
| `.claude/skills/design-intelligence/` | Palettes, type pairings, anti-patterns, QA checklist. |
| `.claude/skills/scroll-hero/` | The gated product-shoot pipeline for the animated hero. |
| `mcp/kie-mcp/` | Bundled kie MCP server (do not edit `dist/`). Wired by `.mcp.json`. |
| `scripts/` | `kie.sh` (REST fallback), `matte.py` + `setup-matte.sh` (free local background removal), `matte-kie.sh` (background removal via kie). |
| `assets/` | `scroll-sequence.js/.css` (the scroll-scrub engine), `base.css`, `build-frames.sh`, `frames/` output. |
| `pages/` | Built pages land here. Serve with `python3 -m http.server 8000`. |
| `CLAUDE.md` / `AGENTS.md` | The rules the agent follows in this folder. Tool neutral. |

## Rules the agent follows

- Read `design/tokens.css`, `design/brand.md`, and the `design-intelligence`
  skill before building any page. Tokens only, never a raw hex.
- Copy follows `voice.md`.
- Every paid generation is shown and approved before it runs. Costs are billed
  on submit, so every taskId is logged to a `.gen.json` next to the output.
- Test at desktop and 390px before calling a page done.

## Notes

- Skills and MCP servers are scanned when a session starts. Change them, then relaunch.
- Local tools needed only for the frame-slicing step: `brew install ffmpeg webp && pip install rembg`
  (or `bash scripts/setup-matte.sh` for a project-local rembg).
- The `/design` mockup step is a Claude feature. Everything else is plain markdown and runs in other agents too.

## Credits

- `humanizer` is MIT licensed, based on Wikipedia's "Signs of AI writing" guide.
- `mcp/kie-mcp` is MIT licensed (see `mcp/kie-mcp/LICENSE`).
- The scroll engine follows the same flipbook-on-scroll technique Apple uses on its product pages.
