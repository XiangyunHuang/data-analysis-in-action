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
-   数据交流
    -   交互图形
    -   交互表格
    -   HTML 文档
    -   PDF 文档
-   统计分析
    -   常见的统计检验
-   数据建模
    -   预测核辐射强度的分布
-   优化建模
    -   统计计算
    -   数值优化
    -   优化问题
-   贝叶斯建模
    -   概率推理框架
    -   广义线性模型
    -   分层正态模型
    -   混合效应模型
    -   广义可加模型
    -   高斯过程回归
-   机器学习
    -   分类问题
    -   回归问题
-   附录
    -   数学符号
    -   矩阵运算
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
docker pull ghcr.io/xiangyunhuang/fedora-rstudio-pro:1.4.504
# 进入项目目录
cd ~/Documents/data-analysis-in-action
# 启动容器
docker run -itd -p 8484:8787 --name=daar \
  --privileged=true -v "/${PWD}:/home/docker" \
  ghcr.io/xiangyunhuang/fedora-rstudio-pro:1.4.504
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
R version 4.3.2 (2023-10-31)
Platform: x86_64-redhat-linux-gnu (64-bit)
Running under: Fedora Linux 39 (Container Image), RStudio 2023.9.1.494

Locale:
  LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
  LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
  LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
  LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

Package version:
  abess_0.4.8               abind_1.4.5               ape_5.7.1                
  AsioHeaders_1.22.1.2      askpass_1.2.0             backports_1.4.1          
  base_4.3.2                base64enc_0.1.3           bayesplot_1.10.0         
  BB_2019.10.1              beanplot_1.3.1            beeswarm_0.4.0           
  BH_1.81.0.1               bigD_0.2.0                bit_4.0.5                
  bit64_4.0.5               bitops_1.0.7              blme_1.0.5               
  blob_1.2.4                boot_1.3.28.1             bridgesampling_1.1.2     
  brio_1.1.3                brms_2.20.4               Brobdingnag_1.2.9        
  broom_1.0.5               broom.helpers_1.14.0      bslib_0.5.1              
  cachem_1.0.8              callr_3.7.3               car_3.1.2                
  carData_3.0.5             checkmate_2.3.0           chromote_0.1.2           
  class_7.3.22              classInt_0.4.10           cli_3.6.1                
  clipr_0.8.0               cluster_2.1.4             cmdstanr_0.6.1           
  coda_0.19.4               codetools_0.2.19          coin_1.4.3               
  colorspace_2.1.0          colourpicker_1.3.0        commonmark_1.9.0         
  compiler_4.3.2            CoprManager_0.5.5         corpcor_1.6.10           
  corrplot_0.92             cowplot_1.1.1             cpp11_0.4.6              
  crayon_1.5.2              crosstalk_1.2.0           cubature_2.1.0           
  curl_5.1.0                data.table_1.14.8         datasauRus_0.1.6         
  datasets_4.3.2            DBI_1.1.3                 dbplyr_2.4.0             
  deldir_1.0.9              desc_1.4.2                dichromat_2.0.0.1        
  diffobj_0.3.5             digest_0.6.33             distributional_0.3.2     
  docopt_0.7.1              dotCall64_1.1.0           downlit_0.4.3            
  dplyr_1.1.4               DT_0.30                   dunn.test_1.3.5          
  dygraphs_1.1.1.6          e1071_1.7.13              ECOSolveR_0.5.5          
  ellipsis_0.3.2            evaluate_0.23             expm_0.999.7             
  fansi_1.0.5               farver_2.1.1              fastmap_1.1.1            
  fastmatrix_0.5.7          filehash_2.4.5            fmesher_0.1.4            
  fontawesome_0.5.2         forcats_1.0.0             foreach_1.5.2            
  foreign_0.8.85            Formula_1.2.5             FRK_2.2.0                
  fs_1.6.3                  future_1.33.0             GA_3.2.3                 
  gamm4_0.2.6               generics_0.1.3            geodata_0.5.9            
  geometry_0.4.7            ggalluvial_0.12.5         gganimate_1.0.8          
  ggbeeswarm_0.7.2          ggbump_0.1.99999          ggdensity_1.0.0          
  ggeffects_1.3.2           ggExtra_0.10.1            ggfittext_0.10.1         
  ggforce_0.4.1             ggfortify_0.4.16          ggmosaic_0.3.3           
  ggnewscale_0.4.9          ggplot2_3.4.4             ggpubr_0.6.0             
  ggraph_2.1.0              ggrepel_0.9.4             ggridges_0.5.4           
  ggsci_3.0.0               ggsignif_0.6.4            ggstats_0.5.1            
  ggstream_0.1.0            ggsurvfit_1.0.0           ggTimeSeries_1.0.2       
  ggVennDiagram_1.2.3       ggwordcloud_0.6.1         gifski_1.12.0.2          
  GLMMadaptive_0.9.1        glmmTMB_1.1.8             glmnet_4.1.8             
  globals_0.16.2            glue_1.6.2                gmp_0.7.2                
  goftest_1.2.3             graphics_4.3.2            graphlayouts_1.0.2       
  grDevices_4.3.2           grid_4.3.2                gridExtra_2.3            
  gridtext_0.1.5            gt_0.10.0                 gtable_0.3.4             
  gtools_3.9.5              haven_2.5.3               here_1.0.1               
  hexbin_1.28.3             hglm_2.2.1                hglm.data_1.0.1          
  highr_0.10                HistData_0.9.1            Hmisc_5.1.1              
  hms_1.1.3                 htmlTable_2.4.2           htmltools_0.5.7          
  htmlwidgets_1.6.2         httpuv_1.6.12             httr_1.4.7               
  igraph_1.5.1              INLA_23.9.9               inline_0.3.19            
  insight_0.19.6            interp_1.1.4              intervals_0.15.4         
  isoband_0.2.7             iterators_1.0.14          jpeg_0.1.10              
  jquerylib_0.1.4           jsonlite_1.8.7            juicyjuice_0.1.0         
  kernlab_0.9.32            KernSmooth_2.23.22        knitr_1.45               
  labeling_0.4.3            labelled_2.12.0           lars_1.3                 
  later_1.3.1               lattice_0.22.5            latticeExtra_0.6.30      
  lavaan_0.6.16             lazyeval_0.2.2            libcoin_1.0.10           
  lifecycle_1.0.4           linprog_0.9.4             listenv_0.9.0            
  littler_0.3.18            lme4_1.1.35.1             lmtest_0.9.40            
  loo_2.6.0                 lpSolve_5.6.19            lvplot_0.2.1             
  magic_1.6.1               magick_2.8.1              magrittr_2.0.3           
  mapproj_1.2.11            maps_3.4.1.1              markdown_1.11            
  MASS_7.3.60               Matrix_1.6.3              MatrixModels_0.5.3       
  matrixStats_1.1.0         mclogit_0.9.6             MCMCglmm_2.35            
  memisc_0.99.31.6          memoise_2.0.1             methods_4.3.2            
  mgcv_1.9.0                mime_0.12                 miniUI_0.1.1.1           
  minqa_1.2.6               misc3d_0.9.1              mnormt_2.1.1             
  modeltools_0.2.23         multcomp_1.4.25           munsell_0.5.0            
  mvtnorm_1.2.3             ncvreg_3.14.1             nleqslv_3.3.4            
  nlme_3.1.163              nloptr_2.0.3              nnet_7.3.19              
  nomnoml_0.3.0             numDeriv_2016.8.1.1       openssl_2.1.1            
  ordinal_2022.11.16        packrat_0.9.2             pals_1.8                 
  parallel_4.3.2            parallelly_1.36.0         patchwork_1.1.3          
  pbapply_1.7.2             pbivnorm_0.6.0            pbkrtest_0.5.2           
  pdftools_3.4.0            permute_0.9.7             pheatmap_1.0.12          
  pillar_1.9.0              pkgbuild_1.4.2            pkgconfig_2.0.3          
  pkgload_1.3.3             plogr_0.2.0               plot2_0.0.3.9011         
  plot3D_1.4                plotly_4.10.3             pls_2.8.3                
  plyr_1.8.9                png_0.1.8                 polyclip_1.10.6          
  polynom_1.4.1             posterior_1.5.0           praise_1.0.0             
  prettyunits_1.2.0         pROC_1.18.5               processx_3.8.2           
  productplots_0.1.1        progress_1.2.2            projpred_2.7.0           
  promises_1.2.1            proxy_0.4.27              ps_1.7.5                 
  purrr_1.0.2               pwr_1.3.0                 qpdf_1.3.2               
  quadprog_1.5.8            quantmod_0.4.25           quantreg_5.97            
  quarto_1.3                QuickJSR_1.0.7            R6_2.5.1                 
  ragg_1.2.6                randomForest_4.7.1.1      rappdirs_0.3.3           
  RColorBrewer_1.1.3        Rcpp_1.0.11               RcppArmadillo_0.12.6.6.0 
  RcppEigen_0.3.3.9.4       RcppParallel_5.1.7        RcppProgress_0.4.2       
  RcppTOML_0.2.2            reactable_0.4.4           reactR_0.5.0             
  readr_2.1.4               registry_0.5.1            rematch2_2.1.2           
  remotes_2.4.2.1           renv_1.0.3                reshape2_1.4.4           
  reticulate_1.34.0         Rglpk_0.6.5               rjags_4.14               
  rlang_1.1.2               rmarkdown_2.25            ROI_1.0.1                
  ROI.plugin.ecos_1.0.2     ROI.plugin.glpk_1.0.0     ROI.plugin.nloptr_1.0.1  
  ROI.plugin.quadprog_1.0.1 ROI.plugin.scs_1.1.2      rootSolve_1.8.2.4        
  rpart_4.1.21              rpart.plot_3.1.1          rprojroot_2.0.4          
  rsconnect_1.1.1           RSQLite_2.3.3             rstan_2.32.3             
  rstanarm_2.26.1           rstantools_2.3.1.1        rstatix_0.7.2            
  rstudioapi_0.15.0         RVenn_1.1.0               rvest_1.0.3              
  s2_1.1.4                  sandwich_3.0.2            sass_0.4.7               
  scales_1.2.1              scs_3.2.4                 selectr_0.4.2            
  sf_1.0.14                 shades_1.4.0              shape_1.4.6              
  shiny_1.8.0               shinyjs_2.1.0             shinystan_2.6.0          
  shinythemes_1.2.0         showtext_0.9.6            showtextdb_3.0           
  slam_0.1.50               sm_2.2.5.7.1              sourcetools_0.1.7.1      
  sp_2.1.1                  spacetime_1.3.0           spam_2.10.0              
  spaMM_4.4.0               sparseinv_0.1.3           SparseM_1.81             
  spatial_7.3.17            spatstat_3.0.7            spatstat.data_3.0.3      
  spatstat.explore_3.2.5    spatstat.geom_3.2.7       spatstat.linnet_3.1.3    
  spatstat.model_3.2.8      spatstat.random_3.2.1     spatstat.sparse_3.0.3    
  spatstat.utils_3.0.4      spData_2.3.0              spdep_1.2.8              
  splancs_2.1.44            splines_4.3.2             StanHeaders_2.32.2       
  stars_0.6.4               statmod_1.5.0             stats_4.3.2              
  stats4_4.3.2              stringi_1.8.1             stringr_1.5.1            
  survival_3.5.7            sys_3.4.2                 sysfonts_0.8.8           
  systemfonts_1.0.5         tcltk_4.3.2               tensor_1.5               
  tensorA_0.36.2            terra_1.7.55              testthat_3.2.0           
  textshaping_0.3.7         TH.data_1.1.2             threejs_0.3.3            
  tibble_3.2.1              tidycensus_1.5            tidygraph_1.2.3          
  tidyr_1.3.0               tidyselect_1.2.0          tigris_2.0.4             
  tikzDevice_0.12.5         tinytex_0.48              titanic_0.1.0            
  TMB_1.9.6                 tools_4.3.2               treemapify_2.5.6         
  TSP_1.2.4                 TTR_0.24.3                tweenr_2.0.2             
  tzdb_0.4.0                ucminf_1.2.0              units_0.8.4              
  utf8_1.2.4                utils_4.3.2               uuid_1.1.1               
  V8_4.4.0                  vcd_1.4.11                vctrs_0.6.4              
  vegan_2.6.4               VGAM_1.1.9                vioplot_0.4.0            
  vipor_0.4.5               viridis_0.6.4             viridisLite_0.4.2        
  vroom_1.6.4               waldo_0.5.2               webshot2_0.1.1           
  websocket_1.4.1           withr_2.5.2               wk_0.9.0                 
  xfun_0.41                 xgboost_1.7.5.1           xml2_1.3.5               
  xtable_1.8.4              xts_0.13.1                yaml_2.3.7               
  yulab.utils_0.1.0         zoo_1.8.12               

Pandoc version: 3.1.9

LaTeX version used: 
  TeX Live 2023 with tlmgr 2023-03-08
```

</details>
