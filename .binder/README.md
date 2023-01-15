# Template for RStudio on Binder / JupyterHub

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/rocker-org/binder/HEAD?urlpath=rstudio)

Generate a Git repository that can run R code with RStudio on
the browser via [mybinder.org](https://mybinder.org) or any JupyterHub
from this template repository!

Based on the [rocker/geospatial](https://hub.docker.com/r/rocker/geospatial)
image.

## How to use this repo

### 1. Create a new repo using this as a template

Use the [Use this template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template)
button on GitHub. Use a descriptive name representing the
GUI app you are running / demoing. You can then follow the rest of
the instructions in this README from your newly created repository.

### 2. Install any packages you want

You can create an `install.R` file that will be executed on build.
Use `install.packages` or `devtools::install_version`.

```R
install.packages("ggplot2")
```

Packages are installed from [packagemanager.rstudio.com](https://packagemanager.rstudio.com/client/#/),
and binary packages are preferred wherever possible. For some R packages,
you might need to install system packages via apt - you can do so by writing
out a list of apt package names in `apt.txt`.

### 3. Modify the Binder Badge in the README.md

The 'Launch on Binder' badge in this README points to the template repository.
You should modify it to point to your own repository. Keep the `urlpath=rstudio`
parameter intact - that is what makes sure your repo will launch directly into
RStudio

### 4. Add your R code and update README

Finally, add the R code you want to demo to the repository! Cleanup the README
too so it talks about your code, not these instructions on setting up this repo

## Troubleshooting

**It didn't work! What do I do now?**.  If you are installing additional R
*packages, this will sometimes fail when a package requires an external library
*that is not found on the container.  We're working on a more elegant solution
*for this case, but meanwhile, you'll need to modify the Dockerfile to install
*these libraries.  For instance, the `gsl` [R package page
*reads](https://packagemanager.rstudio.com/client/#/repos/1/packages/gsl)

```shell
# Install System Prerequisites for Ubuntu 20.04 (focal)
apt-get install -y libgsl0-dev
```

To solve this, you will need to add the following line to your `apt.txt` file:

```txt
libgsl0-dev
```

Or, just get in touch by opening an issue. We'll try and resolve common cases so
more things work out of the box.
