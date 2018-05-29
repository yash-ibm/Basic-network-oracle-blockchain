FROM ppc64le/ubuntu:xenial

RUN apt-get update && apt-get install -y nodejs && apt-get install -y npm

RUN npm install -g verdaccio

EXPOSE "4873:4873"

CMD ["verdaccio"]
