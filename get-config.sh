#!/bin/bash

dir="$1"; find "$dir" -type f -print0 | while IFS= read -r -d '' f; do rel="${f#$dir/}"; printf '### %s\n```\n' "$rel"; cat "$f"; printf '```\n\n'; done