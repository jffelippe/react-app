# Use an official Node.js image as the base image
FROM node:18.12.1-slim AS base

# Set the working directory within the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install app dependencies
RUN npm install

# Stage 2: Build the React app
FROM base AS build

# Copy the entire app to the container
COPY . .

# Build the React app
RUN npm run build

# Stage 3: Create a production-ready image
FROM nginx:alpine AS production

# Copy the build files from the build stage to the Nginx web root directory
COPY --from=build /app/.next /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
