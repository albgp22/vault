#!/bin/bash
# Compila el libro y la hoja de repaso con las fuentes incluidas en fonts/.
# Uso: tools/build.sh            → build/examen-radioaficionado.pdf, build/cheatsheet.pdf y build/simulacros.pdf
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
mkdir -p build
typst compile --root . --font-path fonts main.typ build/examen-radioaficionado.pdf
typst compile --root . --font-path fonts cheatsheet.typ build/cheatsheet.pdf
typst compile --root . --font-path fonts simulacros.typ build/simulacros.pdf
typst compile --root . --font-path fonts simulacros-control.typ build/simulacros-control.pdf
for f in build/examen-radioaficionado.pdf build/cheatsheet.pdf build/simulacros.pdf build/simulacros-control.pdf; do
  echo "OK: $f ($(pdfinfo "$f" 2>/dev/null | awk '/^Pages/{print $2}') páginas)"
done
