# Recipes

**Outcome: the jobs a small Umami
actually needs, done with the tools the
earlier chapters proved.** Each recipe
names what it assumes; the first four
were run in the lab.

## Back up everything, in one command

Assumes: chapter 3's database. Umami
keeps *all* of its state — websites,
users, every counted event — in the one
PostgreSQL database, so the whole
installation's memory is one dump:

```bash
pg_dump -h 127.0.0.1 -p 55432 -U umami_admin umami \
  > umami-backup.sql
```

The lab's dump, holding its handful of
visits, was 51,878 bytes — a text file
of SQL you could read, grep, and hand
to `psql` on a new machine to rebuild
the database wholesale. Schedule it the
way you schedule any backup, keep the
copies somewhere that is not the same
disk, and remember the dump contains
your users' password hashes and every
fact your visitors generated: guard it
like the database it is a copy of.

## The weekly numbers, as a message

Assumes: chapter 7's API and a token.
The lab's client script,
`umami-lab/lab-client.sh`, is this
recipe wearing overalls: sign in, ask
`/stats` for the last seven days, print
the five numbers. Pointed at a real
site and wired to a mail command or a
chat, it is the whole of a "how did the
site do" report — no dashboard visit
required, and the same shape works for a
committee that reads email better than
charts.

## A second site, kept apart

Assumes: chapter 5. One Umami counts
many websites, and their numbers never
mix: repeat the add-website step with
the other site's name and domain, take
*its* tracking tag for *its* pages.
Owners reach both from one sign-in;
chapter 10's teams are how you show one
site to one group and not the other.

## Publish the counts on purpose

Assumes: chapter 10. Create the share
link, and put the link itself on the
site — "our readership, counted without
tracking you, in public" is a sentence
few sites can say and fewer can prove.
The share shows live numbers to anyone,
forever, until you delete it; that is
the point, and the caution.

## Behind a proper web address

Documented, not run in the lab: in
production, Umami normally sits behind
a web server that gives it a real name
and HTTPS — `stats.example.com`, proxied
to Umami's port. The mechanics belong to
the server, and this series' nginx and
Caddy guides teach reverse proxying
properly; Caddy's automatic certificates
make it the shorter path. Two
Umami-side notes survive any proxy:
keep `PORT` and the proxy agreeing, and
give Umami its own subdomain rather
than a sub-path, so `script.js` and the
API keep the simple addresses this guide
has used throughout.
