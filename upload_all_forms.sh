#!/bin/sh
set -eu
chmod +x upload_forms.sh
find . -type f -name '*.json' -exec ./upload_forms.sh {} \;
