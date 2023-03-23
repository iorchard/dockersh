FROM ubuntu:latest

ARG TF_VER=2.11.0
COPY scripts /scripts
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/opt/conda/lib:/opt/conda/lib/python3.10/site-packages/tensorrt
ENV TF_ENABLE_ONEDNN_OPTS 0
RUN  apt-get update && \
     apt-get -y --no-install-recommends install \
       curl \
       git \
       less \
       locales \
       openssh-client \
       python3.7 python3.8 \
       sudo \
       unzip \
       vim \
       wget \
       zip && \ 
     apt-get autoremove -y && \
     apt-get clean && \
     rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
     pip install --upgrade --no-cache-dir pip && \
     pip install --upgrade --no-cache-dir \
       jupyterlab \
       tensorflow==${TF_VER} \
       tensorrt && \
     pip cache purge
RUN  locale-gen ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

ENTRYPOINT ["/scripts/user_mapping.sh"]
