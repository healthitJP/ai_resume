FROM node:18 AS builder
WORKDIR /app

# ビルド時の環境変数を定義
ARG KEY_FILE
ENV GOOGLE_APPLICATION_CREDENTIALS=${KEY_FILE}
ENV GOOGLE_VERTEX_LOCATION=asia-northeast1
ENV GOOGLE_VERTEX_PROJECT=healthit-ai-resume

# キーファイルをコピー
COPY /workspace/key.json ${GOOGLE_APPLICATION_CREDENTIALS}

# 依存関係のインストール
COPY next-app/package*.json ./
RUN npm ci

# アプリケーションのビルド
COPY next-app/ .
RUN cat .env && \
    echo "Debug: GOOGLE_APPLICATION_CREDENTIALS = $GOOGLE_APPLICATION_CREDENTIALS" && \
    ls -la ${GOOGLE_APPLICATION_CREDENTIALS} && \
    npm run build

FROM node:18
WORKDIR /app
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

CMD ["npm", "run", "start"]
