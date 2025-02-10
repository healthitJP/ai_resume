FROM node:18 AS builder
WORKDIR /app

# ビルド時の環境変数を定義
ARG GOOGLE_APPLICATION_CREDENTIALS
ARG GOOGLE_VERTEX_LOCATION
ARG GOOGLE_VERTEX_PROJECT

# 環境変数を設定
ENV GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS
ENV GOOGLE_VERTEX_LOCATION=$GOOGLE_VERTEX_LOCATION
ENV GOOGLE_VERTEX_PROJECT=$GOOGLE_VERTEX_PROJECT

RUN echo "Debug: GOOGLE_APPLICATION_CREDENTIALS = $GOOGLE_APPLICATION_CREDENTIALS"

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
