# People and Access

**Outcome: you can give another person
exactly the access they should have —
no more — and publish counts publicly
when you mean to.** The lab exercised
every mechanism in this chapter against
the real API, including the refusals.

## Users and roles

Umami's users are the people who *read*
the counts, never the people counted.
An administrator can create more of
them, and version 3 gives each one of
three roles:

- **admin** — everything, including
  other users.
- **user** — their own websites, and
  what teams give them.
- **view-only** — can look, cannot
  change. (Older write-ups call this
  *read-only*; the API in version 3
  rejects that name and tells you the
  right one — the lab's first attempt
  is in the transcripts as evidence.)

The lab created a second user,
`committee`, with the view-only role.
Signed in as committee, the account's
own website list was empty — a new user
owns nothing and sees nothing until
access is *given* — and when committee
tried to create a website anyway, the
answer was a flat `401 Unauthorized`.
View-only is a role, not a suggestion.

## Teams: how access is given

Sharing runs through **teams**. The
mechanics have one wrinkle the lab hit
squarely, so learn it here instead: in
version 3, **a website belongs to a
team from its creation** — you pass the
team's id when you create the website —
and there is no endpoint that bolts an
existing personal website onto a team
afterwards. (The lab's attempt to POST
one onto a team returned silence and,
checked afterwards, a team still
holding zero websites. Creating the
site *into* the team worked the first
time.)

The lab's committee flow, end to end:
create a team ("Example Committee");
create a website with that `teamId`;
add committee to the team with the
**team-view-only** role. After that,
committee could read the team website's
statistics through the API — the very
call that had been refused for the
admin's personal site before — while
still being refused every write. Team
roles come in matching strengths
(team-owner, team-admin, team-member,
team-view-only), so a working webmaster
and a curious committee can live in the
same team at different depths.

One nuance, recorded because the lab
found it: the "my websites" list
(`GET /api/me/websites`, even with
`?includeTeams`) folds in only teams
you *own or manage*. A plain member's
access is real — the numbers answer —
but the site is reached through the
team, the way the dashboard's team
switcher presents it, not through the
personal list.

## Share links: access with no account

Sometimes the right audience has no
account at all. A **share link** gives
one website a public dashboard at an
unguessable address — the lab's was
`/share/eUUNa1ow8tNiM9z7` — which loads
without any sign-in, as the lab
verified with a bare `curl`. Treat that
address as published, because it is:
anyone who holds it can read the counts
at any time, and links travel. It is a
good tool for a club that wants its
counts open on principle, and a bad one
to create absent-mindedly. Deleting the
share kills the address outright.

Users can also protect their own
accounts further — the schema and
settings carry two-factor authentication
for sign-ins — which this guide notes
from the documentation rather than the
lab; the password change of chapter 5
is the step that is not optional.
