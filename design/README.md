# design/, the taste folder

Empty on purpose. Level 2 fills it:

1. Drop screenshots you like into `references/` (Pinterest, refero.design, Behance, real sites).
2. Iterate a mockup in /design until it feels premium.
3. Say "freeze this into my design system" → Claude writes:
   - `tokens.css`, the exact colors, fonts, spacing, radii as CSS variables
   - `brand.md`, the vibe and voice in words

From then on every page build reads this folder first and uses only these tokens.
That is the whole trick: taste as data, not taste as vibes.

Once frozen, `tokens.css` holds every color, font, spacing, and radius as a CSS variable, and `brand.md` holds the mood in words.
