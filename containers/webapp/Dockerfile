# syntax=docker/dockerfile:1

# for distroless see: https://github.com/GoogleContainerTools/distroless/blob/main/examples/python3-requirements/Dockerfile

# Build the virtualenv
FROM python:3.12-alpine AS build-venv
RUN apk --update --no-cache add gcc build-base
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
COPY requirements.lock .
RUN sed '/-e/d' requirements.lock > requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the virtualenv into a new image
FROM python:3.12-alpine
RUN apk add --no-cache tzdata
ENV TZ=Europe/Warsaw
COPY --from=build-venv /opt/venv /opt/venv
WORKDIR /opt/sgerbwd
COPY . .
EXPOSE 8080
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONPATH="src"
ENTRYPOINT ["gunicorn"]
CMD ["sgerbwd.app:make_app", "-b 0.0.0.0:8080", "-w 1", "-k aiohttp.GunicornWebWorker"]
