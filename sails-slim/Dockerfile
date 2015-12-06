# Start from argon (latest long term supported version of node)
# - argon : Full node dev env (640 MB) : python inside
# - argon-slim : Light node env (200 MB) : no python, can be an issue for npm installs / builds
FROM node:argon-slim

MAINTAINER Steve Sfartz <steve.sfartz@gmail.com>

# install sails
RUN npm -g install sails

# create "node" user
RUN useradd -c 'Node.js user' -m -d /home/node -s /bin/bash node

# Switch to "node" user and build
USER node
ENV HOME /home/node

# Launch sails
EXPOSE 1337
CMD ["/bin/bash"]
