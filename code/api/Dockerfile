FROM node:18.20.5

WORKDIR /usr/src/app

# Instalar las herramientas de compilación necesarias
RUN apt-get update && apt-get install -y python3 make g++


COPY package*.json ./
RUN npm install
RUN npm i sequelize-cli@6.6.2
COPY . .
# Copiar el archivo de respaldo al contenedor
COPY ./backup/backup.sql /docker-entrypoint-initdb.d/backup.sql

RUN npm install yargs@latest --save-dev
RUN npx browserslist@latest --update-db
RUN npm rebuild bcrypt --build-from-source



EXPOSE 8000
