#!/bin/sh
# lab-client.sh -- the API flow this guide's lab actually ran, as one script.
# Signs in, lists websites, and prints the headline stats and the page,
# referrer and browser breakdowns for the first website, for a window
# covering the lab day (31 Oct - 2 Nov 2026, milliseconds since the epoch).
#
# Usage: UMAMI_PASSWORD=<password> ./lab-client.sh [base-url]
# The lab ran it against http://127.0.0.1:18085 with the lab passwords;
# the database it read was thrown away with the lab.
set -eu

BASE="${1:-http://127.0.0.1:18085}"
USER_NAME="${UMAMI_USER:-admin}"
PASSWORD="${UMAMI_PASSWORD:?set UMAMI_PASSWORD}"

TOKEN=$(curl -s -X POST "$BASE/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USER_NAME\",\"password\":\"$PASSWORD\"}" \
  | python3 -c "import json,sys;print(json.load(sys.stdin)['token'])")

echo "== my websites"
curl -s "$BASE/api/me/websites" -H "Authorization: Bearer $TOKEN"
echo

WID=$(curl -s "$BASE/api/me/websites" -H "Authorization: Bearer $TOKEN" \
  | python3 -c "import json,sys;print(json.load(sys.stdin)['data'][0]['id'])")

START=$(date -d "2026-10-31 00:00" +%s)000
END=$(date -d "2026-11-02 00:00" +%s)000

echo "== stats for $WID"
curl -s "$BASE/api/websites/$WID/stats?startAt=$START&endAt=$END" \
  -H "Authorization: Bearer $TOKEN"
echo

for TYPE in path referrer browser country; do
  echo "== metrics type=$TYPE"
  curl -s "$BASE/api/websites/$WID/metrics?startAt=$START&endAt=$END&type=$TYPE" \
    -H "Authorization: Bearer $TOKEN"
  echo
done
