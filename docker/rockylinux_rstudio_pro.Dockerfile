ARG QUARTO_VERSION=1.2.280
ARG REGISTRY=ghcr.io

FROM ${REGISTRY}/xiangyunhuang/rockylinux-rstudio:${QUARTO_VERSION}

ARG CMDSTAN_VERSION=2.32.2
ARG GITHUB_PAT=abc123

# Setup Extra R Packages
COPY DESCRIPTION DESCRIPTION
COPY install_r_packages.R install_r_packages.R
RUN export GITHUB_PAT=${GITHUB_PAT} \
  && export DOWNLOAD_STATIC_LIBV8=1 \
  && Rscript install_r_packages.R

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
