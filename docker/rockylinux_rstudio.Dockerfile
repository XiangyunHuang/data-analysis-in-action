FROM rockylinux:9 AS rockylinux-rstudio

ARG QUARTO_VERSION=1.2.280
ARG QUARTO_LINK=https://github.com/quarto-dev/quarto-cli/releases/download
ARG RSTUDIO_LINK=https://download2.rstudio.org/server/rhel9/x86_64
ARG RSTUDIO_VERSION=2023.09.1-494

# Setup R and Texlive
RUN dnf -y update  \
  && echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
  && dnf -y install "dnf-command(config-manager)" \
  && dnf -y config-manager --set-enabled crb \
  && dnf install -y epel-release \
  && dnf -y update \
  && dnf install -y R-devel \
    initscripts \
    bzip2 \
    passwd \
    firewalld \
    dnf-plugins-core \
    glibc-langpack-en \
  && dnf clean all

# Setup Texlive
RUN dnf install -y texinfo \
    texlive-awesomebox \
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
    texlive-rsfs \
    texlive-jknapltx \
    texlive-mathspec \
    texlive-mdwtools \
    texlive-lm-math \
    texlive-makeindex \
    texlive-xifthen \
    texlive-xstring \
  && dnf clean all \
  && export TEXLIVE_REPO=https://www.tug.org/texlive//Contents/live/texmf-dist/tex/latex \
  && export TEXLIVE_DIR=/usr/share/texlive/texmf-dist/tex/latex \
  && mkdir -p ${TEXLIVE_DIR}/everysel \
  && curl -fLo ${TEXLIVE_DIR}/everysel/everysel-2011-10-28.sty ${TEXLIVE_REPO}/everysel/everysel-2011-10-28.sty \
  && curl -fLo ${TEXLIVE_DIR}/everysel/everysel.sty ${TEXLIVE_REPO}/everysel/everysel.sty \
  && mkdir -p ${TEXLIVE_DIR}/tikz-network \
  && curl -fLo ${TEXLIVE_DIR}/tikz-network/tikz-network.sty ${TEXLIVE_REPO}/tikz-network/tikz-network.sty \
  && mkdir -p ${TEXLIVE_DIR}/datatool \
  && curl -fLo ${TEXLIVE_DIR}/datatool/databar.sty  ${TEXLIVE_REPO}/datatool/databar.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/databib.sty  ${TEXLIVE_REPO}/datatool/databib.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/datagidx.sty ${TEXLIVE_REPO}/datatool/datagidx.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/datapie.sty  ${TEXLIVE_REPO}/datatool/datapie.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/dataplot.sty  ${TEXLIVE_REPO}/datatool/dataplot.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/datatool-base.sty ${TEXLIVE_REPO}/datatool/datatool-base.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/datatool-fp.sty   ${TEXLIVE_REPO}/datatool/datatool-fp.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/datatool-pgfmath.sty	 ${TEXLIVE_REPO}/datatool/datatool-pgfmath.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/datatool.sty  ${TEXLIVE_REPO}/datatool/datatool.sty \
  && curl -fLo ${TEXLIVE_DIR}/datatool/person.sty    ${TEXLIVE_REPO}/datatool/person.sty \
  && mkdir -p ${TEXLIVE_DIR}/xfor \
  && curl -fLo ${TEXLIVE_DIR}/xfor/xfor.sty  ${TEXLIVE_REPO}/xfor/xfor.sty \
  && mkdir -p ${TEXLIVE_DIR}/substr \
  && curl -fLo ${TEXLIVE_DIR}/substr/substr.sty  ${TEXLIVE_REPO}/substr/substr.sty \
  && mkdir -p ${TEXLIVE_DIR}/smartdiagram \
  && curl -fLo ${TEXLIVE_DIR}/smartdiagram/smartdiagram.sty  ${TEXLIVE_REPO}/smartdiagram/smartdiagram.sty \
  && curl -fLo ${TEXLIVE_DIR}/smartdiagram/smartdiagramlibraryadditions.code.tex  ${TEXLIVE_REPO}/smartdiagram/smartdiagramlibraryadditions.code.tex \
  && curl -fLo ${TEXLIVE_DIR}/smartdiagram/smartdiagramlibrarycore.commands.code.tex  ${TEXLIVE_REPO}/smartdiagram/smartdiagramlibrarycore.commands.code.tex \
  && curl -fLo ${TEXLIVE_DIR}/smartdiagram/smartdiagramlibrarycore.definitions.code.tex  ${TEXLIVE_REPO}/smartdiagram/smartdiagramlibrarycore.definitions.code.tex \
  && curl -fLo ${TEXLIVE_DIR}/smartdiagram/smartdiagramlibrarycore.styles.code.tex  ${TEXLIVE_REPO}/smartdiagram/smartdiagramlibrarycore.styles.code.tex \
  && texhash

# Setup Fonts and cargo 
RUN dnf install -y xz cargo chromium \
    python3-virtualenv \
    google-noto-cjk-fonts-common \
    google-noto-sans-cjk-ttc-fonts \
    google-noto-serif-cjk-ttc-fonts \
  && dnf clean all

# Setup Group authority, Quarto, Pandoc, Chromium and R Library
RUN groupadd staff \
  && useradd -g staff -d /home/docker -u 10001 docker \
  && echo 'docker:docker123' | chpasswd \
  && curl -fLo quarto.tar.gz ${QUARTO_LINK}/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz \
  && mkdir -p /opt/quarto/ \
  && tar -xzf quarto.tar.gz -C /opt/quarto/ \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/quarto /usr/bin/quarto \
  && ln -s /opt/quarto/quarto-${QUARTO_VERSION}/bin/tools/x86_64/pandoc /usr/bin/pandoc \
  && rm -f quarto.tar.gz \
  && mkdir -p /usr/local/lib/R/site-library \
  && chown -R docker:staff /usr/local/lib/R/site-library \
  && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/lib64/R/etc/Rprofile.site \
  && echo "export LC_ALL=en_US.UTF-8"  >> /etc/profile \
  && echo "export LANG=en_US.UTF-8"  >> /etc/profile \
  && chmod a+r /usr/lib64/R/etc/Rprofile.site \
  && echo "LANG=en_US.UTF-8" >> /usr/lib64/R/etc/Renviron.site \
  && Rscript -e "install.packages('rspm');rspm::enable();install.packages('magick');rspm::install_sysreqs();" \
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
