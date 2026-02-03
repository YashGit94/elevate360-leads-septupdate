# # Stage 1: Build the Angular application
# FROM node:20-alpine AS build
# WORKDIR /app

# # Install dependencies first to leverage Docker cache
# COPY package*.json ./
# RUN npm install

# # Copy source and build
# COPY . .
# RUN npx ng build --configuration production

# # Stage 2: Serve the application using Nginx
# FROM nginx:stable-alpine

# # Copy built Angular files from the build stage
# # outputPath "dist/leads" from angular.json maps to /browser in Angular 17+
# COPY --from=build /app/dist/leads/browser /usr/share/nginx/html

# # Configure Nginx for Cloud Run (port 8080) and Angular routing
# RUN echo 'server { \
#     listen 8888; \
#     location / { \
#         root /usr/share/nginx/html; \
#         index index.html index.htm; \
#         try_files $uri $uri/ /index.html; \
#     } \
# }' > /etc/nginx/conf.d/default.conf

# # Match the port you confirmed is working
# EXPOSE 8888

# CMD ["nginx", "-g", "daemon off;"]


# #Working update-2
# # Stage 1: Build Angular
# FROM node:20-alpine AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npx ng build --configuration production

# # Stage 2: Serve with Nginx
# FROM nginx:stable-alpine
# COPY --from=build /app/dist/leads/browser /usr/share/nginx/html

# # Configure Nginx for Port 8888 and Angular Routing
# RUN echo 'server { \
#     listen 8888; \
#     location / { \
#         root /usr/share/nginx/html; \
#         index index.html index.htm; \
#         try_files $uri $uri/ /index.html; \
#     } \
# }' > /etc/nginx/conf.d/default.conf

# EXPOSE 8888
# CMD ["nginx", "-g", "daemon off;"]

# #test-2
# # Stage 1: Build
# FROM node:20-alpine AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npx ng build --configuration production

# # Stage 2: Serve
# FROM nginx:stable-alpine
# # Path matches the 'outputPath' in your angular.json
# COPY --from=build /app/dist/leads/browser /usr/share/nginx/html

# # Copy the specific nginx config from above
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# EXPOSE 8888
# CMD ["nginx", "-g", "daemon off;"]

# Stage 1: Build Angular
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx ng build --configuration production

# Stage 2: Run Node.js Server
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
# Install only production dependencies (Express, BigQuery, etc.)
RUN npm install --only=production
# Copy built Angular files from Stage 1
COPY --from=build /app/dist/assessment_app /app/dist/assessment_app
# Copy the backend code and keys
COPY index.js .
COPY src/keys.json ./keys.json

EXPOSE 8888
CMD ["node", "index.js"]
