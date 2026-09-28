// Starts the bundled kie MCP. If KIE_API_KEY isn't already in the environment,
// it is read from the project .env so setup stays one file.
import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const projectRoot = join(dirname(fileURLToPath(import.meta.url)), '..', '..');
if (!process.env.KIE_API_KEY) {
  try {
    const env = readFileSync(join(projectRoot, '.env'), 'utf8');
    const m = env.match(/^KIE_API_KEY=(.+)$/m);
    if (m) process.env.KIE_API_KEY = m[1].trim().replace(/^["']|["']$/g, '');
  } catch {
    // no .env — the server will report auth errors until one exists
  }
}
await import('./dist/index.js');
