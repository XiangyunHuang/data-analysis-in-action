FROM rockylinux:9 AS rockylinux-rstudio

ARG QUARTO_VERSION=1.2.280
ARG QUARTO_LINK=https://github.com/quarto-dev/quarto-cli/releases/download
ARG RSTUDIO_LINK=https://download2.rstudio.org/server/rhel9/x86_64
ARG RSTUDIO_VERSION=2023.09.1-494

# Setup R and Texlive
RUN dnf -y upgrade  \
  && echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
  && dnf install -y dnf-plugins-core glibc-langpack-en epel-release \
  && /usr/bin/crb enable \
  && dnf -y upgrade \
  && dnf install -y R-devel \
    initscripts \
    bzip2 \
    passwd \
    firewalld \
  && dnf clean all

# Setup Texlive
RUN dnf install -y texinfo \
    texlive-awesomebox \
    texlive-fontawesome5 \
    texlive-fontawesome \
    texlive-tcolorbox \
    texlive-standalone \
    texlive-titling \
    texlive-pgfplots \
    texlive-framed \
    texlive-dvisvgm \
    texlive-dvips \
    texlive-dvipng \
    texlive-ctex \
    texlive-fandol \
    texlive-xetex \
    texlive-jknapltx \
    texlive-mathspec \
    texlive-mdwtools \
    texlive-lm-math \
    texlive-makeindex \
  && dnf clean all

# Setup Fonts and cargo 
RUN dnf install -y cargo \
    python3-virtualenv \
    google-noto-cjk-fonts-common \
    google-noto-sans-cjk-ttc-fonts \
    google-noto-serif-cjk-ttc-fonts \
  && dnf clean all

# Setup Group authority, Quarto, Pandoc, Chromium and R Library
RUN groupadd staff \
  && useradd -g staff -d /home/docker docker \
  && echo 'docker:docker123' | chpasswd \
  && curl -fLo quarto.tar.gz ${QUARTO_LINK}/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz \
  && mkdir -p /opt/quarto/ \
  && tar -xzf quarto.tar.gz -C /opt/quarto/ \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/quarto /usr/bin/quarto \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/tools/x86_64/pandoc /usr/bin/pandoc \
  && rm -f quarto.tar.gz \
  && quarto install --quiet chromium \
  && mkdir -p /usr/local/lib/R/site-library \
  && chown -R docker:staff /usr/local/lib/R/site-library \
  && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/lib64/R/etc/Rprofile.site \
  && echo "export LC_ALL=en_US.UTF-8"  >> /etc/profile \
  && echo "export LANG=en_US.UTF-8"  >> /etc/profile \
  && chmod a+r /usr/lib64/R/etc/Rprofile.site \
  && echo "LANG=en_US.UTF-8" >> /usr/lib64/R/etc/Renviron.site \
  && Rscript -e "install.packages('rspm');rspm::enable();" \
  && curl -fLo rstudio.rpm ${RSTUDIO_LINK}/rstudio-server-rhel-${RSTUDIO_VERSION}-x86_64.rpm \
  && dnf install -y rstudio.rpm \
  && rm -f rstudio.rpm \
  && dnf clean all

# Setup locale and timezone
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=Etc/UTC

WORKDIR /home/docker/

EXPOSE 8787/tcp

CMD [ "/sbin/init" ]
