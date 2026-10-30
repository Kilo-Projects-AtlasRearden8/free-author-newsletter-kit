# STATUS — Free Author Newsletter Kit

## What was built

A fillable, printable freebies kit for author newsletters, created by
**Asdale Dynamics, LLC**. No account, no signup, no email required. Nothing
phones home.

Files:

| File | Purpose |
| --- | --- |
| `LICENSE` | MIT License, copyright `Copyright (c) 2026 Asdale Dynamics, LLC` |
| `README.md` | Kit overview, usage, credits Asdale Dynamics, LLC |
| `index.html` | Browser landing page linking all templates |
| `templates/welcome-email.md` / `.html` | Welcome email for new subscribers |
| `templates/release-announcement.md` / `.html` | New book / guide / tool launch email |
| `templates/signup-ideas.md` / `.html` | Reader-magnet and list-growth planner |
| `templates/sending-calendar.md` / `.html` | Quarterly newsletter sending plan |
| `scripts/verify.sh` | Verification script (files, HTML, lint, secrets) |
| `.markdownlint.json` | Markdown lint config (printable blanks exempted) |
| `STATUS.md` | This file |

Each template exists in both Markdown (copy/paste into any email tool) and
fillable HTML (open in a browser, type into fields, print to paper or PDF).
Print styles hide screen-only controls so pages come out clean on paper.

## How to run it

There is no build step and no server. Open the HTML files directly in a
web browser:

- Landing page: `index.html`
- Templates: `templates/*.html`

To use Markdown templates, open `templates/*.md` in a text editor, replace the
`[bracketed placeholders]`, and paste into MailerLite, ConvertKit, Substack,
or your email tool of choice.

To print, use your browser's print dialog (File > Print) and choose "Save as
PDF" or a physical printer. Print styles strip screen chrome.

Verification:

```
chmod +x scripts/verify.sh
bash scripts/verify.sh
```

No install required beyond `bash`, `grep`, `python3`, and (optionally)
`markdownlint` for the lint step.

## Verification results

`scripts/verify.sh` passes all checks:

- Required files present (LICENSE, README.md, index.html, STATUS.md, all 8
  templates).
- No `.github/workflows` directory.
- `LICENSE` contains the exact copyright line:
  `Copyright (c) 2026 Asdale Dynamics, LLC`.
- README credits Asdale Dynamics, LLC.
- All HTML files are well-formed and credit Asdale Dynamics, LLC.
- No secrets, API keys, or personal data detected in content files.
- `markdownlint` clean (`.markdownlint.json` relaxes MD013 line length and
  disables MD050 because underscores are used as printable fill-in blanks,
  not strong emphasis).

## Known gaps

- No automated test suite beyond `scripts/verify.sh`; verification is
  file/HTML/lint/secrets based.
- HTML is not validated against a formal schema (well-formedness checked by
  Python's HTML parser only).
- No CSS build/bundling; styles are inline in each HTML file (intentional,
  keeps each template self-contained and printable).
- Templates use generic placeholders (no real names, emails, or links), so no
  end-to-end send test is possible without substituting real values.
- Not yet integrated with any email service provider; the user copies content
  into their own tool.

## Credits

Created by **Asdale Dynamics, LLC** — beginner-friendly AI education, books,
and practical tools. Hub site: dylanasdale.github.io

MIT License. Copyright (c) 2026 Asdale Dynamics, LLC.
