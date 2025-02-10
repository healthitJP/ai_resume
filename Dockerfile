FROM node:18 AS builder
WORKDIR /app

# ビルド時の環境変数を定義
ARG CREDS
ARG LOCATION
ARG PROJECT

# 環境変数を設定（ビルド時とランタイム両方で使用）
ENV GOOGLE_APPLICATION_CREDENTIALS=$CREDS \
    GOOGLE_VERTEX_LOCATION=$LOCATION \
    GOOGLE_VERTEX_PROJECT=$PROJECT

COPY next-app/package*.json ./
RUN npm ci

COPY next-app/ .
RUN echo "Building with GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS" && \
    npm run build

FROM node:18
WORKDIR /app
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

CMD ["npm", "run", "start"]
