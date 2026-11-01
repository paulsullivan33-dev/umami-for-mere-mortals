# Installing Umami

**Outcome: Umami's source on your disk,
its packages installed, a database
waiting for it, and one line of
configuration connecting the two —
everything except pressing "build,"
which is chapter 4.** Installing is
really gathering four things: Node.js,
the Umami source, its package manager,
and a PostgreSQL database.

## What Umami needs

The project's own requirements are
modest: **Node.js 18.18 or newer** and
**PostgreSQL 12.14 or newer**. The lab
used what its machine already had —
Node **24.22.1** and PostgreSQL
**16.15** — and Umami 3.4.1's build
scripts additionally call for **pnpm**,
the package manager the project pins in
its own `package.json` (`engines` asks
for pnpm 12.3.4). If `pnpm` is missing,
the lab installed exactly that version
into a scratch folder with npm itself:

```bash
npm install --prefix ./pnpm-tool pnpm@12.3.4
./pnpm-tool/node_modules/.bin/pnpm --version
```

```text
12.3.4
```

(The lab's machine had no `corepack`
command, which is the other common way
to fetch a pinned pnpm; the npm route
above worked and kept everything in one
folder.)

## The database

Umami stores everything in PostgreSQL
and nothing anywhere else, so the
database comes first. On a real machine
you would use your existing PostgreSQL
server if you have one. The lab had
none running, so it made a private,
throwaway cluster — its own data
folder, its own port (55432, chosen so
it can never collide with a real
PostgreSQL on 5432) — with the standard
tools:

```bash
/usr/lib/postgresql/16/bin/initdb \
  -D ~/umami-labwork/pgdata \
  -U umami_admin --auth=trust
```

then added three lines to the new
cluster's `postgresql.conf` —

```text
port = 55432
listen_addresses = '127.0.0.1'
unix_socket_directories = '/home/.../umami-labwork/pgsocket'
```

— started it with `pg_ctl`, and created
the database itself:

```bash
createdb -h 127.0.0.1 -p 55432 -U umami_admin umami
```

Loopback-only listening is a deliberate
choice: this database has exactly one
customer, the Umami on the same machine.

Two lab lessons are worth keeping even
on a tidy machine. First, `initdb`
refuses to run as the root user, and the
`postgres` system user who runs it for
you must be able to *reach* the data
folder — the lab's first attempt died on
directory permissions and was fixed with
execute-only access (`setfacl -m
u:postgres:--x`) on the path, not by
loosening the whole home directory.
Second, the lab switched its throwaway
cluster from trust-me authentication to
a real password before Umami ever
connected — `alter user umami_admin with
password '...'` plus `scram-sha-256` in
`pg_hba.conf` and a reload — and proved
both halves: connecting *with* the
password worked, and connecting without
it failed. A database of everybody's
page views deserves a password even on
a quiet machine. One trap inside that
test: `psql` without its `-w` flag will
sit forever at a password prompt when a
script expected it to fail quickly.

If you would rather go deeper on
PostgreSQL itself — clusters, roles,
backups — the PostgreSQL guide in this
series is the companion; this chapter
only needs the cluster above.

## The source

Umami is distributed as source you build
(chapter 4), from the project's GitHub
releases:

```bash
curl -sL -o umami-v3.4.1.tar.gz \
  https://github.com/umami-software/umami/archive/refs/tags/v3.4.1.tar.gz
tar xzf umami-v3.4.1.tar.gz
cd umami-3.4.1
```

Version **3.4.1** is what this guide's
lab verified; the folder holds the whole
application — the dashboard, the tracker,
the API, the database schema under
`prisma/`, and the build scripts that
chapter 4 runs.

## The packages

```bash
pnpm install --frozen-lockfile
```

`--frozen-lockfile` means "install
exactly the versions the release pins in
its `pnpm-lock.yaml`, no improvising."
The lab's run resolved 1023 packages;
it is a download of a few hundred
megabytes and it is the slow, patient
step of the install. (The lab also
pointed pnpm's store at a scratch folder
with `--store-dir`, purely to keep its
shared machine tidy; on your own machine
the default store is fine.) Nothing is
installed into the system: everything
lands in `node_modules/` inside the
Umami folder, and deleting the folder
removes Umami completely.

## The one line of configuration

Umami takes its settings from a file
named `.env` in the source folder, and
for a basic install it needs exactly one
setting — where the database is:

```bash
cat > .env <<'EOF'
DATABASE_URL=postgresql://umami_admin:YOUR-PASSWORD@127.0.0.1:55432/umami
EOF
```

A **connection string** like this is
read left to right: the kind of database
(`postgresql`), the user and password,
the address and port, and the database
name. Umami's own start-up checks refuse
to proceed without it — `check-env` is
the first step of the build — and the
same string, handed to `psql`, is how
chapter 7 will later inspect the counted
data directly. Treat `.env` as a
secret-bearing file: it is not part of
the source, it is never committed, and
it is the only place the database
password lives.

That is everything staged: program,
packages, database, and the line joining
them. Chapter 4 builds it and brings it
to life.
