# Reading the Numbers

**Outcome: you can ask Umami the five
questions every site owner actually
asks — how much, which pages, from
where, with what, and when — in the
dashboard, and check any answer through
the API.** Every call below was run
against the lab's counted visit.

## The five numbers

`GET /api/websites/<id>/stats` takes two
dates as milliseconds since the epoch —
`startAt` and `endAt` — and returns the
headline figures for that window:

- **pageviews** — pages loaded.
- **visitors** — distinct
  session-identities in the window. Not
  people; chapter 13 is honest about the
  gap. One person on two devices, or
  morning and evening, can count twice.
- **visits** — sessions: sequences of
  pages grouped by the salted hash and
  an inactivity gap.
- **bounces** — visits that saw one
  page. The dashboard shows the *rate*;
  the API gives the count.
- **totaltime** — seconds summed across
  visits, measured between page views,
  which is why the last page of every
  visit contributes nothing and why very
  short visits read as zero.

Alongside sits a `comparison` block:
the same five numbers for the preceding
window of the same length, which is how
the dashboard draws its up-and-down
arrows. In the lab both windows were
nearly empty, so comparison was a row
of zeros — on a lived-in site it is the
difference between "busy" and "busy
*for a Tuesday*."

## The breakdowns

`GET /api/websites/<id>/metrics` with a
`type` answers "which ones," as a list
of `{x, y}` pairs — the name and the
count. The types the lab verified:

```bash
.../metrics?startAt=...&endAt=...&type=path
```
```text
[{"x":"/","y":1},{"x":"/about","y":1}]
```

```bash
.../metrics?type=referrer   → [{"x":"duckduckgo.com","y":1}]
.../metrics?type=browser    → [{"x":"firefox","y":1}]
.../metrics?type=country    → []
```

Pages, referrers, browsers, operating
systems, devices, languages, screens
and countries all come from this one
endpoint, one per call. Two things the
lab learned and you should keep: the
page type is called **`path`** in
version 3 (asking for `url` earns a
plain `400 Bad request` — older
write-ups use the old name), and an
empty list is an answer, not an error —
the country list was empty because the
lab's only visitor came from loopback,
exactly as chapter 6 explained.

## The event stream

`GET /api/websites/<id>/events` returns
the individual facts themselves, newest
first: each page view and custom event
with its page, referrer, browser,
country, and time. This is the
dashboard's *realtime-flavoured*
evidence drawer — when a number looks
wrong, the stream is where you go to
see the actual visits it was summed
from, and on a quiet site you can watch
your own phone's visit arrive by loading
a page and refreshing the stream.

## Reading like an owner

The dashboard arranges all of this as
charts, and for daily use it is the
right tool. The API earns its place
three ways: it lets a script ask (a
weekly "our five numbers" message to a
club committee is a five-line script
against chapter 7's calls — the lab's
client script lives in `umami-lab/`);
it lets you *verify*, since a number
you can reproduce with `curl` is a
number you can defend; and it is the
only door when the question is not one
the charts thought to ask. What neither
door gives you is certainty about
people: Umami counts visits the way a
turnstile counts entries, faithfully,
and a turnstile has never known anyone's
name. That is not a flaw in the
counting. It is the deal you made in
chapter 1, and it is a good one.
