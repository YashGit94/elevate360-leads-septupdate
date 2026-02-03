# Stage 1: Build the Angular application
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npx ng build --configuration production

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy built files - based on your angular.json
COPY --from=build /app/dist/leads/browser /usr/share/nginx/html

# Custom Nginx config to listen on 8080 and support Angular routing
RUN echo 'server { \
    listen 8080; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html index.htm; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
