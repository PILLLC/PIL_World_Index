#!/usr/bin/env bash
set -euo pipefail

# Bootstrap MVP structure + templates + example country profiles for PIL World Index
# Usage:
#   ./scripts/bootstrap_mvp.sh
#   ./scripts/bootstrap_mvp.sh --force   # overwrite existing template/example files

FORCE=0
if [[ "${1:-}" == "--force" ]]; then
  FORCE=1
fi

ROOT="$(pwd)"

# ---- helpers ----
ensure_dir() { mkdir -p "$1"; }

write_file() {
  local path="$1"
  local content="$2"
  if [[ -f "$path" && "$FORCE" -eq 0 ]]; then
    echo "SKIP (exists): $path"
    return 0
  fi
  ensure_dir "$(dirname "$path")"
  printf "%s" "$content" > "$path"
  echo "WRITE: $path"
}

today_iso() {
  # macOS date
  date +"%Y-%m-%d"
}

release_tag() {
  # simple release tag based on date
  date +"%Y.%m.%d"
}

# ---- structure ----
ensure_dir "templates"
ensure_dir "countries"
ensure_dir "docs"
ensure_dir "scripts"

LAST_UPDATED="$(today_iso)"
RELEASE="$(release_tag)"

# ---- templates ----

COUNTRY_INDEX_TEMPLATE_CONTENT=$(cat <<'EOF'
= {country-name}
:iso3: {iso3}
:iso2: {iso2}
:wdid: {wdid}
:last-updated: {last-updated}
:release: {release}

== Overview
A concise, descriptive summary of the country or territory based on registered
sources. This section may be AI-assisted but must not introduce unsourced facts.
footnote:[Primary sources listed in the Sources Registry.]

== Key Indicators
[cols="1,1,1,1",options="header"]
|===
| Indicator | Value | Year | Source
| Population | {population} | {population-year} | footnote:[World Bank Open Data, SP.POP.TOTL, {population-year}.]
| GDP (current US$) | {gdp} | {gdp-year} | footnote:[World Bank Open Data, NY.GDP.MKTP.CD, {gdp-year}.]
| GDP per capita (US$) | {gdp-per-capita} | {gdp-per-capita-year} | footnote:[World Bank Open Data, NY.GDP.PCAP.CD, {gdp-per-capita-year}.]
|===

== Sources & Notes
* All values reflect the most recent year available at release time.
* Sources are documented in `/sources/registry.yml`.
* This profile corresponds to release `{release}`.
EOF
)

COUNTRY_CONTEXT_TEMPLATE_CONTENT=$(cat <<'EOF'
= {country-name} — Context Profile
:iso3: {iso3}
:iso2: {iso2}
:wdid: {wdid}
:last-updated: {last-updated}
:release: {release}

== Purpose and scope
This context profile provides descriptive, non-advocacy background
to supplement the country index indicators. It is intended to explain
what is happening, why it matters, and what is being watched.

Content may be AI-assisted but must not introduce unsourced factual claims.

== Current context
A short narrative overview of significant political, economic, security,
or environmental conditions as of `{last-updated}`.

== Governance and institutions
=== Political system
Describe the form of government, stability, and recent changes.

=== Leadership
Identify current leadership and succession context if relevant.

=== Institutional capacity
High-level descriptive assessment of administrative effectiveness and rule of law.

== Economic context
=== Economic trajectory
Narrative description of growth, contraction, or transition trends.

=== Key dependencies
Critical exports, imports, or financial dependencies.

=== Risk factors
Inflation, debt stress, labor issues, or external exposure.

== Social and demographic considerations
=== Population dynamics
Urbanization, aging, migration, displacement trends.

=== Human development factors
Education, healthcare access, inequality (descriptive, sourced).

== Infrastructure and systems
=== Energy and utilities
Energy mix, reliability, constraints.

=== Transportation and logistics
Internal connectivity and external access.

=== Digital and communications
Telecom penetration, censorship, or cyber posture (if relevant).

== Security and risk environment
=== Internal security
Crime, insurgency, unrest, or law enforcement capacity.

=== External security
Defense posture, alliances, or conflicts.

=== Non-traditional risks
Climate, disasters, food or water stress.

== What to watch
A short, forward-looking but non-predictive list of items observers are monitoring.

* {watch-item-1}
* {watch-item-2}
* {watch-item-3}

== Sources
All claims must be traceable to registered sources.

*Primary references:*
* {src-1}
* {src-2}

*Supporting references:*
* {src-3}
* {src-4}

== Notes and limitations
* This profile reflects conditions as of `{last-updated}`.
* Narrative sections summarize source material and may omit nuance.
* Updates occur on a best-effort basis per release `{release}`.
EOF
)

write_file "templates/country-index.template.adoc" "$COUNTRY_INDEX_TEMPLATE_CONTENT"
write_file "templates/country-context.template.adoc" "$COUNTRY_CONTEXT_TEMPLATE_CONTENT"

# ---- examples ----
# Minimal, robust MVP examples: an index card + context per country.
# Values are placeholders suitable for structure testing and can be replaced by your pipeline.

make_country() {
  local slug="$1"
  local name="$2"
  local iso3="$3"
  local iso2="$4"
  local wdid="$5"

  ensure_dir "countries/${slug}"

  local index_path="countries/${slug}/index.adoc"
  local context_path="countries/${slug}/context.adoc"

  local index_content
  index_content=$(cat <<EOF
= ${name}
:iso3: ${iso3}
:iso2: ${iso2}
:wdid: ${wdid}
:last-updated: ${LAST_UPDATED}
:release: ${RELEASE}

== Overview
${name} is included in the PIL World Index as an MVP exemplar profile. This overview is intentionally conservative and should be replaced with a sourced summary once pipelines are connected. footnote:[Primary sources are tracked in the Sources Registry.]

== Key Indicators
[cols="1,1,1,1",options="header"]
|===
| Indicator | Value | Year | Source
| Population | (TBD) | (TBD) | footnote:[World Bank Open Data, SP.POP.TOTL, (TBD).]
| GDP (current US$) | (TBD) | (TBD) | footnote:[World Bank Open Data, NY.GDP.MKTP.CD, (TBD).]
| GDP per capita (US$) | (TBD) | (TBD) | footnote:[World Bank Open Data, NY.GDP.PCAP.CD, (TBD).]
|===

== Sources & Notes
* MVP placeholder values will be replaced by scripted data pulls.
* Sources are documented in \`/sources/registry.yml\`.
* This profile corresponds to release \`${RELEASE}\`.
EOF
)

  local context_content
  context_content=$(cat <<EOF
= ${name} — Context Profile
:iso3: ${iso3}
:iso2: ${iso2}
:wdid: ${wdid}
:last-updated: ${LAST_UPDATED}
:release: ${RELEASE}

== Purpose and scope
This context profile supplements the index indicators with descriptive context.
It is an MVP exemplar intended to validate structure, tone, and update workflow.

== Current context
(TBD) Replace with a sourced, neutral narrative covering salient governance, economic, security, and infrastructure context as of \`${LAST_UPDATED}\`.

== Governance and institutions
=== Political system
(TBD)

=== Leadership
(TBD)

=== Institutional capacity
(TBD)

== Economic context
=== Economic trajectory
(TBD)

=== Key dependencies
(TBD)

=== Risk factors
(TBD)

== Social and demographic considerations
=== Population dynamics
(TBD)

=== Human development factors
(TBD)

== Infrastructure and systems
=== Energy and utilities
(TBD)

=== Transportation and logistics
(TBD)

=== Digital and communications
(TBD)

== Security and risk environment
=== Internal security
(TBD)

=== External security
(TBD)

=== Non-traditional risks
(TBD)

== What to watch
* (TBD)
* (TBD)
* (TBD)

== Sources
*Primary references:*
* (TBD — add source IDs from the Sources Registry)

*Supporting references:*
* (TBD)

== Notes and limitations
* MVP content is placeholder; do not treat as authoritative.
* Replace all non-trivial statements with sourced claims.
EOF
)

  write_file "$index_path" "$index_content"
  write_file "$context_path" "$context_content"
}

make_country "usa" "United States" "USA" "US" "Q30"
make_country "japan" "Japan" "JPN" "JP" "Q17"
make_country "ukraine" "Ukraine" "UKR" "UA" "Q212"

# ---- summary ----
cat <<EOF

✅ PIL World Index MVP bootstrap complete.

Created/updated:
- templates/country-index.template.adoc
- templates/country-context.template.adoc
- countries/usa/{index.adoc,context.adoc}
- countries/japan/{index.adoc,context.adoc}
- countries/ukraine/{index.adoc,context.adoc}

Next:
1) Review files
2) git status -sb
3) git add -A && git commit -m "Bootstrap MVP country templates and exemplars" && git push

EOF
