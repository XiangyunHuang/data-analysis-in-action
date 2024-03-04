## [![Book build status](https://github.com/XiangyunHuang/data-analysis-in-action/workflows/Book-Fedora/badge.svg?event=push)](https://github.com/XiangyunHuang/data-analysis-in-action/actions?workflow=Book-Fedora) [![Book build status](https://github.com/XiangyunHuang/data-analysis-in-action/workflows/Build-Docker/badge.svg?event=push)](https://github.com/XiangyunHuang/data-analysis-in-action/actions?workflow=Build-Docker) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/XiangyunHuang/data-analysis-in-action/main?urlpath=rstudio)

# R 语言数据分析实战

本仓库作为《R 语言数据分析实战》书稿源码的托管地址。目前内容较多的章节有

-   数据探索
    -   ggplot2 入门
    -   基础图形
    -   统计图形
    -   lattice 入门
    -   graphics 入门
    -   TikZ 入门
    -   探索实践
-   数据交流
    -   交互图形
    -   交互表格
    -   交互应用
    -   HTML 文档
    -   PDF 文档
-   统计分析
    -   常见的统计检验
    -   分类数据的分析
-   数据建模
    -   网络分析（R 语言社区开发者协作网络）
    -   时序分析（美团股价收益率的风险建模）
-   优化建模
    -   统计计算（统计模型与优化问题的关系）
    -   数值优化（线性、非线性、约束和无约束）
    -   优化问题（TSP 问题、投资组合问题等）
-   附录
    -   Git 和 Github

## 在线编译网页书籍

> **Tip**
>
> 不需要安装任何软件和 R 包。

1.  首先，点击[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/XiangyunHuang/data-analysis-in-action/main?urlpath=rstudio)，等待 Binder 初始化环境。初次启动可能花费一些等待时间，但比起本地安装软件和 R 包，这点时间可以忽略。

2.  然后，即可在 RStudio IDE 内运行书籍内任意代码和示例，甚至编译整本书籍。

<details>

<summary>点击了解更多</summary>

![Binder 环境](https://github.com/XiangyunHuang/data-analysis-in-action/assets/12031874/238765fd-a348-416f-b68f-b8e751de3244)

</details>

## 本地编译网页书籍

### 方法 1（推荐）

``` bash
# 拉取镜像
docker pull ghcr.io/xiangyunhuang/fedora-rstudio-pro:1.4.515
# 进入项目目录
cd ~/Documents/data-analysis-in-action
# 启动容器
docker run -itd -p 8484:8787 --name=daar \
  --privileged=true -v "/${PWD}:/home/docker" \
  ghcr.io/xiangyunhuang/fedora-rstudio-pro:1.4.515
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

## Docker 镜像中的 R 包

<details>

<summary>点击获取 R 包信息</summary>

``` r
pkg_dep <- desc::desc_get_deps()
pkg_dep <- pkg_dep[pkg_dep$type == "Imports", "package"]
xfun::session_info(packages = pkg_dep, dependencies = FALSE)
```

```         
R version 4.3.3 (2024-02-29)
Platform: x86_64-apple-darwin20 (64-bit)
Running under: macOS Sonoma 14.3.1, RStudio 2023.12.1.402

Locale: en_US.UTF-8 / en_US.UTF-8 / en_US.UTF-8 / C / en_US.UTF-8 / en_US.UTF-8

Package version:
  BB_2019.10.1              beanplot_1.3.1            broom_1.0.5              
  car_3.1.2                 coin_1.4.3                data.table_1.15.2        
  datasauRus_0.1.8          dbplyr_2.4.0              downlit_0.4.3            
  dplyr_1.1.4               DT_0.32                   dunn.test_1.3.5          
  dygraphs_1.1.1.6          e1071_1.7.14              ECOSolveR_0.5.5          
  GA_3.2.4                  ggalluvial_0.12.5         gganimate_1.0.9          
  ggbeeswarm_0.7.2          ggbump_0.1.99999          ggdensity_1.0.0          
  ggeffects_1.5.0           ggExtra_0.10.1            ggforce_0.4.2            
  ggfortify_0.4.16          ggmosaic_0.3.3            ggnewscale_0.4.10        
  ggplot2_3.5.0             ggraph_2.2.0              ggrepel_0.9.5            
  ggridges_0.5.6            ggsignif_0.6.4            ggstats_0.5.1            
  ggstream_0.1.0            ggthemes_5.1.0            ggTimeSeries_1.0.2       
  ggVennDiagram_1.5.2       ggwordcloud_0.6.1         gifski_1.12.0.2          
  gt_0.10.1                 hexbin_1.28.3             HistData_0.9.1           
  jiebaR_0.11               kernlab_0.9.32            knitr_1.45               
  latticeExtra_0.6.30       lvplot_0.2.1              magick_2.8.3             
  maps_3.4.2                misc3d_0.9.1              nloptr_2.0.3             
  nomnoml_0.3.0             patchwork_1.2.0           pdftools_3.4.0           
  plot3D_1.4.1              plotly_4.10.4             pROC_1.18.5              
  purrr_1.0.2               pwr_1.3.0                 quadprog_1.5.8           
  quantmod_0.4.26           ragg_1.2.7                ROI_1.0.1                
  ROI.plugin.ecos_1.0.2     ROI.plugin.glpk_1.0.0     ROI.plugin.nloptr_1.0.1  
  ROI.plugin.quadprog_1.0.1 ROI.plugin.scs_1.1.2      rootSolve_1.8.2.4        
  RSQLite_2.3.5             scs_3.2.4                 showtext_0.9.7           
  spacyr_1.3.0              text2vec_0.6.4            tidygraph_1.3.1          
  tikzDevice_0.12.6         tinyplot_0.0.5.9000       titanic_0.1.0            
  treemapify_2.5.6          TSP_1.2.4                 vcd_1.4.12               
  vioplot_0.4.0             visNetwork_2.1.2          webshot2_0.1.1           
  xml2_1.3.6                xts_0.13.2  
```

</details>
