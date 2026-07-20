# Copyright (c) 2025 Cade Russell (Ghost Peony)
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

FROM python:3.12-slim

WORKDIR /app

# Install system dependencies required by psycopg, sentence-transformers, unstructured, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    libreoffice-writer \
    libreoffice-impress \
    libreoffice-calc \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for Docker layer caching
COPY requirements.txt .
ARG PIP_INDEX_URL=https://pypi.org/simple
ARG PIP_DEFAULT_TIMEOUT=120
RUN pip install --no-cache-dir \
    --index-url "${PIP_INDEX_URL}" \
    --default-timeout "${PIP_DEFAULT_TIMEOUT}" \
    -r requirements.txt

# Copy application code
COPY . .

EXPOSE 8780

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8780"]
