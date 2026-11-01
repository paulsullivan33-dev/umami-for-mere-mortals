# Limits

**Outcome: you know where Umami's map
ends before you walk off it.** These
are properties of the tool, stated the
way chapter 1 would want them.

**It counts loads, not people.** A
visitor is a hashed session-identity.
The same person on a phone and a laptop
is two visitors; a shared computer is
one. Every number derived from visitors
carries that approximation inside it,
and no setting removes it — it *is* the
privacy design, priced in.

**No JavaScript, no count.** The main
tracker is a script; a visitor with
scripting off, or a blocker that stops
it, is invisible to Umami. (Umami also
offers tracking *pixels* — tiny images
for places scripts cannot go, such as
email — which count an opening and
nothing more.) Your numbers are
therefore a faithful count of *most*
visits, quietly missing the most
privacy-defended ones. There is a
certain honesty in who escapes.

**Nothing before today.** Umami counts
from the moment the tag goes in. It
cannot import a history from another
analytics platform, and it does not read
server logs; yesterday is GoAccess's
territory (chapter 12), not Umami's.

**Countries are estimates, and sometimes
blank.** The GeoIP table maps address
ranges to places; VPNs, mobile networks
and plain table error all bend it, and
loopback or local addresses get no
country at all — the lab's blank cell
was correct behaviour, not a fault.

**It is not a marketing machine.** No
advertising audiences, no cross-site
identity, no remarketing, no
identity-resolved funnels. Version 3
carries respectable reports — funnels,
retention, journeys among them — built
from the same anonymous events, and
they stop where the ethics line says:
at the aggregate.

**Optional extras are extra.** The
schema and settings include a session
recorder and heatmaps — features that
watch behaviour far more closely than
counting does. They are off unless an
owner turns them on (the lab's websites
reported `recorderEnabled: false`),
they are *not* what this guide teaches,
and enabling them changes what you owe
your visitors an explanation for.

**Your data is your chore.** Umami
keeps events indefinitely. Deleting old
data is an owner's deliberate act in
the database, not a retention dial, and
the database grows with your traffic —
small for a mortal site (the lab's
whole world was a 52 KB dump), real for
a busy one.

**It is a web application, with a web
application's weight.** Node.js,
PostgreSQL, a multi-minute first build,
and security updates that are yours to
apply. The Docker route in the project
documentation trades some of that care
away; the weight does not vanish, it
moves. And the counting, while robust,
is single-purpose: server health, logs
and uptime belong to other tools in
this series, not to this one.
