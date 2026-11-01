# Umami for Mere Mortals

Most website statistics come with a
chaperone: a big company's script on
your pages, cookies on your visitors'
machines, and your readers' movements
filed away on someone else's computer.
**Umami** counts with the chaperone
left out. It is a program you run
yourself. It counts page views,
referrers, browsers and countries; it
sets **no cookies**, builds no profiles,
and stores everything in a **PostgreSQL**
database on your own disk. The tracking
script is small enough to read, the
data it sends is a page view and nothing
more personal, and the visitor's address
is used to estimate a country and then
reduced to a hash that cannot be read
backwards. Counting is not spying, and
this tool's shape exists to keep that
sentence true.

This guide explains how Umami's pieces
fit together, how to build and run it
from its official source, and how to
read what it counts — in the dashboard,
through its API, and straight out of
the database, because a number you can
check three ways is a number you can
defend.

The lab that wrote this guide ran the
real thing: **Umami 3.4.1**, built from
the official release source with
**Node 24** and **pnpm 12**, against a
real **PostgreSQL 16** cluster it made
for the purpose. Against that machine
the lab signed in with the documented
default admin, changed the password and
watched the old one fail, registered a
website, took the tracking tag it
issued, and sent it a two-page visit the
same way the tracking script sends it.
The counters moved exactly as they
should — page views 0 to 2, one visitor,
one visit — the same session was
recognised across both pages with no
cookie anywhere, and the stored rows
were read back out of the database to
prove the dashboard honest. A named
event with data of its own, a view-only
user, a team sharing a website, a
public share link, and a one-command
backup were each exercised the same
way, refusals included.

What the lab could not do, it did not
fake. It had no real browser and no
real visitors: every "visit" was sent
to the collection door the way the
script sends it, which the door itself
cannot distinguish, but the *clicking*
side — a page in a browser, the markup
attributes that label a button — is
taught from the project's documentation
and labelled as such. Countries cannot
be proven from a machine whose only
visitors live on loopback, and chapter
6 shows the blank cell and explains it
rather than hiding it. `criteria.md`
keeps the full ledger of what was run
and what was only read.

## What this guide covers

- [**What Umami is**](what-umami-is.md) —
  the mental model: counting without
  cookies or profiles, and the ethics
  line stated before any procedure
- [**The moving parts**](the-moving-parts.md) —
  the tracker script, the collection
  door, the database tables, the
  dashboard and the API, followed end
  to end through one page view
- [**Installing Umami**](installing-umami.md) —
  Node, pnpm, a PostgreSQL database, the
  source, and the one line of
  configuration that joins them
- [**Building and starting**](building-and-starting.md) —
  the build pipeline step by step, the
  migrations that create the tables,
  and a login page that proves it lives
- [**Your first website**](your-first-website.md) —
  signing in, replacing the password
  everybody knows, registering a site,
  and the tracking tag
- [**Seeing your first visit**](seeing-your-first-visit.md) —
  a visit sent and counted, sessions
  recognised without cookies, and the
  stored rows inspected directly
- [**Reading the numbers**](reading-the-numbers.md) —
  the five headline figures, the
  breakdowns, the event stream, and
  what the API's answers mean
- [**Events beyond page views**](events-beyond-page-views.md) —
  named events with data of their own,
  and the restraint they require
- [**People and access**](people-and-access.md) —
  users, the three roles, teams that
  share websites, and public share links
- [**Recipes**](recipes.md) — the
  one-command backup, a weekly numbers
  script, more sites, published counts,
  and the road to a real web address
- [**The neighbours**](the-neighbours.md) —
  Google Analytics, Plausible, Matomo
  and GoAccess: what each does that
  Umami doesn't, and vice versa
- [**Limits**](limits.md) — counting
  loads rather than people, no history
  before today, estimated countries,
  and data retention as the owner's chore
- [**Troubleshooting**](troubleshooting.md) —
  the permission-denied database, the
  hanging password prompt, the double
  download, the stalled engine, and the
  team website that was never attached
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Running Umami at company scale — many
sites, heavy traffic, the clustered
deployment with Redis that the project
documents for its cloud edition.
Importing history from another analytics
platform: Umami cannot, and chapter 13
says so plainly. The optional session
recorder and heatmap features: they are
named in chapter 13 as existing and
deliberately left off, because they
watch visitors far more closely than
this guide's counting does, and turning
them on is a decision that deserves its
own thought. And the legal side in
detail — Umami's design puts most
installations outside consent-banner
territory, but your obligations are
yours, and this guide is not a lawyer.

## How to use this guide

Read chapters 1 and 2 before installing
anything: knowing what the tracker may
and may not learn, and which table holds
what, turns later confusion into a named
problem. Chapters 3 and 4 build the
machine; chapter 5 signs you in and
changes the password in the same
sitting — do not split those two steps
across days. Chapter 6 is the one to
read slowly: its three-witness habit —
dashboard, API, database — is how you
will trust every number afterwards. The
lab's transcripts live in
`umami-lab/transcripts/` and its API
client script is `umami-lab/lab-client.sh`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [PostgreSQL for Mere Mortals](https://paulsullivan33-dev.github.io/postgresql-for-mere-mortals/)
- [Node.js for Mere Mortals](https://paulsullivan33-dev.github.io/nodejs-for-mere-mortals/)
- [Docker for Mere Mortals](https://paulsullivan33-dev.github.io/docker-for-mere-mortals/)
- [nginx for Mere Mortals](https://paulsullivan33-dev.github.io/nginx-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/umami-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/umami-for-mere-mortals/blob/main/LICENSE-CODE).
