## Dockerfile for ele-net-intelligence-api (build from git).
##
## Build via:
#
# `docker build -t elenetintel:latest .`
#
## Run via:
#
# `docker run -v <path to app.json>:/home/elenetintel/ele-net-intelligence-api/app.json elenetintel:latest`
#
## Make sure, to mount your configured 'app.json' into the container at
## '/home/elenetintel/ele-net-intelligence-api/app.json', e.g.
## '-v /path/to/app.json:/home/elenetintel/ele-net-intelligence-api/app.json'
## 
## Note: if you actually want to monitor a client, you'll need to make sure it can be reached from this container.
##       The best way in my opinion is to start this container with all client '-p' port settings and then 
#        share its network with the client. This way you can redeploy the client at will and just leave 'elenetintel' running. E.g. with
##       the python client 'pyeleapp':
##
#
# `docker run -d --name elenetintel \
# -v /home/user/app.json:/home/elenetintel/ele-net-intelligence-api/app.json \
# -p 0.0.0.0:30303:30303 \
# -p 0.0.0.0:30303:30303/udp \
# elenetintel:latest`
#
# `docker run -d --name pyeleapp \
# --net=container:elenetintel \
# -v /path/to/data:/data \
# pyeleapp:latest`
#
## If you now want to deploy a new client version, just redo the second step.


FROM debian

RUN apt-get update &&\
    apt-get install -y curl git-core &&\
    curl -sL https://deb.nodesource.com/setup | bash - &&\
    apt-get update &&\
    apt-get install -y nodejs

RUN apt-get update &&\
    apt-get install -y build-essential

RUN adduser elenetintel

RUN cd /home/elenetintel &&\
    git clone https://github.com/elementrem/ele-net-intelligence-api &&\
    cd ele-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2

RUN echo '#!/bin/bash\nset -e\n\ncd /home/elenetintel/ele-net-intelligence-api\n/usr/bin/pm2 start ./app.json\ntail -f \
    /home/elenetintel/.pm2/logs/node-app-out-0.log' > /home/elenetintel/startscript.sh

RUN chmod +x /home/elenetintel/startscript.sh &&\
    chown -R elenetintel. /home/elenetintel

USER elenetintel
ENTRYPOINT ["/home/elenetintel/startscript.sh"]
