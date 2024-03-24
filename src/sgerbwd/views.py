import os

from aiohttp import web
from aiohttp.web_request import Request
from aiohttp.web_response import Response

from . import queries
from .json import dumps, jsonify_rows
from .logging import get_logger

logger = get_logger(__name__)

routes = web.RouteTableDef()


@routes.get('/')
async def index(req: Request) -> Response:
    logger.debug('Index page requested')
    return web.json_response(dict(os.environ))


@routes.get(r'/users/{id:\d+}')
async def fetch_user(req: Request) -> Response:
    id = req.match_info['id']
    engine = req.app['engine']

    async with engine.begin() as conn:
        record = await queries.fetch_user(conn, int(id))

    return web.json_response({'row': jsonify_rows(record)}, dumps=dumps)


@routes.get('/users')
async def fetch_users(req: Request) -> Response:
    engine = req.app['engine']

    async with engine.begin() as conn:
        records = await queries.fetch_users(conn)

    return web.json_response({'rows': jsonify_rows(records)}, dumps=dumps)
