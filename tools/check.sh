#!/bin/bash
# Uso: tools/check.sh chapters/t1.typ [GRUPO ...]      (grupos: T1, C-T1, F-R8, …)
#   Compila un archivo de capítulo con la plantilla del libro. Si se dan grupos,
#   añade al final sus claves y soluciones (como saldrán en el apéndice D).
#   Salida: build/<nombre>.pdf
#   PNG=1          → además renderiza todas las páginas en build/png/<nombre>-NN.png
#   PNG=1 PAGES=3-5 → solo esas páginas
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1#/}"; shift
SRC="${SRC#$ROOT/}"
NAME="$(basename "$SRC" .typ)"
WRAP="$ROOT/build/check-$NAME.typ"
mkdir -p "$ROOT/build"
{
  echo '#import "/lib/template.typ": *'
  echo '#show: libro'
  echo "#include \"/$SRC\""
  if [ $# -gt 0 ]; then
    echo '#pagebreak()'
    for g in "$@"; do echo "=== Soluciones del grupo $g"; echo "#soluciones(\"$g\")"; done
  fi
} > "$WRAP"
typst compile --root "$ROOT" --font-path "$ROOT/fonts" "$WRAP" "$ROOT/build/$NAME.pdf"
echo "OK: build/$NAME.pdf ($(pdfinfo "$ROOT/build/$NAME.pdf" | awk '/^Pages/{print $2}') páginas)"
if [ "${PNG:-0}" = "1" ]; then
  mkdir -p "$ROOT/build/png"
  rm -f "$ROOT/build/png/$NAME-"*.png
  if [ -n "${PAGES:-}" ]; then
    pdftoppm -r 75 -png -f "${PAGES%-*}" -l "${PAGES#*-}" "$ROOT/build/$NAME.pdf" "$ROOT/build/png/$NAME"
  else
    pdftoppm -r 75 -png "$ROOT/build/$NAME.pdf" "$ROOT/build/png/$NAME"
  fi
  ls "$ROOT/build/png/$NAME-"*.png
fi
