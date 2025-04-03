#!/bin/bash

poetry install
poetry run python fill-prehooks.py
