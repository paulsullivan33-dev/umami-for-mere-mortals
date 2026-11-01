# Building and Starting

**Outcome: Umami compiled, its database
tables created by its own migrations,
and a server answering on its port —
ready for a first sign-in.** The build
is a pipeline of named steps; knowing
them individually turns a failed build
from a wall into a door.

## The pipeline

One command runs everything:

```bash
pnpm run build
```

Underneath, the release's `package.json`
chains these steps (the lab ran them in
this order, and the transcripts name
them one by one):

1. **check:env** — refuses to continue
   without `DATABASE_URL`.
2. **build:db** — Prisma generates the
   database client from
   `prisma/schema.prisma` (the lab's run:
   *Generated Prisma Client 7.10.0 in
   579 ms*).
3. **check:db** — connects to your
   database, checks its version, and
   applies any missing **migrations** —
   the versioned steps that create and
   evolve the tables. On the lab's empty
   database it applied all 26, ending
   with *Database is up to date*, and a
   `psql` listing afterwards showed 27
   tables, `website`, `session`,
   `website_event` and `user` among them.
   This is the step people mean by "run
   the schema": there is no SQL file to
   feed the database by hand.
4. **build:tracker** and
   **build:recorder** — compile the
   `script.js` your pages will load (the
   lab's is 4,773 bytes) and the optional
   session-recorder script.
5. **build:geo** — downloads the GeoIP
   table (`GeoLite2-City.mmdb`, about
   50 MB) into a `geo/` folder, from a
   public mirror of MaxMind's free data.
6. **build:openapi** and
   **build:packages** — generate the API
   description and compile Umami's
   internal packages.
7. **build:app** — the web application
   itself, compiled by Next.js (the lab:
   *Compiled successfully in 110 s*, 70
   pages, on a small shared machine with
   Node's heap capped at 2 GB —
   `NODE_OPTIONS=--max-old-space-size=2048`
   is worth setting on small machines).

Two honest lab notes. First, the
pipeline *re-verifies dependencies*
before it runs, and pnpm keeps its
package store in one place: if you
installed with a custom `--store-dir`,
say so in configuration or the build
will patiently download everything a
second time into the default store —
the lab did exactly that, once, so you
don't have to. Second, in the lab's
sandboxed network the Prisma engine
download inside the install stalled
forever; the fix was Prisma's own
documented escape hatch — fetch the
engine with `curl` and point
`PRISMA_SCHEMA_ENGINE_BINARY` at it —
and `build:geo`'s download needed the
same courtesy (`SKIP_BUILD_GEO=1` plus
the file fetched by `curl` into
`geo/`). On an ordinary network neither
detour is needed, but both are recorded
in the transcripts and in chapter 14,
because a stalled spinner is not an
error message.

## Starting it

```bash
PORT=18085 pnpm run start
```

Umami listens on port **3000** unless
`PORT` says otherwise; the lab used
18085 to keep out of other programs'
way. The start the lab saw:

```text
▲ Next.js 16.4.2
- Local:   http://localhost:18085
✓ Ready in 292ms
```

One warning rides along, worth
understanding rather than fearing:
Umami builds in Next.js *standalone*
mode, and `next start` prints that it
"does not work with output: standalone"
and suggests `node .next/standalone/server.js`.
In the lab the plain `pnpm start` server
nonetheless served everything this guide
tests — pages, API, tracker — but the
standalone server is the form the
project's own container image runs, and
either is a legitimate way up. Pick one
and be consistent.

## The check

```bash
curl -s http://127.0.0.1:18085/login | grep -o "<title>[^<]*</title>"
```

```text
<title>Login | Umami</title>
```

And the tracker your pages will load:

```bash
curl -s http://127.0.0.1:18085/script.js | head -c 80
```

A login page with Umami's name on it,
and minified JavaScript back from
`/script.js`: the machine is alive.
Chapter 5 walks through the door.
