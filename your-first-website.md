# Your First Website

**Outcome: you have signed in, replaced
the password everybody knows, registered
a website, and hold the one line of HTML
that connects them.** Everything in this
chapter was done twice in the lab: once
the way a person does it, in the
dashboard, and once through the API with
`curl`, so the transcripts can prove it.

## Signing in

A fresh Umami has exactly one user,
created by the migrations:

- **Username:** `admin`
- **Password:** `umami`

These are printed in the project's
documentation, which means they are
printed for everyone. Signing in with
them is step one; replacing the password
is step two, in the same sitting, before
any real site is connected. In the
dashboard it lives under your profile's
settings. Through the API — the way the
lab proved it — the whole story is three
calls: sign in, change, and watch the
old password die:

```bash
curl -X POST http://127.0.0.1:18085/api/me/password \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"currentPassword":"umami",
       "newPassword":"a-better-lab-password-2026"}'
```

Afterwards the old password earns a
plain refusal —

```text
{"error":{"message":"Unauthorized",
"code":"incorrect-username-password","status":401}}
```

— and the new one signs in. The lab's
replacement password above is a *lab*
password, printed because the lab is
thrown away; yours should be a real one,
kept wherever you keep passwords. The
token a sign-in returns deserves the
same care: it is a key to everything the
dashboard can see, and chapter 7 uses it
from the command line.

## Registering a website

A **website** in Umami is one counted
property: a name for humans and the
domain it lives on. In the dashboard:
*Settings → Websites → Add website*. In
the lab, the API created it:

```bash
curl -X POST http://127.0.0.1:18085/api/websites \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"Example Site","domain":"example.com"}'
```

```text
{"id":"b7ccefd2-6484-456f-8642-9371019c17c9",
 "name":"Example Site","domain":"example.com", ...}
```

That `id` — a UUID — is the website's
true name as far as the machinery cares.
Your list of websites was empty a moment
before (`GET /api/me/websites` returned
`"data":[],"count":0`); now the site
exists, and its statistics, asked for
politely, are a row of honest zeros.
Chapter 6 fixes that.

## The tracking tag

For the website you just made, the
dashboard's *Tracking code* panel offers
one line to paste into your pages,
before the closing `</head>`:

```html
<script defer src="http://127.0.0.1:18085/script.js"
  data-website-id="b7ccefd2-6484-456f-8642-9371019c17c9"></script>
```

Read it once, carefully, because it is
the whole contract: load `script.js`
*from your Umami* (the address will be
your real Umami address on a real
install, not a loopback one), `defer` it
so pages never wait on it, and tell it
which website it is reporting for. No
account key, no cookie consent plumbing,
no list of "partners." One practical
warning: the `data-website-id` is not a
secret — anyone viewing your page source
can see it, and anyone who knows it can
send your Umami page views for that
site. That is the accepted trade of
every script-tag analytics tool; the
defence is that the worst a stranger can
do is inflate your counts, which brings
us to meeting a visit properly.
