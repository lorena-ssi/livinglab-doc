FROM node:13-alpine

# hacer la carpeta 'app' el directorio de trabajo actual
WORKDIR /app

# Installing packages needed
RUN apk add --no-cache bash git 
#RUN apt update 
#RUN apt-get install -y git bash
# Descargamos el repositorio
# Instalamos gitbook
RUN npm install -g gitbook-cli
RUN export PATH=$PATH:/usr/local/bin
COPY . .
RUN gitbook init
RUN gitbook install

EXPOSE 4000
CMD [ "gitbook", "serve"]
