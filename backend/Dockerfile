# Bước 1: Dùng image tối ưu để build app
FROM node:18-alpine AS builder

# Tạo thư mục làm việc
WORKDIR /app

# Copy file cấu hình
COPY package*.json ./

# Cài production dependencies
RUN npm ci --only=production

# Copy toàn bộ source code
COPY . .

# Bước 2: Dùng image tối giản để chạy app
FROM node:18-alpine

# Tạo thư mục chạy app
WORKDIR /app

# Copy app từ builder stage
COPY --from=builder /app ./

# Mở port app
EXPOSE 5000

# Chạy app
CMD ["node", "server.js"]
