#!/usr/bin/env bash

sudo apt install python3-pip python3.9-venv
virtualenv -p /usr/bin/python3.10 venv
. venv/bin/activate
python3 -m pip install pip-tools
pip-sync requirements-dev.txt
