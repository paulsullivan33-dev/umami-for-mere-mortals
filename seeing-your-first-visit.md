# Seeing Your First Visit

**Outcome: a visit has been counted,
the numbers moved from zero to true,
and you have seen the stored rows with
your own eyes.** The lab had no browser
to visit with, so it sent its visit the
way `script.js` itself does — an honest
substitute, because the collection door
cannot tell the difference, and this
chapter shows both what was sent and
what it became.

## What the script sends

When a page carrying the tag is viewed,
`script.js` posts a small bundle to
`/api/send`. Here is the lab's first one,
sent with `curl` and a browser's
user-agent string, for the home page of
Example Site, arriving from a search
engine:

```bash
curl -X POST http://127.0.0.1:18085/api/send \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0)
       Gecko/20100101 Firefox/128.0" \
  -d '{"type":"event","payload":{
        "website":"b7ccefd2-6484-456f-8642-9371019c17c9",
        "url":"/","referrer":"https://duckduckgo.com/",
        "hostname":"example.com","language":"en-GB",
        "screen":"1920x1080"}}'
```

Umami answered with the identity it had
minted for this visit:

```text
{"sessionId":"163dfbbf-a4cb-5278-9489-3f95b1ee263f",
 "visitId":"e909600c-e514-5dc9-bd33-fe9813051747", ...}
```

A second send, for `/about` a moment
later, returned the *same* session and
visit ids — that is the salted-hash
grouping of chapter 2, working: no
cookie was set, nothing was stored in a
browser (there was no browser), yet the
two pages belong to one visit because
the facts that define the visit match.

## The numbers move

Before the visit, the statistics for
the lab's window were:

```text
{"pageviews":0,"visitors":0,"visits":0,"bounces":0,"totaltime":0}
```

After it:

```text
{"pageviews":2,"visitors":1,"visits":1,"bounces":0,"totaltime":0}
```

Two pages, one visitor, one visit, and
no bounce — a bounce is a visit that
sees exactly one page, and ours saw
two. `totaltime` is still zero because
time on site is measured between pages,
and the lab's visit was nearly
instantaneous. In the dashboard these
are the big numbers at the top of the
website's page, with the same values —
the dashboard reads this very API, which
is why this guide trusts `curl` as a
witness.

## The rows themselves

Because the database is yours, the
strongest check is to look at what was
actually stored:

```sql
select url_path, referrer_domain, event_type
from website_event order by created_at;
```

```text
 url_path | referrer_domain | event_type
----------+-----------------+-----------
 /        | duckduckgo.com  |          1
 /about   |                 |          1
```

and the session that carries the visit:

```sql
select browser, os, device, language, screen, country
from session;
```

```text
 browser |  os   | device | language |  screen   | country
---------+-------+--------+----------+-----------+--------
 firefox | Linux | laptop | en-GB    | 1920x1080 |
```

`event_type` 1 means page view (chapter
8 meets type 2). Notice the session row
once more: Firefox on Linux, a laptop —
the device was *inferred* from the
browser string and the screen size — and
a **blank country**. That blank is
correct, and understanding it matters:
the lab's visit came from `127.0.0.1`,
this same machine, and loopback
addresses have no country in the GeoIP
table. A visitor from a real address
fills that cell from the table on disk.
The metrics API agreed with the rows —
asked for the referrers, it said
`duckduckgo.com: 1` — which is the whole
method of this guide in one gesture: the
dashboard, the API, and the database,
three witnesses, one story.
