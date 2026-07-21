# Copyright (c) 2025 Cade Russell (Ghost Peony)
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

FROM m.daocloud.io/docker.io/library/python:3.12-slim

WORKDIR /app

# 使用阿里云 Debian 镜像加速 apt
RUN sed -i 's|deb.debian.org|mirrors.aliyun.com|g; s|security.debian.org|mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    libreoffice-writer \
    libreoffice-impress \
    libreoffice-calc \
    fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for Docker layer caching
COPY requirements.txt .
ARG PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
ARG PIP_DEFAULT_TIMEOUT=600

# Pre-install CPU-only PyTorch before installing requirements.
# sentence-transformers → torch, and the default CUDA-enabled torch
# pulls ~1GB of nvidia-* CUDA libs that are useless on non-GPU ARM64 hosts.
RUN pip install --no-cache-dir \
    --index-url https://mirrors.tuna.tsinghua.edu.cn/pytorch/whl/cpu \
    torch

RUN pip install --no-cache-dir \
    --index-url "${PIP_INDEX_URL}" \
    --default-timeout "${PIP_DEFAULT_TIMEOUT}" \
    -r requirements.txt

# Copy application code
COPY . .

EXPOSE 8780

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8780"]
