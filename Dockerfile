FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    dirmngr \
    curl \
    bash

SHELL ["/bin/bash", "-c"]

ENV R_VERSION=4.3.2
ENV BIOCONDUCTOR_VERSION=3.18

RUN curl -O https://cdn.rstudio.com/r/ubuntu-2204/pkgs/r-${R_VERSION}_1_amd64.deb 
RUN apt-get install -y ./r-${R_VERSION}_1_amd64.deb 
RUN echo 'export PATH="/opt/R/${R_VERSION}/bin:$PATH"' >> /etc/bash.bashrc
ENV PATH="/opt/R/${R_VERSION}/bin:$PATH"

RUN R -e "chooseCRANmirror(ind = 1)" \
    R -e "install.packages('BiocManager')" \
    R -e "BiocManager::install(version = '${BIOCONDUCTOR_VERSION}')" \
    R -e "BiocManager::install(c('Biobase'))" 

ENTRYPOINT ["tail", "-f", "/dev/null"]