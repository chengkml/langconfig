# Copyright (c) 2025 Cade Russell (Ghost Peony)
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# ---- Build stage ----
FROM m.daocloud.io/docker.io/library/node:22-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
ARG NPM_REGISTRY=https://registry.npmjs.org
ARG VITE_API_BASE_URL=""
RUN npm config set registry "${NPM_REGISTRY}" && npm ci

COPY . .
RUN VITE_API_BASE_URL="${VITE_API_BASE_URL}" npm run build

# ---- Serve stage ----
FROM m.daocloud.io/docker.io/library/nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
