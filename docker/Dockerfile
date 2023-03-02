FROM debian:stable-slim as base-setup

# variable to use 
    ENV NB_USER rstudio
    ENV NB_UID 1000
    ENV HOME /home/rstudio
    ENV R_LIBS_USER /usr/local/lib/R/site-library

# prep user and homedir and install location
    RUN useradd -m ${NB_USER} -u ${NB_UID} \
        && usermod -a -G staff ${NB_USER} \
        && mkdir -p /usr/local/lib/R
# prep base software
    ARG DEBIAN_FRONTEND=noninteractive
    RUN apt-get update \
        && apt-get -y install \
            python3 python3-pip \
            locales \
            software-properties-common \
 		    ed less vim-tiny \
    		wget curl ca-certificates git \
            libssl-dev libunwind-dev libgdal-dev \
    		pandoc fontconfig fonts-texgyre fonts-liberation fonts-liberation2 ghostscript \
            r-cran-rlang r-base-core r-base-dev r-api-4.0 r-cran-devtools \
            r-cran-cairo libcairo2-dev \
        && apt-get purge && apt-get clean && rm -rf /var/lib/apt/lists/*
    RUN chown -R ${NB_USER} /usr/local/lib/R 
# prep base locale to keep system sane 
    RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	    && locale-gen en_US.utf8 \
	    && /usr/sbin/update-locale LANG=en_US.UTF-8
    ENV LC_ALL en_US.UTF-8
    ENV LANG en_US.UTF-8
# add MS contrib fonts
    RUN apt-add-repository contrib \
    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
    && apt-get update && apt-get install -y \
        ttf-mscorefonts-installer \
        libfontconfig1-dev \
    && apt-get purge && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
    RUN fc-cache -f -v

    WORKDIR ${HOME}

FROM base-setup as base-setup-r
    USER ${NB_USER}

# Set up R Kernel
RUN R --quiet -e "install.packages(c(\
    'repr', \
    'IRdisplay', \
    'evaluate', \
    'crayon', \
    'pbdZMQ', \
    'devtools', \
    'uuid', \
    'digest'))"
#this is for jupyter and requires jupyter
#RUN R --quiet -e "devtools::install_github('IRkernel/IRkernel')"
#RUN R --quiet -e "IRkernel::installspec()"

FROM base-setup-r as r-extras
# Additional packages for demo: 'TDA','TDAmapper','igraph'
    USER root
    RUN mkdir -p /var/lib/apt/lists/partial \
        && mkdir /data \
        && apt-get update \
        && apt-get -y install \
            libgmp-dev libmpfr-dev \
            lynx \
        && apt-get purge && apt-get clean && rm -rf /var/lib/apt/lists/*
    USER ${NB_USER}
    RUN R --quiet -e "install.packages(c(\
        'TDA',\
        'TDAmapper',\
        'igraph'))"

FROM r-extras as r-examples-deps
    #packages for examples
    RUN R --quiet -e "install.packages(c(\
    'tidyverse',\
    'hrbrthemes',\
    'kableExtra',\
    'knittr',\
    'stringr',\
    'ggmap',\
    'dplyr',\
    'tidygeocoder',\
    'tools',\
    'readxl',\
    'ggplot2',\
    'openxlsx',\
    'leaflet',\
    'htmlwidgets',\
    'DT',\
    'jpeg',\
    'maps',\
    'geosphere',\
    'grid',\
    'viridis'))"

# Make sure the contents of the repo are in ${HOME} if we need stuff
    COPY . ${HOME}
    USER root
    RUN chown -R ${NB_UID}:${NB_UID} ${HOME}
    USER ${NB_USER}

# Run install.r if it exists
    RUN if [ -f install.r ]; then R --quiet -f install.r; fi
    WORKDIR /data