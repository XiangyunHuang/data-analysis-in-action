FROM rockylinux:9 AS rockylinux-rstudio-max

ARG QUARTO_VERSION=1.2.280
ARG R_MAJOR=4
ARG R_VERSION=4.3.2
ARG RSTUDIO_VERSION=2023.09.1-494
ARG CMDSTAN_VERSION=2.32.2
ARG JAGS_MAJOR=4
ARG JAGS_VERSION=4.3.2
ARG GITHUB_PAT=abc123
ARG USER=docker
ARG PASSWORD=docker123

# Setup R and Texlive
RUN dnf -y update  \
  && echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
  && dnf -y install "dnf-command(config-manager)" \
  && dnf -y config-manager --set-enabled crb \
  && dnf install -y epel-release \
  && dnf -y update \
  && dnf install -y initscripts which sudo bzip2 passwd firewalld \
    glibc-langpack-en \
  && groupadd staff \
  && useradd -g staff -d /home/${USER} -u 10001 ${USER} \
  && echo ${USER}:${PASSWORD} | chpasswd \
  && echo "%staff ALL=(ALL) ALL" >> /etc/sudoers \
  && dnf install -y pkgconf-pkg-config \
    bzip2-devel \
    flexiblas-devel \
    gcc-c++ \
    gcc-gfortran \
    libX11-devel \
    libicu-devel \
    libtirpc-devel \
    make \
    diffutils \
    pcre2-devel \
    pkgconfig \
    redhat-rpm-config \
    tcl-devel \
    tk-devel \
    tre-devel \
    xz-devel \
    zlib-devel \
    readline-devel \
    autoconf \
    libXmu-devel \
    libXt-devel \
    java-11-openjdk-devel \
    cairo-devel \
    libcurl-devel \
    libjpeg-turbo-devel \
    libtiff-devel  \
    pango-devel \
    libtool \
    texinfo \
    perl-File-Find

# Setup Quarto, Pandoc, TinyTeX, R Library and RStudio
RUN export QUARTO_LINK=https://github.com/quarto-dev/quarto-cli/releases/download \
  && curl -fLo quarto.tar.gz ${QUARTO_LINK}/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz \
  && mkdir -p /opt/quarto/ \
  && chown -R ${USER}:staff /opt/quarto \
  && chmod -R g+wx /opt/quarto \
  && tar -xzf quarto.tar.gz -C /opt/quarto/ \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/quarto /usr/local/bin/quarto \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/tools/x86_64/pandoc /usr/local/bin/pandoc \
  && rm -f quarto.tar.gz \
  && quarto install tinytex --quiet \
  && mv /root/.TinyTeX/ /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && chown -R ${USER}:staff /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX

COPY texlive.txt texlive.txt
RUN dnf install -y blas-devel lapack-devel  openblas-devel \
  && export CRAN_REPO=https://cran.r-project.org \
  && curl -fLo R-${R_VERSION}.tar.gz ${CRAN_REPO}/src/base/R-${R_MAJOR}/R-${R_VERSION}.tar.gz \
  && tar -xzf R-${R_VERSION}.tar.gz && cd R-${R_VERSION} \
  && ./configure --prefix=/opt/R-${R_VERSION} --enable-R-shlib --enable-BLAS-shlib --enable-memory-profiling --with-blas="-lopenblas" \
  && make && make install && cd .. && rm -rf R-${R_VERSION} && rm -f R-${R_VERSION}.tar.gz \
  && mkdir -p /opt/R-${R_VERSION}/lib64/R/site-library \
  && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /opt/R-${R_VERSION}/lib64/R/etc/Rprofile.site \
  && chmod a+r /opt/R-${R_VERSION}/lib64/R/etc/Rprofile.site \
  && echo "LANG=en_US.UTF-8" >> /opt/R-${R_VERSION}/lib64/R/etc/Renviron.site \
  && ln -s /opt/R-${R_VERSION}/bin/R /usr/local/bin/R \
  && ln -s /opt/R-${R_VERSION}/bin/Rscript /usr/local/bin/Rscript \
  && Rscript -e "install.packages('rspm');rspm::enable();install.packages('rmarkdown');" \
  && Rscript -e "tinytex::tlmgr_install(readLines('texlive.txt'))" \
  && chown -R ${USER}:staff /opt/R-${R_VERSION}/lib64/R/site-library \
  && chmod -R g+wx /opt/R-${R_VERSION}/lib64/R/site-library \
  && rm -f texlive.txt \
  && dnf clean all

# Setup JAGS and CmdStan
RUN dnf install -y lapack-devel blas-devel \
  && export JAGS_LINK=https://zenlayer.dl.sourceforge.net/project/mcmc-jags/JAGS \
  && curl -fLo JAGS-${JAGS_VERSION}.tar.gz ${JAGS_LINK}/${JAGS_MAJOR}.x/Source/JAGS-${JAGS_VERSION}.tar.gz \
  && tar -xzf JAGS-${JAGS_VERSION}.tar.gz \
  && cd JAGS-${JAGS_VERSION} && ./configure --prefix=/opt/JAGS-${JAGS_VERSION} \
  && make && make install && cd .. \
  && rm -f JAGS-${JAGS_VERSION}.tar.gz && rm -rf JAGS-${JAGS_VERSION} \
  && ln -s /opt/JAGS-${JAGS_VERSION}/bin/jags /usr/local/bin/jags \
  && chown -R ${USER}:staff /opt/JAGS-${JAGS_VERSION} \
  && chmod -R g+wx /opt/JAGS-${JAGS_VERSION} \
  && export PKG_CONFIG_PATH=/opt/JAGS-${JAGS_VERSION}/lib/pkgconfig/ \
  && export LD_RUN_PATH=/opt/JAGS-${JAGS_VERSION}/lib \
  && Rscript -e "install.packages('rjags', configure.args='--enable-rpath')" \
  && dnf clean all \
  && export CMDSTAN_LINK=https://github.com/stan-dev/cmdstan/releases/download \
  && curl -fLo cmdstan-${CMDSTAN_VERSION}.tar.gz ${CMDSTAN_LINK}/v${CMDSTAN_VERSION}/cmdstan-${CMDSTAN_VERSION}.tar.gz \
  && mkdir -p /opt/cmdstan/ \
  && tar -xzf cmdstan-${CMDSTAN_VERSION}.tar.gz -C /opt/cmdstan/ \
  && make build -C /opt/cmdstan/cmdstan-${CMDSTAN_VERSION} \
  && chown -R ${USER}:staff /opt/cmdstan/ \
  && chmod -R g+wx /opt/cmdstan/ \
  && rm cmdstan-${CMDSTAN_VERSION}.tar.gz


# Setup fonts, chromium and cargo for gganimate, gifski and mermaid
RUN dnf install -y chromium \
  && dnf clean all

RUN dnf install -y xz cargo rust ghostscript \
    google-noto-cjk-fonts-common \
    google-noto-sans-cjk-ttc-fonts \
    google-noto-serif-cjk-ttc-fonts \
  && dnf clean all

# Setup RStudio and Python 
COPY requirements.txt requirements.txt
RUN export RSTUDIO_LINK=https://download2.rstudio.org/server/rhel9/x86_64 \
  && curl -fLo rstudio.rpm ${RSTUDIO_LINK}/rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm \
  && dnf install -y rstudio.rpm \
  && rm -f rstudio.rpm \
  && dnf install -y python3-virtualenv \
  && export RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow \
  && mkdir -p ${RETICULATE_PYTHON_ENV} \
  && chown -R ${USER}:staff ${RETICULATE_PYTHON_ENV} \
  && chmod -R g+wx ${RETICULATE_PYTHON_ENV} \
  && virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV \
  && source $RETICULATE_PYTHON_ENV/bin/activate \
  && pip install -r requirements.txt \
  && deactivate \
  && rm -f requirements.txt \
  && dnf clean all

# Setup Extra R Packages
COPY DESCRIPTION DESCRIPTION
COPY install_r_packages.R install_r_packages.R
RUN export GITHUB_PAT=${GITHUB_PAT} \
  && export DOWNLOAD_STATIC_LIBV8=1 \
  && dnf install -y cmake \
  && Rscript install_r_packages.R \
  && chown -R ${USER}:staff /opt/R-${R_VERSION}/lib64/R/site-library \
  && chmod -R g+wx /opt/R-${R_VERSION}/lib64/R/site-library \
  && rm -f install_r_packages.R DESCRIPTION \
  && dnf clean all


# Setup Locale and Timezone
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Etc/UTC
ENV PATH=$PATH:/usr/local/bin

WORKDIR /home/${USER}/

EXPOSE 8787/tcp

CMD [ "/sbin/init" ]
