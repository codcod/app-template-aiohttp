.PHONY = venv lint test create-db run-server sbom \
		 clean-all \
		 start-platform stop-platform

export PYTHONPATH=src/.

OUT_DIR := build

HOST=127.0.0.1
PORT=8000

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

dev:
	uv run -- gunicorn sgerbwd.app:make_app -w 1 -k aiohttp.GunicornWebWorker --reload

run:
#	./.venv/bin/uvicorn sgerbwd.app:make_app --port $(PORT) --host 0.0.0.0 --log-level warning
	./.venv/bin/gunicorn sgerbwd.app:make_app --bind $(HOST):$(PORT) -w 4 -k aiohttp.GunicornWebWorker

start-platform:
	docker compose up -d

stop-platform:
	docker compose down

sbom:
	mkdir -p $(OUT_DIR)
	rye run python -m cyclonedx_py environment > build/cyclonedx.json
	curl -X POST http://localhost:8081/api/v1/bom \
		-H "Content-Type: multipart/form-data" \
		-H "X-API-Key: ${DT_API_KEY}" \
		-F "project=${DT_PROJECT}" \
		-F "bom=@$(OUT_DIR)/cyclonedx.json"

clean-all: stop-platform
	( bash -c "docker image rm sgerbwd/{webapp,postgres}"; ) || true
	rm -rf .container-data

.db/create:
#	rm -f $(DB) || true
	alembic upgrade ec5

.db/seed:
	alembic upgrade d26

.lint:
	uv run ruff check --fix
	uv run ruff format
#	uv run -- mypy --strict --scripts-are-modules --enable-incomplete-feature=NewGenericSyntax src

.pre-commit:
	pre-commit run --all-files

.http:
	http -b GET $(HOST):$(PORT)

.test:
	export DB_URI=instance/test.sqlite3
	uv run pytest

.wrk:
	wrk -t12 -c500 -d15s --latency http://$(HOST):$(PORT)/users/1

.hey/get:
	hey -z 5s -c 50 -t 1 http://$(HOST):$(PORT)/users

.hey:
	hey -z 5s -c 50 -t 1 \
       -m POST \
       -H "Content-Type: application/json" \
       -d '{"name":"John","surname":"Hey"}' \
       http://$(HOST):$(PORT)/users

.gha:
	act -W '.github/workflows/ci.yml'
