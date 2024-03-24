# syntax=docker/dockerfile:1
# build times and image sizes:
# - 3-alpine:   48s, 302MB
# - 3.11-slim:  57s, 397MB

#
# COMPILE
#
FROM python:3.12-alpine AS compile-image
RUN apk --update --no-cache add gcc build-base

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
COPY requirements.lock .
RUN sed '/-e/d' requirements.lock > requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

#
# BUILD
#
FROM python:3.12-alpine AS build-image
COPY --from=compile-image /opt/venv /opt/venv

RUN apk add --no-cache tzdata
ENV TZ=Europe/Warsaw

WORKDIR /opt/sgerbwd
COPY . .

EXPOSE 8080

ENV PATH="/opt/venv/bin:$PATH"
CMD PYTHONPATH=src gunicorn sgerbwd.app:make_app -b 0.0.0.0:8080 -w 1 -k aiohttp.GunicornWebWorker
