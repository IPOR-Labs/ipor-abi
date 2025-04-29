#!/bin/bash

poetry install
poetry run python fill-price-feeds.py
