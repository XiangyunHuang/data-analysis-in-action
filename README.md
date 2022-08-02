[![Book build status](https://github.com/XiangyunHuang/data-science-in-action/workflows/Render-Book/badge.svg?event=push)](https://github.com/XiangyunHuang/data-science-in-action/actions?workflow=Render-Book) [![Netlify Status](https://api.netlify.com/api/v1/badges/63e74f25-e5ff-4cee-9c4b-198d18872a6c/deploy-status)](https://app.netlify.com/sites/data-science-in-action/deploys)
---

# 数据科学实战

本仓库作为 [《R 语言数据科学实战》](https://bookdown.org/xiangyun/data-science-in-action/) 书稿源码的托管地址。

## 本地编译网页书籍

1. 首先，克隆项目到本地，并进入项目根目录，安装本书依赖的 R 包。

    ```r
    if(!require("remotes")) install.packages('remotes')
    remotes::install_deps(".", dependencies = TRUE)
    ```

1. 然后，在 RStudio IDE 的卫星窗口 Terminal 内，运行命令：

    ```bash
    make html
    ```

    或者，点击 Build 窗口内的工具按钮 `Build All`，就可以看到编译书籍的过程了，等待编译完成。

1. 最后，进入项目根目录下的文件夹 `_book/`，点击网页文件 `index.html`，即可在线浏览书籍。
