FROM python:3.10-slim as pdm

RUN pip install -U pip setuptools wheel
RUN pip install pdm
RUN pdm config python.use_venv False


FROM pdm as builder
WORKDIR /project

COPY pyproject.toml pdm.lock /project/
RUN pdm sync -G server --prod --no-self

COPY src/ /project/src
RUN pdm sync -G server --prod --no-editable


FROM python:3.10-slim

ENV PYTHONPATH=/project/lib

COPY --from=builder /project/__pypackages__/3.10/lib /project/lib
COPY --from=builder /project/__pypackages__/3.10/bin /project/bin

WORKDIR /project
COPY src/ /project/src


ENV N_WORKERS 4

CMD bin/gunicorn \
    --access-logfile - \
    --bind=0.0.0.0:8000 \
    --workers=${N_WORKERS} \
    -k uvicorn.workers.UvicornWorker \
    src.app.server:app                              
