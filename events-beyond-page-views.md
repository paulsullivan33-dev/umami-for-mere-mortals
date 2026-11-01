# Events Beyond Page Views

**Outcome: you can count things that
are not pages — a click, a download, a
sign-up — as named events, each carrying
a few facts of its own.** Page views
tell you what was read. Events tell you
what was *done*.

## A named event

An event is a page view's sibling: same
door (`/api/send`), same session
grouping, but carrying a **name** the
owner chose. The lab sent one for a
newsletter sign-up on a `/join` page:

```bash
curl -X POST http://127.0.0.1:18085/api/send \
  -H "Content-Type: application/json" \
  -H "User-Agent: Mozilla/5.0 ..." \
  -d '{"type":"event","payload":{
        "website":"b7ccefd2-...","url":"/join",
        "hostname":"example.com",
        "name":"newsletter-signup",
        "data":{"plan":"monthly"}}}'
```

and read it back in the event stream as
`eventType: 2` (page views are type 1),
`eventName: "newsletter-signup"`,
`hasData: true`, filed under the same
session as the earlier pages. The
attached **data** — here one pair,
`plan: monthly` — is stored in the
`event_data` table, keyed to the event,
ready for the dashboard's event-data
views and the API's `event-data`
endpoints to slice: sign-ups by plan,
downloads by file, clicks by button.

## Marking up a page

In real pages you do not hand-send
these; you *label* the element and the
tracker does the sending. Adding
`data-umami-event="newsletter-signup"`
to a button or link makes Umami report
a click on it as an event of that name,
and attributes named
`data-umami-event-<key>` ride along as
its data. That markup form is taught
from the project's documentation — the
lab verified the receiving end (the
send, the storage, the read-back)
rather than a browser's click, and
`criteria.md` keeps that distinction
where it belongs.

## Restraint, again

Event data is the one place Umami lets
a site owner attach *arbitrary* facts
to a visit, and so it is the one place
the chapter 1 ethics line needs an
owner's active care. The tool will
happily store whatever keys you send.
Sending `plan: monthly` is counting.
Sending an email address, an account
name, or anything that identifies the
visitor would turn your cookieless
analytics back into a tracker with the
labels scratched off — the database
does not stop you, so the stopping is
yours. Keep event data to facts *about
the action* — which button, which file,
which plan — never facts about the
person. The same care applies to page
addresses themselves: a URL carrying
someone's name or a private token in
its query string will be counted and
shown like any other page, because to
Umami it is one.
