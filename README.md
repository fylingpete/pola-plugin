# Pola

Pola ist ein Plugin für Claude. Es legt dein Second Brain an: einen Ordner mit
Markdown-Dateien auf deinem Computer, den Claude für dich pflegt und nutzt.
Mehr auf [pola.so](https://pola.so).

## Installieren

**Claude Cowork:** [`pola.zip`](https://github.com/fylingpete/pola-plugin/releases/latest/download/pola.zip)
herunterladen und in Claude Cowork unter **Customize → Plugins** hochladen.
Danach unter dem Eingabefeld bei **„Project or folder“** einen Ordner für dein
Brain wählen.

**Claude Code:**

```bash
claude plugin marketplace add fylingpete/pola-plugin
claude plugin install pola@pola
```

Danach Claude Code starten und Pola mit `/pola:pola-onboard` einrichten.

## Was hier liegt

Dieses Repository enthält genau das, was du installierst: die Skills, den
Hook, die gebündelte Kommandozeile `tools/pola.cjs` und die Vorlage für ein
neues Brain. Entwickelt wird Pola in einem eigenen Repository; hier erscheint
jede fertige Version, als Commit und als `pola.zip` unter Releases.

## Lizenz

Apache 2.0, siehe [LICENSE](LICENSE). Copyright 2026 Topformer GmbH. Hinweise
zu mitgelieferter Software stehen in [NOTICE](NOTICE).
