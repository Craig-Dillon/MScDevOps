# Use an official Node.js runtime as the base image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the remaining backend source code to the working directory
COPY . .

# Expose port 3001 to the outside world
EXPOSE 3001

# Generate SSL certificate and key
RUN apk add openssl \
    && openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
        -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" \
        -keyout /usr/src/app/privatekey.pem  -out /usr/src/app/certificate.pem

# Command to run the application
CMD ["node", "index.js"]
