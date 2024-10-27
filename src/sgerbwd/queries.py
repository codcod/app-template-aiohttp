"""
DB queries.
"""

from sqlalchemy.ext.asyncio import AsyncConnection
from sqlalchemy.sql import insert, select

from .db import metadata


async def fetch_users(conn: AsyncConnection):
    users = metadata.tables['users']
    records = await conn.execute(select(users))
    return records


async def fetch_user(conn: AsyncConnection, id: int):
    users = metadata.tables['users']

    stmt = select(users).where(users.c.user_id == id)
    records = await conn.execute(stmt)
    return records


async def save_user(conn: AsyncConnection, *, name: str, surname: str):
    users = metadata.tables['users']

    stmt = insert(users).values(name=name, surname=surname)
    records = await conn.execute(stmt)
    return records
