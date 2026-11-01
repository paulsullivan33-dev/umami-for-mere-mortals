# The Neighbours

**Outcome: you can say, for each nearby
tool, what it does that Umami doesn't —
and what Umami does that it doesn't — so
the choice between them is a decision,
not a guess.** These tools were not run
in this guide's lab; they are
characterised from their own
documentation, honestly and briefly.

## Google Analytics

The default of the web, and the tool
most Umami owners are leaving. It is
free, enormously capable, and hosted —
there is nothing to install or maintain.
The price is the model: data lives on
Google's machines, the tracker is built
for an advertising ecosystem, visitors
are followed across sites that use it,
and most owners need a consent banner
before it may legally run. Umami exists
for people who weighed exactly that and
wanted the honest counts without the
machinery around them. If you need deep
marketing attribution across ad
campaigns, Google's tool is built for it
and Umami plainly is not (chapter 13).

## Plausible

The closest neighbour in spirit:
privacy-first, cookieless, one small
script, a dashboard that fits on one
screen. The differences are in the
operating model. Plausible's comfortable
path is a paid hosted service — someone
else runs it, and it is genuinely
pleasant. Its self-hosted edition is
free but deliberately runs a version
behind the hosted one, and it stores
data in ClickHouse, a heavier database
than Umami's PostgreSQL, usually via
containers. Umami is MIT-licensed
through and through, self-hosting is
the main road rather than a side road,
and if you already run PostgreSQL for
other things, Umami moves into a house
that is already built.

## Matomo

The elder of self-hosted analytics —
it began as the open answer to Google
Analytics and it shows, in both
directions. It tracks far more: goals,
e-commerce, funnels, custom dimensions,
and (with plugins) heatmaps and session
recordings, and it can import your old
Google Analytics history. It also, by
default, thinks in terms of identified
visits more than Umami ever will, runs
on PHP and MySQL, and is a considerably
larger machine to keep patched. Choose
Matomo when you need the full
old-fashioned analytics workbench on
your own server; choose Umami when the
workbench is exactly what you were
trying to leave behind.

## GoAccess

A different species altogether: it reads
the **log files** your web server
already writes and builds a report — on
the terminal, or as an HTML page. No
script tag, no JavaScript, no database,
nothing added to your pages, and it
works on the past, which Umami cannot:
Umami only counts from the day you
install the script. GoAccess counts
every request the server saw, including
bots and feed readers and the requests
for files that are not pages at all,
which makes its numbers bigger and
rougher than Umami's. The two are not
really rivals — one reads the server's
diary, the other watches the room — and
some sites run both, GoAccess for "what
hit my server," Umami for "what did
people read."

## Your server's own logs, by hand

Worth naming as the zero option: `grep`,
`awk` and their kin over the same logs
GoAccess reads. Fine for a single
question on a quiet site, and this
series' text-tool guides will teach you
more there than this page can. What you
give up is everything continuous —
history kept tidy, referrers parsed,
countries looked up, a page you can
glance at — which is the whole reason
analytics programs exist.

## Where Umami wins, stated once

One small script, no cookies, no consent
banner in most jurisdictions, data in a
database you already know how to back
up, and nothing about your visitors
leaving your machine. If that sentence
is your requirement list, the neighbours
above are each missing at least one
clause of it — and if it isn't, this
chapter just told you where to go.
