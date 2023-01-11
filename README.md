# Python PDM Template
A Project Template of Python with PDM

# Install

Please first install PDM >= 2.0 with pip/pipx.

```bash
pdm install --prod
```

# Develop

```bash
pdm install
```

This installs the following tools in addition to `pdm install --prod`.

- ruff
- pyright
- black
- pytest-cov

The settings of those linter and formatters are written in `pyproject.toml`

# VSCode Settings

```bash
cp vscode_templates .vscode
```

Then install/activate all extensions listed in `.vscode/extensions.json`

# Creating Console Script

```toml
[project.scripts]
app = "app.cli:main"
```

# Define Project Command

```toml
[tool.pdm.scripts]
black = "black ."
pyright = "pyright ."
ruff_lint = "ruff ."
ruff_fix = "ruff --fix-only ."
test = "pytest tests --cov=app --cov-report=term --cov-report=xml"
format = { composite = ["black", "ruff_fix"] }
lint = { composite = ["ruff_lint", "pyright"] }
check = { composite = ["format", "lint", "test"] }
```

# Build Docker Image

Please check the `Dockerfile` for how to use multi-stage build with PDM.