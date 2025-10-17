#!/usr/bin/env zsh

which uv || curl -LsSf https://astral.sh/uv/install.sh | sh

if [[ ! -d .venv ]]; then 
    uv venv
fi
uv pip install -r requirements.txt
uv run setup.py
