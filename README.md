## [![Book build status](https://github.com/XiangyunHuang/data-analysis-in-action/workflows/Book-Fedora/badge.svg?event=push)](https://github.com/XiangyunHuang/data-analysis-in-action/actions?workflow=Book-Fedora) [![Book build status](https://github.com/XiangyunHuang/data-analysis-in-action/workflows/Build-Docker/badge.svg?event=push)](https://github.com/XiangyunHuang/data-analysis-in-action/actions?workflow=Build-Docker) [![Netlify Status](https://api.netlify.com/api/v1/badges/63e74f25-e5ff-4cee-9c4b-198d18872a6c/deploy-status)](https://app.netlify.com/sites/data-analysis-in-action/deploys) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/XiangyunHuang/data-analysis-in-action/main?urlpath=rstudio)

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
-   优化建模
    -   统计计算
    -   数值优化
    -   优化问题
-   附录
    -   数学符号

## 在线编译网页书籍

> **Tip**
>
> 不需要安装任何软件和 R 包。

1.  首先，点击[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/XiangyunHuang/data-analysis-in-action/main?urlpath=rstudio)，等待 Binder 初始化环境。初次启动可能花费一些等待时间，但比起本地安装软件和 R 包，这点时间可以忽略。

2.  然后，即可在 RStudio IDE 内运行书籍内任意代码和示例，甚至编译整本书籍。

## 本地编译网页书籍

### 方法 1（推荐）

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

## Docker 镜像中的 R 包

<details>

<summary>点击获取 R 包信息</summary>

``` r
xfun::session_info(packages = .packages(TRUE), dependencies = FALSE)
```

```         
R version 4.3.1 (2023-06-16)
Platform: x86_64-redhat-linux-gnu (64-bit)
Running under: Fedora Linux 38 (Container Image), RStudio 2023.6.0.421


Locale:
  LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
  LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
  LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
  LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

time zone: Etc/UTC
tzcode source: system (glibc)

Package version:
  abind_1.4.5               AsioHeaders_1.22.1.2      askpass_1.1              
  backports_1.4.1           base_4.3.1                base64enc_0.1.3          
  BB_2019.10.1              beanplot_1.3.1            beeswarm_0.4.0           
  bigD_0.2.0                bit_4.0.5                 bit64_4.0.5              
  bitops_1.0.7              blob_1.2.4                boot_1.3.28.1            
  brio_1.1.3                broom_1.0.5               broom.helpers_1.13.0     
  bslib_0.5.0               cachem_1.0.8              callr_3.7.3              
  car_3.1.2                 carData_3.0.5             checkmate_2.2.0          
  chromote_0.1.1            class_7.3.22              classInt_0.4.9           
  cli_3.6.1                 clipr_0.8.0               cluster_2.1.4            
  codetools_0.2.19          coin_1.4.2                colorspace_2.1.0         
  colourpicker_1.2.0        commonmark_1.9.0          compiler_4.3.1           
  CoprManager_0.5.2         cpp11_0.4.3               crayon_1.5.2             
  crosstalk_1.2.0           curl_5.0.1                data.table_1.14.8        
  datasauRus_0.1.6          datasets_4.3.1            DBI_1.1.3                
  dbplyr_2.3.2              deldir_1.0.9              desc_1.4.2               
  dichromat_2.0.0.1         diffobj_0.3.5             digest_0.6.31            
  docopt_0.7.1              downlit_0.4.2             dplyr_1.1.2              
  DT_0.28                   dunn.test_1.3.5           e1071_1.7.13             
  ECOSolveR_0.5.5           ellipsis_0.3.2            evaluate_0.21            
  fansi_1.0.4               farver_2.1.1              fastmap_1.1.1            
  filehash_2.4.5            fontawesome_0.5.1         forcats_1.0.0            
  foreach_1.5.2             foreign_0.8.84            fs_1.6.2                 
  GA_3.2.3                  generics_0.1.3            geodata_0.5.8            
  geometry_0.4.7            ggalluvial_0.12.5         gganimate_1.0.8          
  ggbeeswarm_0.7.2          ggbump_0.1.99999          ggdensity_1.0.0          
  ggeffects_1.2.3           ggExtra_0.10.0            ggfittext_0.10.0         
  ggforce_0.4.1             ggfortify_0.4.16          ggmosaic_0.3.3           
  ggnewscale_0.4.9          ggplot2_3.4.2             ggraph_2.1.0             
  ggrepel_0.9.3             ggridges_0.5.4            ggsignif_0.6.4           
  ggstats_0.3.0             ggTimeSeries_1.0.2        ggVennDiagram_1.2.2      
  ggwordcloud_0.5.0         gifski_1.12.0.1           glmnet_4.1.7             
  glue_1.6.2                gmp_0.7.1                 graphics_4.3.1           
  graphlayouts_1.0.0        grDevices_4.3.1           grid_4.3.1               
  gridExtra_2.3             gridtext_0.1.5            gt_0.9.0                 
  gtable_0.3.3              haven_2.5.2               here_1.0.1               
  highr_0.10                HistData_0.8.7            hms_1.1.3                
  htmltools_0.5.5           htmlwidgets_1.6.2         httpuv_1.6.11            
  httr_1.4.6                igraph_1.5.0              insight_0.19.2           
  interp_1.1.4              isoband_0.2.7             iterators_1.0.14         
  jpeg_0.1.10               jquerylib_0.1.4           jsonlite_1.8.5           
  juicyjuice_0.1.0          kernlab_0.9.32            KernSmooth_2.23.21       
  knitr_1.43                labeling_0.4.2            labelled_2.12.0          
  later_1.3.1               lattice_0.21.8            latticeExtra_0.6.30      
  lazyeval_0.2.2            libcoin_1.0.9             lifecycle_1.0.3          
  linprog_0.9.4             littler_0.3.18            lme4_1.1.33              
  lmtest_0.9.40             lpSolve_5.6.18            lvplot_0.2.1             
  lwgeom_0.2.13             magic_1.6.1               magick_2.7.4             
  magrittr_2.0.3            mapproj_1.2.11            maps_3.4.1               
  markdown_1.7              MASS_7.3.60               Matrix_1.5.4.1           
  MatrixModels_0.5.1        matrixStats_1.0.0         memoise_2.0.1            
  methods_4.3.1             mgcv_1.8.42               mime_0.12                
  miniUI_0.1.1.1            minqa_1.2.5               modeltools_0.2.23        
  multcomp_1.4.25           munsell_0.5.0             mvtnorm_1.2.2            
  ncvreg_3.14.1             nlme_3.1.162              nloptr_2.0.3             
  nnet_7.3.19               numDeriv_2016.8.1.1       openssl_2.0.6            
  packrat_0.9.1             pals_1.7                  parallel_4.3.1           
  patchwork_1.1.2           pbapply_1.7.0             pbkrtest_0.5.2           
  pdftools_3.3.3            permute_0.9.7             pheatmap_1.0.12          
  pillar_1.9.0              pkgconfig_2.0.3           pkgload_1.3.2            
  plogr_0.2.0               plotly_4.10.2             pls_2.8.2                
  plyr_1.8.8                png_0.1.8                 polyclip_1.10.4          
  praise_1.0.0              prettyunits_1.1.1         pROC_1.18.2              
  processx_3.8.1            productplots_0.1.1        progress_1.2.2           
  promises_1.2.0.1          proxy_0.4.27              ps_1.7.5                 
  purrr_1.0.1               pwr_1.3.0                 qpdf_1.3.2               
  quadprog_1.5.8            quantmod_0.4.23           quantreg_5.95            
  quarto_1.2                R6_2.5.1                  ragg_1.2.5               
  randomForest_4.7.1.1      rappdirs_0.3.3            RColorBrewer_1.1.3       
  Rcpp_1.0.10               RcppArmadillo_0.12.4.1.0  RcppEigen_0.3.3.9.3      
  RcppProgress_0.4.2        RcppTOML_0.2.2            reactable_0.4.4          
  reactR_0.4.4              readr_2.1.4               registry_0.5.1           
  rematch2_2.1.2            remotes_2.4.2             reticulate_1.30          
  Rglpk_0.6.5               rlang_1.1.1               rmarkdown_2.22           
  ROI_1.0.1                 ROI.plugin.ecos_1.0.0     ROI.plugin.glpk_1.0.0    
  ROI.plugin.nloptr_1.0.0   ROI.plugin.quadprog_1.0.0 ROI.plugin.scs_1.1.1     
  rootSolve_1.8.2.3         rpart_4.1.19              rpart.plot_3.1.1         
  rprojroot_2.0.3           rsconnect_0.8.29          RSQLite_2.3.1            
  rstudioapi_0.14           RVenn_1.1.0               rvest_1.0.3              
  s2_1.1.4                  sandwich_3.0.2            sass_0.4.6               
  scales_1.2.1              scs_3.2.4                 selectr_0.4.2            
  sf_1.0.13                 shades_1.4.0              shape_1.4.6              
  shiny_1.7.4               shinyjs_2.1.0             showtext_0.9.6           
  showtextdb_3.0            slam_0.1.50               sm_2.2.5.7.1             
  sourcetools_0.1.7.1       sp_1.6.1                  spaMM_4.3.0              
  SparseM_1.81              spatial_7.3.16            splines_4.3.1            
  stars_0.6.1               stats_4.3.1               stats4_4.3.1             
  stringi_1.7.12            stringr_1.5.0             survival_3.5.5           
  sys_3.4.2                 sysfonts_0.8.8            systemfonts_1.0.4        
  tcltk_4.3.1               terra_1.7.37              testthat_3.1.9           
  textshaping_0.3.6         TH.data_1.1.2             tibble_3.2.1             
  tidycensus_1.4.1          tidygraph_1.2.3           tidyr_1.3.0              
  tidyselect_1.2.0          tigris_2.0.3              tikzDevice_0.12.4        
  tinytex_0.45              titanic_0.1.0             tools_4.3.1              
  treemapify_2.5.5          TSP_1.2.4                 TTR_0.24.3               
  tweenr_2.0.2              tzdb_0.4.0                units_0.8.2              
  utf8_1.2.3                utils_4.3.1               uuid_1.1.0               
  V8_4.3.0                  vcd_1.4.11                vctrs_0.6.3              
  vegan_2.6.4               vioplot_0.4.0             vipor_0.4.5              
  viridis_0.6.3             viridisLite_0.4.2         vroom_1.6.3              
  waldo_0.5.1               webshot2_0.1.0            websocket_1.4.1          
  withr_2.5.0               wk_0.7.3                  xfun_0.39                
  xgboost_1.7.5.1           xml2_1.3.4                xtable_1.8.4             
  xts_0.13.1                yaml_2.3.7                yulab.utils_0.0.6        
  zoo_1.8.12               

Pandoc version: 3.1.1

LaTeX version used: 
  TeX Live 2022 with tlmgr 2022-04-18
```

</details>
