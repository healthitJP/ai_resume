FROM node:18 AS builder
WORKDIR /app

COPY next-app/package*.json ./
RUN npm ci

COPY next-app/ .
RUN npm run build

FROM node:18
WORKDIR /app
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

CMD ["npm", "run", "start"]
