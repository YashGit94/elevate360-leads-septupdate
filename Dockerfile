# Stage 1: Build the Angular application
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application for production
RUN npx ng build --configuration production

# Stage 2: Serve the application using Nginx
FROM nginx:stable-alpine

# Copy the built Angular files from the build stage to Nginx's html folder
# Note: Based on your angular.json, the output path is dist/leads
COPY --from=build /app/dist/leads/browser /usr/share/nginx/html

# Expose port 8080 (standard for Cloud Run)
EXPOSE 8080

# Configure Nginx to listen on 8080 and handle Angular routing
RUN sed -i 's/listen  80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
