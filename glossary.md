# Glossary

**API** — the machine-readable face of
Umami: the `/api/...` addresses the
dashboard itself uses, available to your
own scripts with a sign-in token.
Chapter 7 reads real numbers through it.

**Bounce rate** — the share of sessions
that viewed exactly one page and left.
A rough engagement signal, not a
verdict: a page that answers the
question at once bounces happily.

**Connection string** — the single line
that tells a program where its database
is: kind, user, password, address, port
and database name. Umami's lives in
`.env` as `DATABASE_URL`.

**Custom event** — a counted fact that
is not a page view: a named click or
action the site owner marked up, such as
a download or a sign-up button
(chapter 8).

**Dashboard** — Umami's web pages for
humans: sign in, pick a website, read
the charts. Everything it shows comes
from the API.

**GeoIP lookup** — matching an IP
address against a table of address
ranges (Umami carries the GeoLite2 City
table on disk) to estimate a country or
city. An estimate, never an identity.

**Hash** — a one-way fingerprint:
computed from data, impossible to
reverse into it. Umami hashes a daily
salt together with visit details to
recognise "the same session" without
storing anything that identifies it.

**Migration** — one versioned step of
database change, applied in order by
Prisma so the tables always match the
program version. `check-db` applies any
that are missing.

**Page view** — one loading of one page
by one visitor's browser: the atom
everything else is counted from.

**Prisma** — the database toolkit Umami
is built with. It generates the database
client from `prisma/schema.prisma` and
applies the migrations.

**Referrer** — the address of the page
that linked to yours, sent by the
browser with the visit. It is how "where
did our readers come from" gets answered
— and it is often empty, because direct
visits and privacy tools send none.

**Session** — one visit: a sequence of
page views from one browser, grouped by
the salted hash and a gap of inactivity.
One person can be several sessions a
day, and Umami neither knows nor minds.

**Share link** — a public address that
shows one website's dashboard to anyone
holding it, no account needed. Convenient
and public by construction — chapter 10.

**Team** — a group of Umami users
sharing access to a set of websites, so
a club's committee can all read the
counts without sharing one password.

**Token** — the credential the API
checks instead of a password: obtained
by signing in, sent in an
`Authorization: Bearer ...` header, and
worth guarding like a password.

**Tracker script** — `script.js`, the
small file your pages load from Umami.
It reports page views and marked-up
events to `/api/send` and sets no
cookies.

**UUID** — a long random identifier,
effectively unique. Each website in
Umami has one; it is what the script
tag's `data-website-id` carries.

**Visitor** — in Umami's counting, one
distinct session-identity in the period
asked about. An approximation of "a
person," deliberately too weak to ever
point at one.
