## [![Book build status](https://github.com/XiangyunHuang/data-analysis-in-action/workflows/Book-Ubuntu/badge.svg?event=push)](https://github.com/XiangyunHuang/data-analysis-in-action/actions?workflow=Book-Ubuntu) [![Book build status](https://github.com/XiangyunHuang/data-analysis-in-action/workflows/Build-Docker/badge.svg?event=push)](https://github.com/XiangyunHuang/data-analysis-in-action/actions?workflow=Build-Docker) [![Netlify Status](https://api.netlify.com/api/v1/badges/63e74f25-e5ff-4cee-9c4b-198d18872a6c/deploy-status)](https://app.netlify.com/sites/data-analysis-in-action/deploys) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/XiangyunHuang/data-analysis-in-action/main?urlpath=rstudio)

# R 语言数据分析实战

本仓库作为《R 语言数据分析实战》书稿源码的托管地址。目前完成度较高的章节有

-   数据探索
    -   ggplot2 入门
    -   基础图形
    -   统计图形
-   数据交流
    -   交互图形
-   数据建模
    -   预测核辐射强度的分布
-   附录
    -   统计计算

## 在线编译网页书籍

> **Tip**
>
> 不需要安装任何软件和 R 包。

1.  首先，点击[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/XiangyunHuang/data-analysis-in-action/main?urlpath=rstudio)，等待 Binder 初始化环境。初次启动可能花费一些等待时间，但比起本地安装软件和 R 包，这点时间可以忽略。

2.  然后，即可在 RStudio IDE 内运行书籍内任意代码和示例，甚至编译整本书籍。

## 本地编译网页书籍

### 方法 1

``` bash
# 拉取镜像
docker pull ghcr.io/xiangyunhuang/daar:latest
# 进入项目目录
cd ~/Documents/data-analysis-in-action
# 启动容器
docker run -itd -p 8484:8787 --name=daar \
  --privileged=true -v "/${PWD}:/home/docker" \
  ghcr.io/xiangyunhuang/daar:latest
# 进入容器
docker exec -it daar bash
# 编译书籍
quarto render
```

### 方法 2

1.  首先，克隆项目到本地，并进入项目根目录，安装本书依赖的 R 包。

    ``` r
    if(!require("remotes")) install.packages('remotes')
    remotes::install_deps(".", dependencies = TRUE)
    ```

2.  然后，在 RStudio IDE 的卫星窗口 Terminal 内，运行命令：

    ``` bash
    make html
    ```

    或者，点击 Build 窗口内的工具按钮 `Build All`，就可以看到编译书籍的过程了，等待编译完成。

3.  最后，进入项目根目录下的文件夹 `_book/`，点击网页文件 `index.html`，即可在线浏览书籍。
