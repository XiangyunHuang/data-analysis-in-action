FROM ghcr.io/xiangyunhuang/rockylinux-rstudio:1.4.515

ENV USERID=10001

RUN useradd -g staff -d /home/rstudio -u ${USERID} rstudio \
  && echo 'rstudio:rstudio' | chpasswd
