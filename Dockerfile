FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM node:18-alpine as development
WORKDIR /app
COPY --from=build /app ./
EXPOSE 3000
ENTRYPOINT [ "npm", "run", "dev" ]

FROM node:18-alpine as production
WORKDIR /app
COPY --from=build /app ./
EXPOSE 3000
ENTRYPOINT ["node", "src/index.js"]