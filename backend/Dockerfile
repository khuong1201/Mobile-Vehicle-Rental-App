FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .


EXPOSE 5000

# dùng cho dev
# CMD ["npm", "run", "dev"] 

# production dùng node server.js
CMD ["npm", "start"]  