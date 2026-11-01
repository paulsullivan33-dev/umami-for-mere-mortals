# Troubleshooting

**Outcome: the failures this guide's
lab actually met have names and fixes,
and the rest have a method.** In order
of appearance:

## `initdb` cannot see its own folder

The lab's first database died with
*could not access directory: Permission
denied* — PostgreSQL refuses to run as
root, so its system user does the work,
and that user must be able to *traverse*
the path to the data folder. Fix the
path's permissions for that user
(execute-only access with `setfacl` was
enough) rather than opening up your home
directory, and empty out any half-made
data folder before re-running `initdb`:
it will not adopt a directory that
already has files in it.

## `psql` hangs instead of failing

Asking `psql` to connect with the wrong
(or no) password, inside a script, can
sit forever at an interactive password
prompt. The flag is `-w`: *never
prompt*. With it, a bad connection fails
in a line — `fe_sendauth: no password
supplied` — which is what a script, and
a troubleshooter, actually needs.

## The build downloads everything again

`pnpm run` re-verifies dependencies
before running, and it compares against
*its* configured package store. Install
with a custom `--store-dir` and the next
`pnpm run` will cheerfully re-download
the world into the default store. One
store, named consistently — in the
project configuration, not only on one
command line — is the whole fix. (In
pnpm 12 the project `.npmrc` was *not*
where `store-dir` took effect for this;
the lab recorded the detour in
transcript t05.)

## The install stalls on Prisma's engines

In restricted networks the Prisma
engine download inside the install can
stall without an error — the lab's
strace showed its connections never
completing while `curl` reached the same
host at once. Prisma's documented
overrides end the stall: download the
engine with a tool that works and name
it —

```bash
export PRISMA_SCHEMA_ENGINE_BINARY=/path/to/schema-engine
```

— after which `prisma migrate deploy`
(the step inside `check:db`) runs
against your engine. The same pattern
rescues `build:geo`'s GeoIP download:
fetch `GeoLite2-City.mmdb` into `geo/`
yourself and build with
`SKIP_BUILD_GEO=1`. A spinner is not a
diagnostic; when a download hangs, ask
*which host, which tool* before retrying.

## `next start` warns about standalone

The warning is real and the server, in
the lab, worked anyway — every page,
API call and script in this guide was
served by it. If yours misbehaves
(missing static assets are the classic
symptom), switch to the standalone
form the message names:
`node .next/standalone/server.js`. Do
not mix the two on one build.

## `400 Bad request` from the metrics API

Version 3 renamed the page metric:
`type=path`, not `type=url`. In general,
a `400` from this API is not a wall —
its error bodies name the valid options,
word for word. The lab set a user's
role from exactly such a message:
`read-only` was refused with *expected
one of "admin"|"user"|"view-only"*, and
`view-only` worked. Read the error, do
what it says.

## The team website that isn't there

If a team shows `_count.websites: 0`
after you "added" a site, you met the
lab's trap: `POST /api/teams/<id>/websites`
does not attach existing sites (the
route is read-only), and its silent
empty reply looks like success. Create
the website *with* the `teamId`
(chapter 10), then confirm with
`GET /api/teams/<id>/websites` — counts
you have not re-read are counts you are
guessing at.

## Numbers that are zero, or missing

Work the witnesses in order. Is the tag
on the page, with *this* site's UUID —
and is `/script.js` loading from your
Umami (the browser's network tab tells
all)? Did the visit come from loopback
or a blocker-equipped browser, either
of which counts as nothing, correctly?
Is the date window the one you think
(the API wants milliseconds, and the
comparison window is the same length
again before it)? And finally, ask the
database: if the row is not in
`website_event`, the visit never
arrived, and no dashboard setting will
invent it.
