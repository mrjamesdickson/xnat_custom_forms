find . -maxdepth 1 -type f -name '*.json' -print0 \\n  | while IFS= read -r -d '' f; do ./upload_forms.sh "$f"; done
