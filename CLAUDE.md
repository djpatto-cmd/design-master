# Design Genius kit, build instructions

You build premium, on-brand pages in this folder. Plain HTML/CSS/JS, no framework, no build step.

## The one rule that stops slop
Before writing any page, read `design/tokens.css`, `design/brand.md`, and the
`design-intelligence` skill. Then:

1. Use ONLY the tokens in `design/tokens.css` for color, type, spacing, radius, shadow.
   Never inline a raw hex or a font that is not a token. If `design/` is still empty,
   say so and offer to create it (via /design or from a reference screenshot in
   `design/references/`) before building anything.
2. Obey `design-intelligence/anti-patterns.md`. No default purple-to-pink gradient,
   one accent color, generous spacing, no motion on everything.
3. Write copy in the voice in `voice.md`. Short, concrete, benefit-first.

## Animated product hero
Use the `scroll-hero` skill. It is GATED: never spend credits on the next step before
the current one is approved. Log every generation (taskId, model, prompt, credits) to
a `.gen.json` next to the output. Simple alternative: full-bleed mp4 hero, no slicing.

## Workflow
Propose, confirm, proceed. Show storyboards, copy, stills, and every paid generation
for an explicit yes before treating them as final. Pages go in `pages/`; test locally
at desktop AND 390px before calling anything done.
