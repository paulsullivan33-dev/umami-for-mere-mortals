# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's websites are `example.com` and `example.org`, its
   committee and its data invented for the purpose.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 13 names what the tool
   cannot do: visitors counted as hashed session-identities
   rather than people, no counting without JavaScript, no
   import of earlier history, countries as GeoIP estimates
   that local addresses do not get at all, no advertising
   machinery, indefinite data retention as the owner's manual
   chore, and the optional recorder and heatmap features this
   guide deliberately leaves off and untaught.
8. **The ethics rule is in the text, early.** Umami is a
   tracking tool, however gentle, so chapter 1 and the README
   state its line before any procedure depends on it: count
   your own site, in aggregate, with no cookies, no personal
   data and no cross-site profiles; a visitor's address is
   used only to estimate a country and to derive a one-way
   session hash — and the lab verified the strongest form of
   that claim, namely that the `session` table's schema has no
   column that could hold the address. Chapter 8 adds the
   owner's half of the rule: event data and URLs must never be
   used to smuggle identifying facts back in. Chapter 10 gives
   share links the same treatment — public by construction,
   created deliberately or not at all.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox,
shared with other work while the lab ran (the box also ran
several other guide labs at once; timings are therefore the
shared machine's, and the chapters say so where they quote
them). **Umami 3.4.1** was installed from the official release
tarball (`umami-software/umami`, tag `v3.4.1`) and run
unmodified. Node was the system **v24.22.1** (the project asks
for 18.18+), pnpm the project's pinned **12.3.4** (fetched with
npm into a scratch folder, the machine having no `corepack`),
and the database a dedicated **PostgreSQL 16.15** cluster the
lab created in its scratch space on port **55432**, loopback
only, with password (`scram-sha-256`) authentication. Umami
itself served on port **18085**. All transcripts live in
`umami-lab/transcripts/`; the API client the chapters quote is
`umami-lab/lab-client.sh`.

Two sandbox detours are recorded rather than hidden.
`pnpm run` re-verifies dependencies against its configured
store, and because the lab's install used a scratch
`--store-dir`, the first build attempt began re-downloading
into pnpm's default store before being stopped (t05); the
single `pnpm run build` wrapper was therefore replaced by its
own documented steps, run in its own order (build:db,
check:db, build:tracker, build:recorder, build:openapi,
build:packages, build:app), each exiting 0. And the Prisma
engine download inside the install **stalled indefinitely** in
this sandbox's proxied network (its connections never
completed, while `curl` reached the same host immediately);
the lab fetched the schema engine with `curl` and used
Prisma's documented `PRISMA_SCHEMA_ENGINE_BINARY` override,
and did the same for the GeoIP table (`SKIP_BUILD_GEO=1` plus
the 2026-10-30 `GeoLite2-City.mmdb` from the same mirror the
build script uses). On an ordinary network neither detour
should exist; both are written up in chapter 14.

Run for real, with transcripts as evidence:

- Environment, the release download and unpack, and the
  project's pinned versions read from its own `package.json` —
  Next 16.4.2, React 19, Prisma 7.10.0 (t00).
- The lab PostgreSQL cluster: `initdb` (including the first
  attempt's permission failure and the execute-only ACL fix),
  start on port 55432, database creation (t01); the switch
  from trust to password authentication, proven both ways —
  with the password connects, without it fails — including the
  `psql` prompt hang that `-w` prevents (t02).
- pnpm 12.3.4 obtained and version-checked; the one-line
  `.env` written (t03). `pnpm install --frozen-lockfile`:
  1023 packages resolved, exit 0, 13m 2s on the shared machine
  (t04).
- `build:db` (Prisma Client 7.10.0 generated) and `check:db`:
  connection and version checks green, all 26 migrations
  applied to the empty database, 27 tables listed afterwards,
  and the seeded `admin` user found in the `user` table (t06).
- Tracker, recorder, OpenAPI and workspace-package builds,
  each exit 0; the compiled `public/script.js` is 4,773 bytes
  (t07). The application build: Next.js 16.4.2 compiled
  successfully in 110 s, 70 static pages, exit 0 (t08).
- The running server (via `pnpm run start` on port 18085,
  which printed the standalone-mode warning and served
  everything regardless): the login page's title, the tracker
  at `/script.js`, and sign-in with the documented default
  `admin` / `umami` returning a token (t09).
- Website lifecycle: empty website list, then creation of
  "Example Site" (`example.com`) returning its UUID, and the
  tracking tag built from that issued id (t10).
- The counting round trip: stats all zero; two page views sent
  to `/api/send` the way the tracker sends them, returning the
  *same* session and visit ids; stats afterwards pageviews 2,
  visitors 1, visits 1, bounces 0 (t11). Metrics for path
  (`/` and `/about`, one each), referrer (duckduckgo.com) and
  browser (firefox); the country list empty, correctly, for a
  loopback visit; and the stored `website_event` and `session`
  rows read back with `psql` — browser firefox, OS Linux,
  device laptop, no country (t12). The `session` table's full
  column list was also read: it has no column for an IP
  address (t12 notes, from `\d session`).
- A named event (`newsletter-signup`) carrying data
  (`plan: monthly`) sent, stored, and read back in the event
  stream as event type 2 with `hasData: true`; the admin
  password changed through the API, the old password then
  refused with 401 and the new one accepted (t13).
- People and access, failures first: role `read-only`
  rejected with the API naming the valid roles; the teams
  endpoint returning its list shape; a share created without
  its required `name` (t14). Then, corrected: a `view-only`
  user created, seeing an empty website list, refused (401)
  when creating a website; a team created; a website created
  *into* the team; the user added as team-view-only and then
  able to read the team website's stats while still refused
  every write; a named share created and its public
  `/share/<slug>` page fetched with no sign-in; and a full
  `pg_dump` backup of the installation (51,878 bytes) (t15).
- The team trap, pinned down: attaching an existing website
  to a team via `POST /api/teams/<id>/websites` silently does
  nothing (that route is read-only; the team's website count
  stayed 0), and the "my websites" list folds in only teams
  the caller owns or manages, though a plain member's direct
  read access works (t16, t17).
- Clean shutdown of both the Umami server and the lab
  PostgreSQL (t18).

Documented only — described from the project's documentation,
not run, and the text does not claim otherwise:

- **A page view from a real browser.** The lab had no
  browser; visits were sent to `/api/send` with `curl` in the
  exact shape the tracker sends (which the endpoint cannot
  distinguish, and the transcripts show verbatim). The
  in-browser half — a page loading the tag, and the
  `data-umami-event` markup attributes of chapter 8 — is
  documented-only.
- The dashboard's screens as a human sees them. Every figure
  the chapters quote was taken from the API the dashboard
  itself reads; the login *page* was fetched and its title
  verified, but no clicking tour was possible or is claimed.
- Countries for real visitors: the GeoIP table is in place
  and the code path is the project's, but the lab's only
  traffic was loopback, which has no country — the guide
  shows the blank and explains it instead of staging a
  result.
- The Docker installation route, the standalone
  `server.js` run form beyond noting the warning and which
  form the project's image uses, Redis-backed and clustered
  deployments, two-factor sign-in, API keys, the reports
  beyond the verified endpoints (funnels, retention,
  journeys), link and pixel tracking, data export, and the
  session recorder and heatmap features — present in the
  schema, deliberately left disabled and untaught.
- The neighbour tools of chapter 12 (Google Analytics,
  Plausible, Matomo, GoAccess) — characterised, not run.

Fixtures are this guide's own and deliberately generic: two
invented websites (`example.com`, `example.org`), one invented
committee and team, a stock newsletter sign-up, and a search
engine as referrer. No real site was tracked, no real visitor
existed, and the lab's passwords — printed in the transcripts
because the lab was thrown away — protect nothing that still
exists.
