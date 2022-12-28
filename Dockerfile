FROM python:3.10-slim as pdm

RUN pip install -U pip setuptools wheel
RUN pip install pdm


FROM pdm as builder
WORKDIR /project

COPY pyproject.toml pdm.lock /project/
RUN pdm sync -G server --prod --no-self

COPY src/ /project/src
RUN pdm sync -G server --prod --no-editable


FROM python:3.10-slim

COPY --from=builder /project/.venv /project/.venv
ENV PATH /project/.venv/bin:$PATH

WORKDIR /project
COPY src/ /project/src

ENV N_WORKERS 4

CMD gunicorn \
    --access-logfile - \
    --bind=0.0.0.0:8000 \
    --workers=${N_WORKERS} \
    -k uvicorn.workers.UvicornWorker \
    src.app.server:app                              
