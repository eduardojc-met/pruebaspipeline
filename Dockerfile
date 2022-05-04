
# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:16 AS builder
WORKDIR /app


RUN npm  cache clear --force
 

 
COPY ["package.json",".npmrc","/webpack/webpack.dev.js", "./"] .
COPY . .
RUN npm config set strict-ssl false
#RUN npm install
#RUN CI=true npm test
RUN npm install 
#&& npm run webapp:build


# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=builder /app /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d
EXPOSE 8085
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]












