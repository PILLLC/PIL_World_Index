#!/usr/bin/env bash
set -euo pipefail

FILE="data/relationships.yml"

if [[ ! -f "$FILE" ]]; then
  echo "ERROR: $FILE not found"
  exit 1
fi

# Replace TBD URLs with official NATO pages
# macOS sed requires: sed -i ''
sed -i '' \
  -e 's|title: "NATO member countries (official list)"\n        url: "TBD"|title: "NATO member countries (official list)"\n        url: "https://www.nato.int/cps/en/natohq/nato_countries.htm"|g' \
  -e 's|title: "NATO Relations with Ukraine (official overview)"\n        url: "TBD"|title: "NATO Relations with Ukraine (official overview)"\n        url: "https://www.nato.int/cps/en/natohq/topics_37750.htm"|g' \
  -e 's|title: "NATO–Ukraine Commission / partnership mechanisms (official)"\n        url: "TBD"|title: "NATO–Ukraine Commission / partnership mechanisms (official)"\n        url: "https://www.nato.int/cps/en/natohq/topics_37751.htm"|g' \
  -e 's|title: "NATO relations with Japan (official overview)"\n        url: "TBD"|title: "NATO relations with Japan (official overview)"\n        url: "https://www.nato.int/cps/en/natohq/topics_50336.htm"|g' \
  "$FILE"

echo "Updated URLs in $FILE"
echo "Review with: git diff"
