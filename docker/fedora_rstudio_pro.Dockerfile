ARG QUARTO_VERSION=1.2.280
ARG REGISTRY=ghcr.io/xiangyunhuang

FROM ${REGISTRY}/fedora-rstudio:${QUARTO_VERSION} AS fedora-rstudio-pro

ARG CMDSTAN_VERSION=2.32.2
ARG GITHUB_PAT=abc123

# Texlive dependencies required for Quarto Book project
RUN dnf -y install texlive-sourcecodepro \
   texlive-pdfcrop \
   texlive-dvisvgm \
   texlive-dvips \
   texlive-dvipng \
   texlive-draftwatermark \
   texlive-ctex \
   texlive-fandol \
   texlive-xetex \
   texlive-jknapltx \
   texlive-mathspec \
   texlive-mdwtools \
   texlive-cancel \
   texlive-glossaries \
   texlive-tikzfill \
   texlive-makeindex \
   texlive-framed \
   texlive-titling \
   texlive-fira \
   texlive-soul \
   texlive-xetex-pstricks \
   texlive-pst-arrow \
   texlive-awesomebox \
   texlive-fontawesome5 \
   texlive-fontawesome \
   texlive-newtx \
   texlive-tcolorbox \
   texlive-tocbibind \
   texlive-standalone \
   texlive-animate \
   texlive-media9 \
   texlive-pgfplots \
   texlive-smartdiagram \
   texlive-tikz-network \
 && dnf clean all

# Install Extra R Packages
COPY desc_pkgs.txt desc_pkgs.txt
RUN dnf -y copr enable iucar/cran \
  && dnf -y install R-CoprManager xz libcurl-devel \
  && dnf -y install $(cat desc_pkgs.txt) \
  && dnf clean all \
  && rm -f desc_pkgs.txt

# For R
COPY DESCRIPTION DESCRIPTION
# For Python
COPY requirements.txt requirements.txt
# Setup Matrix showtext V8 and INLA
RUN install2.r MatrixModels TMB glmmTMB showtextdb showtext \
  && export GITHUB_PAT=${GITHUB_PAT} \
  && export DOWNLOAD_STATIC_LIBV8=1 \
  && Rscript -e "install.packages('INLA', repos = c(getOption('repos'), INLA = 'https://inla.r-inla-download.org/R/stable'))" \
  && Rscript -e "remotes::install_deps('.', dependencies = TRUE)" \
  && rm -f DESCRIPTION \
  # Setup Python Env
  && mkdir -p /opt/.virtualenvs/r-tensorflow \
  && chown -R $(whoami):staff /opt/.virtualenvs/r-tensorflow \
  && export RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow \
  && virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV \
  && source $RETICULATE_PYTHON_ENV/bin/activate \
  && pip install -r requirements.txt \
  && deactivate \
  && rm -f requirements.txt \
  # Setup CmdStan
  && curl -fLo cmdstan-${CMDSTAN_VERSION}.tar.gz https://github.com/stan-dev/cmdstan/releases/download/v${CMDSTAN_VERSION}/cmdstan-${CMDSTAN_VERSION}.tar.gz \
  && mkdir -p /opt/cmdstan/ \
  && chown -R $(whoami):staff /opt/cmdstan/ \
  && tar -xzf cmdstan-${CMDSTAN_VERSION}.tar.gz -C /opt/cmdstan/ \
  && make build -C /opt/cmdstan/cmdstan-${CMDSTAN_VERSION} \
  && rm cmdstan-${CMDSTAN_VERSION}.tar.gz
