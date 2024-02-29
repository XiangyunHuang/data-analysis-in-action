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
R version 4.3.2 (2023-10-31)
Platform: x86_64-apple-darwin20 (64-bit)
Running under: macOS Sonoma 14.3, RStudio 2023.12.1.402

Locale: en_US.UTF-8 / en_US.UTF-8 / en_US.UTF-8 / C / en_US.UTF-8 / en_US.UTF-8

Package version:
  abess_0.4.8               abind_1.4.5               admisc_0.34              
  ape_5.7.1                 aplot_0.2.2               AsioHeaders_1.22.1.2     
  askpass_1.2.0             backports_1.4.1           base64enc_0.1.3          
  bayesplot_1.11.0          BB_2019.10-1              beanplot_1.3.1           
  beeswarm_0.4.0            BH_1.84.0-0               bigD_0.2.0               
  bit_4.0.5                 bit64_4.0.5               bitops_1.0.7             
  blme_1.0-5                blob_1.2.4                boot_1.3.28.1            
  bridgesampling_1.1.2      brio_1.1.4                brms_2.20.4              
  Brobdingnag_1.2.9         broom_1.0.5               broom.helpers_1.14.0     
  bslib_0.6.1               cachem_1.0.8              callr_3.7.3              
  car_3.1-2                 carData_3.0.5             checkmate_2.3.1          
  chromote_0.1.2            class_7.3.22              classInt_0.4.10          
  cli_3.6.2                 clipr_0.8.0               cluster_2.1.6            
  cmdstanr_0.7.1            coda_0.19.4.1             codetools_0.2.19         
  coin_1.4-3                colorspace_2.1.0          colourpicker_1.3.0       
  commonmark_1.9.1          compiler_4.3.2            config_0.3.2             
  corpcor_1.6.10            corrplot_0.92             cowplot_1.1.3            
  cpp11_0.4.7               crayon_1.5.2              crosstalk_1.2.1          
  cubature_2.1.0            curl_5.2.0                cvar_0.5                 
  data.table_1.15.0         datasauRus_0.1.6          DBI_1.2.1                
  dbplyr_2.4.0              deldir_2.0.2              desc_1.4.3               
  diffobj_0.3.5             digest_0.6.34             distributional_0.3.2     
  dotCall64_1.1.1           downlit_0.4.3             dplyr_1.1.4              
  DT_0.31                   dunn.test_1.3.5           dygraphs_1.1.1.6         
  e1071_1.7-14              ECOSolveR_0.5.5           ellipsis_0.3.2           
  evaluate_0.23             expm_0.999-9              fansi_1.0.6              
  farver_2.1.1              fastICA_1.2.4             fastmap_1.1.1            
  fastmatrix_0.5-772        fBasics_4032.96           fGarch_4031.90           
  filehash_2.4.5            float_0.3.2               fmesher_0.1.5            
  fontawesome_0.5.2         forcats_1.0.0             foreach_1.5.2            
  foreign_0.8.86            Formula_1.2.5             FRK_2.2.1                
  fs_1.6.3                  future_1.33.1             GA_3.2.4                 
  gamm4_0.2.6               gbutils_0.5               generics_0.1.3           
  geodata_0.5-9             geometry_0.4.7            ggalluvial_0.12.5        
  gganimate_1.0.8           ggbeeswarm_0.7.2          ggbump_0.1.99999         
  ggdensity_1.0.0           ggeffects_1.3.4           ggExtra_0.10.1           
  ggfittext_0.10.2          ggforce_0.4.1             ggfortify_0.4.16         
  ggfun_0.1.4               ggmosaic_0.3.3            ggnewscale_0.4.9         
  ggplot2_3.5.0             ggplotify_0.1.2           ggpubr_0.6.0             
  ggraph_2.1.0.9000         ggrepel_0.9.5             ggridges_0.5.6           
  ggsci_3.0.0               ggsignif_0.6.4            ggstats_0.5.1            
  ggstream_0.1.0            ggthemes_5.0.0            ggTimeSeries_1.0.2       
  ggVennDiagram_1.5.0       ggwordcloud_0.6.1         gifski_1.12.0-2          
  GLMMadaptive_0.9-1        glmmTMB_1.1.8             glmnet_4.1-8             
  globals_0.16.2            glue_1.7.0                gmp_0.7.4                
  goftest_1.2.3             graphics_4.3.2            graphlayouts_1.1.0       
  grDevices_4.3.2           grid_4.3.2                gridExtra_2.3            
  gridGraphics_0.5.1        gridtext_0.1.5            gss_2.2.7                
  gt_0.10.1                 gtable_0.3.4              gtools_3.9.5             
  haven_2.5.4               here_1.0.1                hexbin_1.28.3            
  hglm_2.2-1                hglm.data_1.0.1           highr_0.10               
  HistData_0.9-1            Hmisc_5.1.1               hms_1.1.3                
  htmlTable_2.4.2           htmltools_0.5.7           htmlwidgets_1.6.4        
  httpuv_1.6.14             httr_1.4.7                igraph_2.0.1.1           
  INLA_24.01.20             inline_0.3.19             insight_0.19.8           
  interp_1.1.6              intervals_0.15.4          isoband_0.2.7            
  iterators_1.0.14          jiebaR_0.11               jiebaRD_0.1              
  jpeg_0.1.10               jquerylib_0.1.4           jsonlite_1.8.8           
  juicyjuice_0.1.0          keras_2.13.0              kernlab_0.9-32           
  KernSmooth_2.23.22        knitr_1.45                labeling_0.4.3           
  labelled_2.12.0           lars_1.3                  later_1.3.2              
  lattice_0.22.5            latticeExtra_0.6-30       lavaan_0.6-17            
  lazyeval_0.2.2            lgr_0.4.4                 libcoin_1.0.10           
  lifecycle_1.0.4           linprog_0.9.4             listenv_0.9.1            
  lme4_1.1-35.1             lmtest_0.9.40             loo_2.6.0                
  lpSolve_5.6.20            lvplot_0.2.1              magic_1.6.1              
  magick_2.8.2              magrittr_2.0.3            maps_3.4.2               
  markdown_1.12             MASS_7.3.60.0.1           Matrix_1.6.5             
  MatrixExtra_0.1.15        MatrixModels_0.5.3        matrixStats_1.2.0        
  mclogit_0.9.6             MCMCglmm_2.35             memisc_0.99.31.7         
  memoise_2.0.1             methods_4.3.2             mgcv_1.9.1               
  mime_0.12                 miniUI_0.1.1.1            minqa_1.2.6              
  misc3d_0.9-1              mlapi_0.1.1               mnormt_2.1.1             
  modeltools_0.2.23         multcomp_1.4.25           munsell_0.5.0            
  mvtnorm_1.2.4             ncvreg_3.14.1             nleqslv_3.3.5            
  nlme_3.1.164              nloptr_2.0.3              nnet_7.3.19              
  nomnoml_0.3.0             numDeriv_2016.8.1.1       openssl_2.1.1            
  ordinal_2023.12.4         parallel_4.3.2            parallelly_1.36.0        
  patchwork_1.2.0           pbapply_1.7.2             pbivnorm_0.6.0           
  pbkrtest_0.5.2            pdftools_3.4.0            pillar_1.9.0             
  pkgbuild_1.4.3            pkgconfig_2.0.3           pkgload_1.3.4            
  plogr_0.2.0               plot2_0.0.4               plot3D_1.4               
  plotly_4.10.4             pls_2.8-3                 plyr_1.8.9               
  png_0.1.8                 polyclip_1.10.6           polynom_1.4.1            
  posterior_1.5.0           praise_1.0.0              prettyunits_1.2.0        
  pROC_1.18.5               processx_3.8.3            productplots_0.1.1       
  progress_1.2.3            projpred_2.8.0            promises_1.2.1           
  proxy_0.4.27              ps_1.7.6                  purrr_1.0.2              
  pwr_1.3-0                 qpdf_1.3.2                quadprog_1.5-8           
  quantmod_0.4.25           quantreg_5.97             QuickJSR_1.1.3           
  R6_2.5.1                  ragg_1.2.7                randomForest_4.7-1.1     
  rappdirs_0.3.3            rbibutils_2.2.16          RColorBrewer_1.1.3       
  Rcpp_1.0.12               RcppArmadillo_0.12.6.6.1  RcppEigen_0.3.3.9.4      
  RcppParallel_5.1.7        RcppProgress_0.4.2        RcppTOML_0.2.2           
  Rdpack_2.6                reactable_0.4.4           reactR_0.5.0             
  readr_2.1.5               registry_0.5.1            rematch2_2.1.2           
  reshape2_1.4.4            reticulate_1.35.0         Rglpk_0.6.5.1            
  RhpcBLASctl_0.23.42       rjags_4-15                rlang_1.1.3              
  rmarkdown_2.25            ROI_1.0-1                 ROI.plugin.ecos_1.0-2    
  ROI.plugin.glpk_1.0-0     ROI.plugin.nloptr_1.0-1   ROI.plugin.quadprog_1.0-1
  ROI.plugin.scs_1.1-2      rootSolve_1.8.2.4         rpart_4.1.23             
  rpart.plot_3.1.1          rprojroot_2.0.4           rsparse_0.5.1            
  RSQLite_2.3.5             rstan_2.32.5              rstantools_2.4.0         
  rstatix_0.7.2             rstudioapi_0.15.0         rvest_1.0.3              
  s2_1.1.6                  sandwich_3.1.0            sass_0.4.8               
  scales_1.3.0              scs_3.2.4                 selectr_0.4.2            
  sf_1.0-15                 shades_1.4.0              shape_1.4.6              
  shiny_1.8.0               shinyjs_2.1.0             shinystan_2.6.0          
  shinythemes_1.2.0         showtext_0.9-6            showtextdb_3.0           
  slam_0.1.50               sm_2.2.5.7.1              sourcetools_0.1.7.1      
  sp_2.1.3                  spacetime_1.3.1           spacyr_1.3.0             
  spam_2.10.0               spaMM_4.4.16              sparseinv_0.1.3          
  SparseM_1.81              spatial_7.3.17            spatstat_3.0-7           
  spatstat.data_3.0.4       spatstat.explore_3.2.5    spatstat.geom_3.2.8      
  spatstat.linnet_3.1.3     spatstat.model_3.2.8      spatstat.random_3.2.2    
  spatstat.sparse_3.0.3     spatstat.utils_3.0.4      spData_2.3.0             
  spdep_1.3-1               splancs_2.01-44           splines_4.3.2            
  stabledist_0.7.1          StanHeaders_2.32.5        stars_0.6-4              
  statmod_1.5.0             stats_4.3.2               stats4_4.3.2             
  stringi_1.8.3             stringr_1.5.1             survival_3.5.7           
  sys_3.4.2                 sysfonts_0.8.8            systemfonts_1.0.5        
  tcltk_4.3.2               tensor_1.5                tensorA_0.36.2.1         
  tensorflow_2.15.0         terra_1.7.71              testthat_3.2.1           
  text2vec_0.6.4            textshaping_0.3.7         tfautograph_0.3.2        
  tfruns_1.5.2              TH.data_1.1.2             threejs_0.3.3            
  tibble_3.2.1              tidycensus_1.6            tidygraph_1.3.1          
  tidyr_1.3.1               tidyselect_1.2.0          tigris_2.1               
  tikzDevice_0.12.6         timeDate_4032.109         timeSeries_4032.109      
  tinytex_0.49              titanic_0.1.0             TMB_1.9.10               
  tools_4.3.2               treemapify_2.5.6          TSP_1.2-4                
  TTR_0.24.4                tweenr_2.0.2              tzdb_0.4.0               
  ucminf_1.2.1              units_0.8.5               utf8_1.2.4               
  utils_4.3.2               uuid_1.2.0                V8_4.4.1                 
  vcd_1.4-12                vctrs_0.6.5               venn_1.12                
  VGAM_1.1-9                vioplot_0.4.0             vipor_0.4.7              
  viridis_0.6.5             viridisLite_0.4.2         visNetwork_2.1.2         
  vroom_1.6.5               waldo_0.5.2               webshot2_0.1.1           
  websocket_1.4.1           whisker_0.4.1             withr_3.0.0              
  wk_0.9.1                  xfun_0.41                 xgboost_1.7.7.1          
  xml2_1.3.6                xtable_1.8.4              xts_0.13.2               
  yaml_2.3.8                yulab.utils_0.1.4         zeallot_0.1.0            
  zoo_1.8.13
```

</details>
