# Course Outline Generator — Static Edition

A **fully static, self-contained** version of the course outline generator. No Python,
no LaTeX, no server needed — everything runs in the browser:

- One HTML file containing the app, the PDF engine (pdfmake), fonts, UPEI logo and a
  default textbook cover.
- Works offline by double-clicking the file, or host it anywhere as a static file.
- Produces a PDF that mirrors the LaTeX layout of the server version
  (UPEI-Cairo header, section tables, LO matrix, grading scale, policies, etc.).

## Contents

| File | Purpose |
|---|---|
| `src/app.html` | Application source (UI + UI logic + PDF builder). Contains placeholders `__PDFMAKE_JS__`, `__VFS_JS__`, `__LOGO_B64__`, `__COVER_B64__`. |
| `lib/pdfmake.min.js` | pdfmake 0.2.10 client-side PDF engine. |
| `lib/vfs_fonts.js` | Roboto fonts (virtual file system) used by pdfmake. |
| `assets/logo.jpg` | UPEI-Cairo campus logo (header). |
| `assets/cover_small.jpg` | Lightweight default textbook cover (fallback when no cover uploaded). |
| `build.ps1` | Build script: inlines everything above into the final single-file HTML. |
| `course-outline-generator.html` | **The deliverable.** Fully self-contained; produce it via the build script. |
| `index.html` | Same app as above, served directly at the site root (no redirect). |

## How to build

Run from this folder:

```powershell
.\build.ps1
```

Either copy `course-outline-generator.html` to share, or use it directly from here.

> Note: the task is safe to re-run anytime (e.g. after editing `src/app.html` or
> replacing the logo / default cover in `assets\`). It overwrites
> `course-outline-generator.html`.

## Build requirements

- Windows PowerShell 5.1+ (ships with Windows). No other tools needed — the script
  base64-encodes the images and inlines the JS libraries with string replacement.

## Usage (end users)

1. Open `course-outline-generator.html` in any modern browser (or open the URL if hosted).
2. Fill the tabs, then click **Generate PDF** in the sidebar.
3. The download is `Course Outline - {code}.pdf`.
4. Data is auto-saved in the browser (localStorage) while you work.

## Notes / differences from the server version

- **Optional Policies** accept plain text. Lines starting with `\item`, `-` or `*` are
  rendered as bullets; raw LaTeX environments (`\begin{itemize}`…`\end{itemize}`) are
  stripped automatically for compatibility with older JSON files from the server app.
- Characters like `%`, `&`, `_`, `#` are plain text now — no escaping needed.
- Output PDF is close to the LaTeX output but not pixel-identical (PT Serif fonts,
  not Palatino).
- All processing is client-side; no data leaves the machine.