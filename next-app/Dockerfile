# 1. Build Stage
FROM node:18 AS builder

# 作業ディレクトリを指定
WORKDIR /app

# Next.js アプリのソースコードをコピー
COPY next-app/package.json next-app/package-lock.json ./
RUN npm ci

# Next.js のビルド
COPY next-app ./
RUN npm run build

# 2. Production Stage
FROM node:18

WORKDIR /app

# 本番環境に必要なファイルをコピー
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# サーバーを起動
CMD ["npm", "run", "start"]
