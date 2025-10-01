# Use official Nginx image
FROM nginx:alpine

# Copy all HTML/CSS/JS/images into Nginx web root
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
