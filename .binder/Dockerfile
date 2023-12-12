FROM ghcr.io/xiangyunhuang/rockylinux-rstudio-max:1.4.515

ENV USERID=10002
ENV USER=rstudio

# Default User
RUN useradd -g staff -d /home/$USER -u ${USERID} $USER \
  && echo $USER:$USER | chpasswd

# Setup Python for Jupyter and Binder
RUN export RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow \
  && source $RETICULATE_PYTHON_ENV/bin/activate \
  && pip install jupyter-rsession-proxy notebook jupyterlab jupyterhub \
  && Rscript -e "rspm::enable();install.packages('IRkernel');" \
  && Rscript --quiet -e 'IRkernel::installspec(user = FALSE)' \
  && jupyter kernelspec list

EXPOSE 8888

CMD ["/bin/sh", "-c", "jupyter lab --ip 0.0.0.0 --no-browser"]

