#!/usr/bin/env bash
# Builds one zip per flavour into extension/out/.
# Usage: scripts/build.sh <version> <label> <sha>
#   version  full Chrome version, e.g. 1.0.101 (CI stamps it; never edited by hand)
#   label    shown in version_name, e.g. "pr-3" or "release"
#   sha      short commit SHA baked into version_name and config.js
set -euo pipefail
cd "$(dirname "$0")/.."

version=${1:?version}
label=${2:?label}
sha=${3:?sha}
out=out
rm -rf "$out"
mkdir -p "$out"

for flavour in $(jq -r '.flavours[]' release-targets.json); do
  dir="$out/dist-$flavour"
  mkdir -p "$dir"
  cp src/* "$dir/"
  name_suffix=$([ "$flavour" = prod ] && echo "" || echo " ($flavour)")
  jq --arg v "$version" --arg vn "$version ($flavour, $label, $sha)" --arg s "$name_suffix" \
    '.version = $v | .version_name = $vn | .name += $s' manifest.json > "$dir/manifest.json"
  printf 'self.EXT_CONFIG = { environment: "%s", buildSha: "%s" };\n' "$flavour" "$sha" > "$dir/config.js"
  (cd "$dir" && zip -qr "../dist-$flavour.zip" .)
done

sha256=$(command -v sha256sum >/dev/null && echo sha256sum || echo "shasum -a 256")
(cd "$out" && $sha256 dist-*.zip > SHA256SUMS)
# Permissions snapshot, diffed against the previous release before anything is published.
jq '{permissions, host_permissions, optional_permissions}' manifest.json > "$out/permissions.json"
ls -1 "$out"
