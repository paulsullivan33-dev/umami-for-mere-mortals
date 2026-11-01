# What Umami Is

You have a website — a blog, a club page,
a small shop, a project site — and you
would like to know whether anyone reads
it. The familiar way to find out is to
paste a script from a big analytics
company into your pages. It works. It
also means your visitors' movements are
recorded on someone else's computer, by a
script that sets cookies, builds profiles,
and answers questions you never asked,
under rules you did not write.

**Umami is web analytics with the
surveillance left out.** It is a program
you run on your own machine (or a small
server you control). It counts what a
site owner honestly needs — which pages
were viewed, where visitors arrived from,
which browsers and countries they used,
roughly how long they stayed — and it is
designed, on purpose, to *not* know who
anybody is. It sets **no cookies**. It
does not fingerprint devices. It does not
build cross-site profiles, because there
is no centre for the data to phone home
to: the database sits next to the
program, on your disk, and nothing leaves
unless you carry it.

That design is the ethics line of this
guide, and it belongs up front, before
any installing: **analytics you run
yourself, about your own site, that
collects aggregate counts instead of
people.** The tracking script is small
and readable, the data it sends is a
page view — a page address, a referrer,
a browser name, a language, a screen
size — and the visitor's IP address is
used only long enough to estimate a
country and to group one visit's pages
into a session, then reduced to a hash
that cannot be turned back into the
address. Respecting a visitor's
Do-Not-Track setting is a switch the site
owner can flip on. Counting is not
spying, and Umami's whole shape exists
to keep that sentence true.

## A first taste

A website owner adds one line to their
pages:

```html
<script defer src="https://stats.example.com/script.js"
  data-website-id="9f1c2a44-..."></script>
```

From then on, each page load quietly
tells Umami "this page was viewed," and
the owner's dashboard fills in: views
over time, the popular pages, the sites
that sent people here. The lab that
wrote this guide could not browse the
web like a person, so it did the honest
equivalent — it built Umami from its
official source, ran it against a real
database, registered a website, took the
exact script tag Umami issued, and sent
it a page view the same way the script
does, then read the counted result back
through Umami's own API. Chapter 6 shows
that round trip and its numbers.

## What it is not

Umami is not an advertising tool: no
remarketing, no audiences-for-sale, no
conversion funnels tied to identities.
It is not a heatmap or session-recording
tool — it never sees a mouse move or a
form being filled. It is not a log-file
analyser: it counts live visits as they
happen, not yesterday's server logs
(GoAccess, in chapter 12, is the tool
for that). And it is not a monitoring
system for servers — it knows nothing
about your CPU or your disk; it counts
*pages*, and chapter 12 is plain about
where its edges are.

## Who it is for

The site owner who left the big analytics
platforms over consent banners and data
sharing, and wants the honest ten per
cent of the numbers without the rest.
The club or society webmaster who must
be able to say, truthfully, "our site
does not track you." The self-hoster who
already runs a small server and a
database and would rather one more
service lived there too. The common
thread is a person with a website, a
conscience about their visitors, and no
need to know anything about them beyond
"someone in this country read this page
on a phone."

## The honest catch, up front

Umami is a real web application, not a
single small binary: it needs **Node.js**
to run and **PostgreSQL** to remember
anything, and building it from source
takes a few minutes and a noticeable
amount of memory. The lab's small shared
machine felt that; chapter 4 says how
much. In return you get software whose
entire data flow fits in one chapter
(chapter 2), whose database you can back
up with one command (chapter 11), and
whose counts you can defend line by line
to anyone who asks — including, in the
lab's case, to an API query in chapter 7.
