FROM node:14
# Create app directory
WORKDIR /app

COPY package*.json ./
RUN yarn install 
# NODEJS in paket yoneticisi / biraz daha hizli cunku cacheleme yapmaktadir
# copy all files into the image
COPY . .

EXPOSE 3000

CMD ["yarn", "run", "start"]