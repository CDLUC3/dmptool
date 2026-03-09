# Pandoc DOCX Reference Document

The file `pandoc_reference.docx` is used as a style template when generating `.docx` exports. Pandoc uses the styles defined in this file while filling in content from the app. It does **not** use the content of the reference doc, only its styles.

## How it works

When `show_docx` runs in `plan_exports_controller.rb`, it passes this file to `pandoc` via `--reference-doc`. Pandoc maps HTML elements to Word styles like so:

| HTML element | Word style |
|---|---|
| `<p>` | Body Text / First Paragraph |
| `<h1>` – `<h6>` | Heading 1 – Heading 6 |
| `<blockquote>` | Block Text |
| `<code>` | Verbatim Char |
| `<a>` | Hyperlink |
| `<hr>` | Horizontal rule paragraph (avoid — use pBdr on heading instead) |

## Editing styles

The styles are stored in `word/styles.xml` inside the `.docx` file. Since `.docx` files are zip archives, you need to unzip, edit, and rezip.

### 1. Unzip

```bash
cd lib/templates
unzip pandoc_reference.docx -d pandoc_ref_tmp
```

### 2. Edit

Open `pandoc_ref_tmp/word/styles.xml` in any text editor and find the style you want to change.

Font sizes use half-points, so:

| Value | Point size |
|---|---|
| 20 | 10pt |
| 22 | 11pt |
| 24 | 12pt |
| 26 | 13pt |
| 28 | 14pt |
| 32 | 16pt |

Spacing values (e.g. `w:before`, `w:after`) use twentieths of a point (twips), so 240 = 12pt of space.

Common styles to edit:

- **`docDefaults`** — fallback font and size for anything not explicitly styled
- **`BodyText`** — regular paragraphs
- **`FirstParagraph`** — first paragraph after a heading
- **`Heading1` – `Heading9`** — headings (also update the matching `Heading1Char` etc.)

### 3. Rezip

Run the zip command from **inside** the tmp folder — this is important, otherwise the folder itself gets included and Pandoc won't read the file correctly.

```bash
cd pandoc_ref_tmp
zip -r ../pandoc_reference.docx .
cd ..
rm -rf pandoc_ref_tmp
```

### 4. Deploy

Commit `pandoc_reference.docx` and deploy. Changes take effect immediately on the next export.

## Editing styles using Word

You can open `pandoc_reference.docx` directly in Word and modify styles visually, though it requires a few extra steps to make sure changes actually persist to the style definitions (not just the sample text).

### 1. Open the file in Word

Open `pandoc_reference.docx` directly. You will see sample text for each style, e.g. "Body Text.", "First Paragraph.", "Heading 1", etc.

### 2. Open the Styles pane

- **Mac:** Go to **Format** menu → **Style...** → **Modify**
- **Windows:** On the **Home** tab, click the small arrow at the bottom-right corner of the Styles group

### 3. Modify a style

In the Styles pane, hover over the style you want to change (e.g. **Body Text**) until a dropdown arrow appears on the right side. Click it and choose **Modify Style...**. Change the font, size, spacing, etc. and click **OK**.

Do **not** right-click the sample text in the document body itself — that only affects the text, not the underlying style definition.

### 4. Save

Save the file normally. Word should write your style changes into the underlying XML.

### 5. Verify the change was saved

Because Word sometimes silently fails to persist style changes, it is worth verifying by unzipping and inspecting the XML after saving:

```bash
cd lib/templates
unzip -p pandoc_reference.docx word/styles.xml | grep -A 10 '"Body Text"'
```

Check that `<w:sz w:val="..."/>` reflects the size you set. If it does not, the change did not save and you will need to edit the XML directly instead (see **Editing styles** above).

## Tips

- Always back up the file before editing: `cp pandoc_reference.docx pandoc_reference_backup.docx`
- To verify a style was saved correctly, unzip and grep: `unzip -p pandoc_reference.docx word/styles.xml | grep -A 10 '"Body Text"'`
- Avoid using `<hr>` in the HTML template. Instead, add a bottom border to the Heading style using `<w:pBdr>` in `styles.xml` to avoid extra spacing.