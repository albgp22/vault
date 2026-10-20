#!/bin/bash
# Empaqueta el proyecto para otra sesión: fuentes, libs, herramientas, scripts de los agentes y PDFs.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
OUT="$ROOT/radio-typst-handoff.zip"
rm -f "$OUT"
zip -q -r "$OUT" HANDOFF.md main.typ cheatsheet.typ lib chapters tools source \
  build/examen-radioaficionado.pdf build/cheatsheet.pdf
# scripts y datos de los agentes (sin PNG ni PDF intermedios)
find build -mindepth 2 \( -name "*.py" -o -name "*.json" -o -name "*.txt" -path "build/falstad-custom/*" \) -print0 \
  | xargs -0 zip -q "$OUT"
unzip -l "$OUT" | tail -1
ls -lh "$OUT" | awk '{print $5, $9}'
