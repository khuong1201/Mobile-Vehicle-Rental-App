FROM node:18-alpine AS builder

WORKDIR /app

COPY src/package*.json ./

RUN npm install

COPY src/ .

FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app ./

EXPOSE 5000

CMD ["node", "server.js"]
