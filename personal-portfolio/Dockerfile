FROM node:18.13.0

WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN npm install


#Copies all current files in current directory to the WORKDIR
COPY . .  

CMD ["npm", "run", "start"]