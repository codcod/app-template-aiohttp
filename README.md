Template for a webapp
===

Tools used:

* [Aiohttp](https://docs.aiohttp.org/en/stable/)
* [SQLAlchemy](https://www.sqlalchemy.org)
* [Alembic](https://alembic.sqlalchemy.org/en/latest/)
* [Asyncpg](https://magicstack.github.io/asyncpg/current/)
* [PostgreSQL](https://www.postgresql.org)

Installation
---

Clone the repo.

Start dabtabase with `docker compose up -d` and then

    $ rye sync
    $ rye run create-db
    $ rye run server

See the endpoints:
* http://127.0.0.1:8000
* http://127.0.0.1:8000/users
* http://127.0.0.1:8000/users/1

Multiplatform builds
---

https://docs.orbstack.dev/docker/images#multiplatform
https://docs.docker.com/build/building/multi-platform/#building-multi-platform-images
https://docs.docker.com/build/drivers/docker-container

References
---

See [docs/manual.adoc](Manual) for documentation.

Sgerbwd means skeleton in Welsh.