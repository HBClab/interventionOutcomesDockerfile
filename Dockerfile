FROM ubuntu:18.04

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y install \
    curl \
    r-base \
    libssl-dev \
    libcurl4-gnutls-dev \
    ssh \
    git \
    tar \
    gzip \
    ca-certificates \
    && R -e "install.packages(c('rsconnect', 'shiny', 'DT', 'dplyr', 'markdown', 'ggplot2'))"

RUN chmod 777 /opt

ENV PATH="/opt/miniconda-latest/bin:$PATH"

RUN useradd --create-home --shell /bin/bash coder
USER coder

RUN export PATH="/opt/miniconda-latest/bin:$PATH" \
    && conda_installer="/tmp/miniconda.sh" \
    && curl -fsSL --retry 5 -o "$conda_installer" https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash "$conda_installer" -b -p /opt/miniconda-latest \
    && mkdir /home/coder/projects

WORKDIR /home/coder/projects

COPY --chown=coder . /home/coder/projects/

RUN conda env create -f environment.yml
RUN bash -c 'conda init && . /home/coder/.bashrc'

ENTRYPOINT [ "/bin/bash", "-c" ]