# The Moving Parts

**Outcome: you can name every piece of
Umami, say which piece holds what, and
follow one page view from a reader's
browser to a number on the dashboard.**
Five pieces, one database, no hidden
sixth piece phoning home.

## The tracker script

Every website Umami watches loads one
small JavaScript file, `script.js`,
served by your Umami itself. A page
owner adds it with a script tag carrying
a `data-website-id` — a long random
identifier (a **UUID**) that says which
website this copy of the script reports
for. The script's whole job is to notice
"this page was just viewed" (and, if the
owner has marked up buttons or links,
"this named thing was clicked") and to
send that fact to Umami. It sets no
cookies and stores nothing in the
browser, which is why closing the tab
leaves no trace on the visitor's machine.

## The collection door

The script sends its facts to one
address: `POST /api/send`. A page view
arrives as a small bundle of JSON — the
website's UUID, the page's address, the
**referrer** (the page that linked
here), the browser's name, the operating
system, the device type, the language,
and the screen size. Notice what is not
in the bundle: no name, no account, no
advertising identifier. The visitor's IP
address travels with the request, as it
does with every web request; Umami uses
it to look up a country in a **GeoIP**
table it keeps on disk, and to compute a
one-way **hash** — a fingerprint that
groups one visit's pages together but
cannot be read backwards into the
address. The address itself is not
stored.

## The database

Everything Umami remembers lives in one
**PostgreSQL** database — PostgreSQL is
a separate program, a database server,
and this guide's lab runs a real one
(chapter 3). The tables have plain names
and hold exactly what you would hope:

- `website` — the sites being counted,
  one row each, holding the UUID the
  script tag carries.
- `website_event` — every page view and
  custom event, one row per fact.
- `session` — one visit: a browser, a
  country, a first and last time, tied
  together by the salted hash, not by
  anything that identifies a person.
- `user` — the people allowed to *look*
  at the dashboard. Your visitors are
  never rows in this table; only site
  owners and their teammates are.
- A few more for reports, teams,
  short links, tracking pixels, and
  saved settings — chapter 10 meets the
  ones a small site will touch.

Because it is an ordinary database, you
can inspect it with ordinary tools —
chapter 7 reads the counted page view
straight out of `website_event` with
`psql` to prove the dashboard is not
making anything up — and back it up
with one `pg_dump` (chapter 11).

## The dashboard and the API

The program you build and start in
chapters 3 and 4 is one **Node.js**
application that does three jobs on one
port: it serves `script.js` to your
pages, it answers the collection door,
and it serves the **dashboard** — the
web pages where owners sign in and read
their numbers. Under the dashboard sits
an **API**: every number on screen is
fetched from an `/api/...` address with
the signed-in user's token, which means
anything the dashboard can show, a
script of yours can ask for too.
Chapter 7 uses that API with `curl` to
read the lab's counted visit back,
number for number.

## The people

Umami has exactly two kinds of people.
**Visitors**, who are counted in
aggregate and never identified. And
**users** — owners and teammates who
sign in. A fresh install has one user,
`admin`, with a documented starting
password, and chapter 5's first act is
to change it. Users can be given roles
and grouped into **teams** that share
access to some websites and not others
(chapter 10); a website can also be
given a public **share link** so anyone
with the link can view its dashboard
without an account — a kindness to use
deliberately, since it publishes your
counts to whoever holds the link.

## One page view, end to end

1. A reader opens a page carrying the
   script tag.
2. `script.js` runs and posts the view
   to `/api/send`.
3. Umami parses the browser details,
   looks the country up in its GeoIP
   table, hashes the session identity,
   and writes one row to `website_event`
   (starting a `session` row if this
   visit is new).
4. The owner opens the dashboard, or a
   script calls the API, and the counts
   are computed from those rows.

Four steps, all inside machines you
control. Everything after this chapter
is operating that machine well.
