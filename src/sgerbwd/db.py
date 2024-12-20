import multiprocessing
import typing as tp

from sqlalchemy import MetaData
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import AsyncEngine, create_async_engine

from . import settings

POOL_SIZE = 1000 // multiprocessing.cpu_count()

metadata = MetaData()


def use_inspector(conn: Connection) -> None:
    """Workaround as SQLAlchemy does not yet offer asyncio version of Inspector.

    https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html#using-the-inspector-to-inspect-schema-objects
    """
    metadata.reflect(bind=conn)


def init_db(config: dict[str, tp.Any]) -> AsyncEngine:
    """
    Initialize database based on configuration.
    Passes additional arguments to the underlying `sqlite3` driver.
    """
    config_db = config['database']
    engine = create_async_engine(
        config_db['DB_URL'],
        # os.getenv('DB_URI'),
        echo=config_db['DB_ECHO'],
        pool_size=POOL_SIZE,
    )
    return engine


async def get_engine() -> AsyncEngine:
    """
    Get database engine.

    It is advisable to call `AsyncEngine.dispose()` when using the `AsyncEngine`
    object in a scope that will go out of context and be garbage collected.

    See also `use_inspector` method.
    """
    async with engine.connect() as conn:
        await conn.run_sync(use_inspector)
    return engine


engine = init_db(settings.load_config('config/config.toml'))
