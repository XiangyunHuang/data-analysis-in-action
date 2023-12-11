FROM rockylinux:9 AS rockylinux-rstudio-max

ARG QUARTO_VERSION=1.2.280
ARG R_VERSION=4.3.2
ARG RSTUDIO_VERSION=2023.09.1-494
ARG USER=docker
ARG PASSWORD=docker123

# Setup R and Texlive
RUN dnf -y update  \
  && echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
  && dnf -y install "dnf-command(config-manager)" \
  && dnf -y config-manager --set-enabled crb \
  && dnf install -y epel-release \
  && dnf -y update \
  && dnf install -y initscripts \
    bzip2 \
    passwd \
    firewalld \
    glibc-langpack-en \
    which \
    sudo \
  && groupadd staff \
  && useradd -g staff -d /home/${USER} -u 10001 ${USER} \
  && echo ${USER}:${PASSWORD} | chpasswd \
  && echo "%staff ALL=(ALL) ALL" >> /etc/sudoers \
  && dnf install -y pkgconf-pkg-config \
    bzip2-devel \
    flexiblas-devel \
    gcc-c++ \
    gcc-objc \
    gcc-objc++ \
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
    lapack-devel \
    blas-devel \
    libtool \
    texinfo \
    perl-File-Find

# Setup Quarto, Pandoc, TinyTeX, R Library and RStudio
RUN export QUARTO_LINK=https://github.com/quarto-dev/quarto-cli/releases/download \
  && curl -fLo quarto.tar.gz ${QUARTO_LINK}/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz \
  && mkdir -p /opt/quarto/ \
  && chown -R :staff /opt/quarto \
  && tar -xzf quarto.tar.gz -C /opt/quarto/ \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/quarto /usr/local/bin/quarto \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/tools/x86_64/pandoc /usr/local/bin/pandoc \
  && rm -f quarto.tar.gz

RUN quarto install tinytex --quiet \
  && mv /root/.TinyTeX/ /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && chown -R :staff /opt/TinyTeX

RUN curl -fLo R-${R_VERSION}.tar.gz https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz \
  && tar -xzf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  && ./configure --enable-R-shlib --enable-memory-profiling \
  && make \
  && make install \
  && cd .. && rm -rf R-${R_VERSION} \
  && mkdir -p /usr/local/lib64/R/site-library \
  && chown -R :staff /usr/local/lib64/R/site-library \
  && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/local/lib64/R/etc/Rprofile.site \
  && echo "export LC_ALL=en_US.UTF-8"  >> /etc/profile \
  && echo "export LANG=en_US.UTF-8"  >> /etc/profile \
  && chmod a+r /usr/local/lib64/R/etc/Rprofile.site \
  && echo "LANG=en_US.UTF-8" >> /usr/local/lib64/R/etc/Renviron.site \
  && Rscript -e "install.packages('rspm');rspm::enable();install.packages('rmarkdown');" \
  && Rscript -e "tinytex::tlmgr_install('ctex')"

RUN export RSTUDIO_LINK=https://download2.rstudio.org/server/rhel9/x86_64 \
  && curl -fLo rstudio.rpm ${RSTUDIO_LINK}/rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm \
  && dnf install -y rstudio.rpm \
  && rm -f rstudio.rpm \
  && dnf clean all

# Setup locale and timezone
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV TZ=Etc/UTC
ENV PATH=$PATH:/usr/local/bin

WORKDIR /home/${USER}/

EXPOSE 8787/tcp

CMD [ "/sbin/init" ]
