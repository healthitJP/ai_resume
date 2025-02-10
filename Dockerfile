# ルートに置く場合の Dockerfile 修正
FROM node:18 AS builder
WORKDIR /app

# ルートから next-app の package.json をコピー
COPY next-app/package.json next-app/package-lock.json ./
RUN npm ci

# Next.js のビルド
COPY next-app ./
RUN npm run build

# 本番環境
FROM node:18
WORKDIR /app
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

CMD ["npm", "run", "start"]
