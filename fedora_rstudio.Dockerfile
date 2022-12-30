FROM fedora:37

RUN groupadd staff \
  && useradd -g staff -d /home/docker docker

LABEL org.label-schema.license="GPL-3.0" \
      org.label-schema.vcs-url="https://github.com/XiangyunHuang/data-analysis-in-action" \
      org.label-schema.vendor="Book Project" \
      maintainer="Xiangyun Huang <xiangyunfaith@outlook.com>"

# System dependencies required for R packages
RUN dnf -y upgrade \
  && dnf -y install dnf-plugins-core \
  && dnf -y install pandoc \
   pandoc-pdf \
   glibc-langpack-en \
   NLopt-devel \
   automake \
   R-devel \
   R-littler \
   R-littler-examples \
   ghostscript \
   optipng \
   ImageMagick \
   texinfo \
   cargo \
   bzip2 \
   passwd \
   initscripts \
   libcurl-devel \
   openssl-devel \
   libssh2-devel \
   libgit2-devel \
   libxml2-devel \
   glpk-devel \
   gmp-devel \
   cairo-devel \
   v8-devel \
   igraph-devel \
   firewalld \
   python3-virtualenv \
   texlive-sourceserifpro \
   texlive-sourcecodepro \
   texlive-sourcesanspro \
   texlive-pdfcrop \
   texlive-dvisvgm \
   texlive-dvips \
   texlive-dvipng \
   texlive-ctex \
   texlive-fandol \
   texlive-xetex \
   texlive-framed \
   texlive-titling \
   texlive-fira \
   texlive-awesomebox \
   texlive-fontawesome5 \
   texlive-fontawesome \
   texlive-newtx \
   texlive-tcolorbox

RUN ln -s /usr/lib64/R/library/littler/examples/install.r /usr/bin/install.r \
 && ln -s /usr/lib64/R/library/littler/examples/install2.r /usr/bin/install2.r \
 && ln -s /usr/lib64/R/library/littler/examples/installGithub.r /usr/bin/installGithub.r \
 && ln -s /usr/lib64/R/library/littler/examples/testInstalled.r /usr/bin/testInstalled.r \
 && mkdir -p /usr/local/lib/R/site-library \
 && echo "options(repos = c(CRAN = 'https://cran.r-project.org/'))" | tee -a /usr/lib64/R/etc/Rprofile.site \
 && chmod a+r /usr/lib64/R/etc/Rprofile.site \
 && echo "LANG=en_US.UTF-8" >> /usr/lib64/R/etc/Renviron.site \
 && echo "export LC_ALL=en_US.UTF-8"  >> /etc/profile \
 && echo "export LANG=en_US.UTF-8"  >> /etc/profile \
 && echo "CXXFLAGS += -Wno-ignored-attributes" >> /usr/lib64/R/etc/Makeconf \
 && Rscript -e 'x <- file.path(R.home("doc"), "html"); if (!file.exists(x)) {dir.create(x, recursive=TRUE); file.copy(system.file("html/R.css", package="stats"), x)}' \
 && install.r docopt \
 && install2.r remotes

# Set RStudio Server
RUN dnf -y install rstudio-server \
 && cp /usr/lib/systemd/system/rstudio-server.service /etc/init.d/ \
 && chmod +x /etc/init.d/rstudio-server.service \
 && systemctl enable rstudio-server \
 # Set passwd
 && echo 'docker:docker123' | chpasswd \
 # Set group authority
 && chown -R docker:staff /usr/local/lib/R/site-library

# Set locale
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Set default timezone
ENV TZ UTC

WORKDIR /home/docker/

EXPOSE 8787/tcp

CMD [ "/sbin/init" ]
