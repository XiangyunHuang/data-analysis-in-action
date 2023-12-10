ARG QUARTO_VERSION=1.2.280
ARG REGISTRY=ghcr.io/xiangyunhuang

FROM ${REGISTRY}/rockylinux-rstudio:${QUARTO_VERSION} AS rockylinux-rstudio-pro

ARG CMDSTAN_VERSION=2.32.2
ARG GITHUB_PAT=abc123
ARG JAGS_LINK=https://zenlayer.dl.sourceforge.net/project/mcmc-jags/JAGS
ARG JAGS_MAJOR=4
ARG JAGS_VERSION=4.3.2

# Setup Extra R Packages
COPY DESCRIPTION DESCRIPTION
COPY install_r_packages.R install_r_packages.R
RUN export GITHUB_PAT=${GITHUB_PAT} \
  && export DOWNLOAD_STATIC_LIBV8=1 \
  && Rscript install_r_packages.R \
  && rm -f install_r_packages.R DESCRIPTION \
  && dnf install -y lapack-devel blas-devel \
  && curl -fLo JAGS-${JAGS_VERSION}.tar.gz ${JAGS_LINK}/${JAGS_MAJOR}.x/Source/JAGS-${JAGS_VERSION}.tar.gz \
  && tar -xzf JAGS-${JAGS_VERSION}.tar.gz \
  && cd JAGS-${JAGS_VERSION} && ./configure && make && make install && cd .. \
  && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/ \
  && Rscript -e "install.packages('rjags', configure.args='--enable-rpath')" \
  && rm -f JAGS-${JAGS_VERSION}.tar.gz && rm -rf JAGS-${JAGS_VERSION} \
  && dnf clean all

# Setup Python and CmdStan
COPY requirements.txt requirements.txt
RUN mkdir -p /opt/.virtualenvs/r-tensorflow \
  && chown -R $(whoami):staff /opt/.virtualenvs/r-tensorflow \
  && export RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow \
  && virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV \
  && source $RETICULATE_PYTHON_ENV/bin/activate \
  && pip install -r requirements.txt \
  && deactivate \
  && rm -f requirements.txt \
  # Setup CmdStan
  && export CMSTAN_LINK=https://github.com/stan-dev/cmdstan/releases/download \
  && curl -fLo cmdstan-${CMDSTAN_VERSION}.tar.gz ${CMSTAN_LINK}/v${CMDSTAN_VERSION}/cmdstan-${CMDSTAN_VERSION}.tar.gz \
  && mkdir -p /opt/cmdstan/ \
  && chown -R $(whoami):staff /opt/cmdstan/ \
  && tar -xzf cmdstan-${CMDSTAN_VERSION}.tar.gz -C /opt/cmdstan/ \
  && make build -C /opt/cmdstan/cmdstan-${CMDSTAN_VERSION} \
  && rm cmdstan-${CMDSTAN_VERSION}.tar.gz
