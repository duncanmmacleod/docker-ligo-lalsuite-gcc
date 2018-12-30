FROM gcc:8

LABEL name="LALSuite Development - GCC 8" \
      maintainer="Adam Mercer <adam.mercer@ligo.org>" \
      date="20181230" \
      support="Best Effort"

# ensure non-interactive debian installation
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# support https repositories
RUN apt-get update && \
    apt-get --assume-yes install \
      apt-transport-https \
      apt-utils \
      bash-completion \
      curl \
      lsb-release \
      wget

# add git-lfs repo
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# Add other repos
RUN wget http://software.ligo.org/lscsoft/debian/pool/contrib/l/lscsoft-archive-keyring/lscsoft-archive-keyring_2016.06.20-2_all.deb && \
    dpkg -i lscsoft-archive-keyring_2016.06.20-2_all.deb && \
    rm -f lscsoft-archive-keyring_2016.06.20-2_all.deb

RUN echo "deb http://software.ligo.org/gridtools/debian stretch main" > /etc/apt/sources.list.d/gridtools.list && \
    echo "deb http://software.ligo.org/lscsoft/debian stretch contrib" > /etc/apt/sources.list.d/lscsoft.list

# install dependencies
# NOTE: can't use lscsoft-lalsuite-dev as this brings in a dependency on
# liboctave-dev which is not compatible with the gfortran supplied by
# the gcc docker image
RUN apt-get update && apt-get --assume-yes install autoconf \
      automake \
      bc \
      build-essential \
      ccache \
      devscripts \
      doxygen \
      fakeroot \
      git \
      git-lfs \
      help2man \
      ldas-tools-framecpp-c-dev \
      libcfitsio-dev \
      libchealpix-dev \
      libfftw3-dev \
      libframe-dev \
      libglib2.0-dev \
      libgsl-dev \
      libhdf5-dev \
      libmetaio-dev \
      libopenmpi-dev \
      libtool \
      libxml2-dev \
      pkg-config \
      python-all-dev \
      python-dev \
      python-glue \
      python-gwpy \
      python-h5py \
      python-healpy \
      python-ligo-gracedb \
      python-ligo-segments \
      python-numpy \
      python-reproject \
      python-scipy \
      python-seaborn \
      python-shapely \
      python-six \
      python3-all-dev \
      python3-dev \
      python3-glue \
      python3-gwpy \
      python3-h5py \
      python3-healpy \
      python3-ligo-segments \
      python3-numpy \
      python3-scipy \
      python3-shapely \
      python3-six \
      swig \
      swig3.0 \
      texlive

# git-lfs post-install
RUN git lfs install

# clear package cache
RUN rm -rf /var/lib/apt/lists/*
