# Multi step building process for production
# Block A
# Building the container from image alpine and install dependencies
FROM node:16-alpine as builder
WORKDIR '/app' 
COPY package.json .
RUN npm install 
COPY . .
RUN npm run build
# A Build folder will be the result of the build .../app/build

# Block B
# Starting the production phase and copy the build folder into the html folder
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Restarting course on 28.07.2022
# Notes: 
# docker build -f Dockerfile.dev .
# 
# docker run -p 3000:3000 # port mapping
# -v /app/node_modules    # dont touch the node_modules folder in the container 
# -v $(pwd):/app          # map the pwd into the app directory of teh container
# [container ID]          # container ID that is to be started
# 
# docker exec -it [Container ID] [command for the container] # submitting a command to a running container
#
# docker attach [container ID] # with docker attach it is possible to send commands to the running container
#                              # but it is not working when one has set up both containers with docker-compose.yml
#                              # because in the test container multiple processes with multipe stdin and stdout are running
#                              # only the primary process in the container can be reached with docker attach

# 29.07.
# after writing the two step building process oe can start the production server with:
# docker run -p3000:80 [Image ID]
# Note: 80 is the default port of the nginx-server running within the container