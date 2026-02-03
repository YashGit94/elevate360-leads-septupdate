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


# Stage 1: Build Angular
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npx ng build --configuration production

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine
COPY --from=build /app/dist/leads/browser /usr/share/nginx/html

# COPY YOUR CUSTOM NGINX CONFIG
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8888
CMD ["nginx", "-g", "daemon off;"]
