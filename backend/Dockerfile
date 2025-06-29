FROM node:18-alpine 

WORKDIR /app

COPY package*.json ./
RUN npm install --legacy-peer-deps

RUN npm install

# RUN npm install --save-dev nodemon

COPY . .

EXPOSE 5000

# CMD ["npx", "nodemon", "server.js"]
CMD ["node", "server.js"]