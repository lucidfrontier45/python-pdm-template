import fastapi

from .backend import hello

app = fastapi.FastAPI()


@app.get("/")
def index():
    return hello()
