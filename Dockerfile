# --- Stage 1: Build the React application ---
FROM node:20-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package management files first to leverage Docker cache layers
COPY package*.json ./

# Install project dependencies(RUN npm ci)
RUN npm install      

# Copy the rest of the application source code
COPY . .

# Build the production-ready static assets
RUN npm run build

# --- Stage 2: Serve the application with Nginx ---
FROM nginx:stable-alpine

# Copy the compiled static assets from the build stage to the Nginx HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy a custom Nginx configuration to handle React Router paths (Optional but highly recommended)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
