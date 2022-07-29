from app.backend import hello


def test_hello():
    assert hello() == "hello"
