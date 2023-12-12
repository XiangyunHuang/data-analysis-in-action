FROM rockylinux:9 AS rockylinux-rstudio-max

ARG QUARTO_VERSION=1.2.280
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
    automake \
    libXmu-devel \
    libXt-devel \
    java-11-openjdk-devel \
    cairo-devel \
    libcurl-devel \
    libjpeg-turbo-devel \
    libtiff-devel  \
    pango-devel \
    blas-devel \
    lapack-devel \
    openblas-devel \
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
  && rm -f quarto.tar.gz

RUN quarto install tinytex --quiet \
  && mv /root/.TinyTeX/ /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && chown -R ${USER}:staff /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX

COPY texlive.txt texlive.txt
RUN export CRAN_REPO=https://cran.r-project.org \
  && curl -fLo R-${R_VERSION}.tar.gz ${CRAN_REPO}/src/base/R-4/R-${R_VERSION}.tar.gz \
  && tar -xzf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  && ./configure --enable-R-shlib --enable-BLAS-shlib --enable-memory-profiling --with-blas="-lopenblas" \
  && make \
  && make install \
  && cd .. && rm -rf R-${R_VERSION} \
  && mkdir -p /usr/local/lib64/R/site-library \
  && chown -R ${USER}:staff /usr/local/lib64/R/ \
  && chmod -R g+wx /usr/local/lib64/R/ \
  && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/local/lib64/R/etc/Rprofile.site \
  && echo "export LC_ALL=en_US.UTF-8"  >> /etc/profile \
  && echo "export LANG=en_US.UTF-8"  >> /etc/profile \
  && chmod a+r /usr/local/lib64/R/etc/Rprofile.site \
  && echo "LANG=en_US.UTF-8" >> /usr/local/lib64/R/etc/Renviron.site \
  && Rscript -e "install.packages('rspm');rspm::enable();install.packages('rmarkdown');" \
  && Rscript -e "tinytex::tlmgr_install(readLines('texlive.txt'))" \
  && rm -f texlive.txt

RUN export RSTUDIO_LINK=https://download2.rstudio.org/server/rhel9/x86_64 \
  && curl -fLo rstudio.rpm ${RSTUDIO_LINK}/rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm \
  && dnf install -y rstudio.rpm \
  && rm -f rstudio.rpm \
  && dnf clean all

# Setup fonts, chromium and cargo for gganimate, gifski, mermaid
RUN dnf install -y xz cargo chromium \
    google-noto-cjk-fonts-common \
    google-noto-sans-cjk-ttc-fonts \
    google-noto-serif-cjk-ttc-fonts \
  && dnf clean all

# Setup Python for Matplotlib
COPY requirements.txt requirements.txt
RUN dnf install -y python3-virtualenv \
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
  && Rscript install_r_packages.R \
  && rm -f install_r_packages.R DESCRIPTION

# Setup JAGS
RUN export JAGS_LINK=https://zenlayer.dl.sourceforge.net/project/mcmc-jags/JAGS \
  && curl -fLo JAGS-${JAGS_VERSION}.tar.gz ${JAGS_LINK}/${JAGS_MAJOR}.x/Source/JAGS-${JAGS_VERSION}.tar.gz \
  && tar -xzf JAGS-${JAGS_VERSION}.tar.gz \
  && cd JAGS-${JAGS_VERSION} && ./configure && make && make install && cd .. \
  && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/ \
  && Rscript -e "install.packages('rjags', configure.args='--enable-rpath')" \
  && rm -f JAGS-${JAGS_VERSION}.tar.gz && rm -rf JAGS-${JAGS_VERSION} \
  && dnf clean all

# Setup CmdStan
RUN export CMSTAN_LINK=https://github.com/stan-dev/cmdstan/releases/download \
  && curl -fLo cmdstan-${CMDSTAN_VERSION}.tar.gz ${CMSTAN_LINK}/v${CMDSTAN_VERSION}/cmdstan-${CMDSTAN_VERSION}.tar.gz \
  && mkdir -p /opt/cmdstan/ \
  && chown -R $(whoami):staff /opt/cmdstan/ \
  && tar -xzf cmdstan-${CMDSTAN_VERSION}.tar.gz -C /opt/cmdstan/ \
  && make build -C /opt/cmdstan/cmdstan-${CMDSTAN_VERSION} \
  && rm cmdstan-${CMDSTAN_VERSION}.tar.gz

# Setup locale and timezone
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Etc/UTC
ENV PATH=$PATH:/usr/local/bin

WORKDIR /home/${USER}/

EXPOSE 8787/tcp

CMD [ "/sbin/init" ]
