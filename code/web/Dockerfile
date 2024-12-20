FROM node:18.20.5

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider
RUN set NODE_OPTIONS=--openssl-legacy-provider
RUN npx browserslist@latest --update-db
RUN npm install @babel/core@latest @babel/preset-env@latest --save-dev

EXPOSE 3000
CMD ["npm", "start"]
