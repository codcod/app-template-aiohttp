"""
DB queries.
"""

from sqlalchemy.ext.asyncio import AsyncConnection
from sqlalchemy.sql import select

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
