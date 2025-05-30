FROM node:18-alpine 

WORKDIR /app

COPY package*.json ./

RUN npm install

RUN npm install --save-dev nodemon

COPY . .

EXPOSE 3000

CMD ["npx", "nodemon", "server.js"]