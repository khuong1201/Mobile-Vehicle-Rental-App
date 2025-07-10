# -----------------------
# 🔨 BƯỚC 1: Build app
# -----------------------
FROM node:18-alpine AS builder

# Tạo thư mục làm việc
WORKDIR /app

# Copy file cấu hình trước để tận dụng cache
COPY package*.json ./

# Cài dependencies (cả dev và prod để tránh lỗi thiếu module khi build)
RUN npm install

# Copy toàn bộ source vào container
COPY . .

# -----------------------------
# 🚀 BƯỚC 2: Image tối giản để chạy
# -----------------------------
FROM node:18-alpine

# Tạo thư mục chạy app
WORKDIR /app

# Copy code đã cài sẵn module từ builder
COPY --from=builder /app ./

# Chỉ định cổng chạy (tuỳ thuộc app bạn chạy port nào, 5000?)
EXPOSE 5000

# Lệnh khởi chạy server
CMD ["node", "server.js"]
