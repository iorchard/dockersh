FROM ubuntu:latest

COPY user_mapping.sh /
RUN  chmod u+x /user_mapping.sh && \
     apt update && apt -y install sudo && apt-get clean

ENTRYPOINT ["/user_mapping.sh"]

# docker build -t uiduntu . 
# docker run --name uiduntu_myuser --rm -ti -e HOST_USER_ID=myuser -e HOST_USER_ID=22222 -e HOST_USER_GID=22222 uiduntu
