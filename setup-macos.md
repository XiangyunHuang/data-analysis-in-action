## 配置 R

安装 R 软件、RStudio 软件、xquartz （X11）和 quarto（排版）工具

``` bash
brew install --cask r rstudio 
brew install --cask xquartz 
brew install quarto # 要求版本不低于 v1.3.450
brew install google-chrome # 用于渲染 mermaid 流程图
```

区域与语言设置

``` bash
defaults write org.R-project.R force.LANG en_US.UTF-8
```

安装 data.table 依赖

``` bash
brew install gcc pkg-config libomp
```

配置 OpenMP 环境变量，从源码安装 data.table 包，多线程并行

``` bash
export LDFLAGS="-L/usr/local/opt/libomp/lib" 
export CPPFLAGS="-I/usr/local/opt/libomp/include"
```

## 配置字体

Noto 宋体和黑体在书中绘图时大量使用

``` bash
brew tap homebrew/cask-fonts 
brew install --cask font-noto-serif-cjk-sc font-noto-sans-cjk-sc
```

## 配置 Python

graphics 入门章节的三维透视图一节，比较 R 包 graphics 与 Python 模块 matplotlib 透视效果。

``` bash
brew install python3 virtualenv 
sudo mkdir -p /opt/.virtualenvs/r-tensorflow 
sudo chown -R $(whoami):staff /opt/.virtualenvs/r-tensorflow 
export RETICULATE_PYTHON_ENV=/opt/.virtualenvs/r-tensorflow 
virtualenv -p /usr/bin/python3 $RETICULATE_PYTHON_ENV 
source /opt/.virtualenvs/r-tensorflow/bin/activate 
pip install -r requirements.txt
```

设置环境变量

``` r
# 设置 Python
Sys.setenv(RETICULATE_PYTHON = "/opt/.virtualenvs/r-tensorflow/bin/python")
Sys.setenv(RETICULATE_PYTHON_ENV = "/opt/.virtualenvs/r-tensorflow")
```

## 配置 CmdStan

贝叶斯建模部分用到 Stan 框架，先下载 cmdstan 软件到本地。

``` bash
sudo mkdir -p /opt/cmdstan 
sudo chown -R $(whoami):staff /opt/cmdstan 
tar -xzf cmdstan-2.33.0.tar.gz -C /opt/cmdstan 
make build -j 4 -C /opt/cmdstan/cmdstan-2.33.0
```

设置环境变量

``` r
Sys.setenv(CMDSTAN="/opt/cmdstan/cmdstan-2.33.0")
```

## 配置 TinyTeX

TikZ 入门章节和编译 PDF 格式书籍都需要 TinyTeX 发行版。

``` r
tinytex::install_tinytex(bundle = 'TinyTeX-2') 
```

## 配置 matplotlib

给绘图模块 matplotlib 设置 PGF 图形渲染后端，将输出文件 PDF 转化为 PNG 格式需要软件 ghostscript。

``` bash
brew install ghostscript
```

## 配置 R 包

``` r
tmp <- desc::desc_get_deps()
xfun::session_info(packages = tmp[tmp$type == "Imports","package"], dependencies = F)
```

``` markdown
R version 4.3.1 (2023-06-16)
Platform: x86_64-apple-darwin20 (64-bit)
Running under: macOS Ventura 13.5.2, RStudio 2023.6.2.561


Locale: en_US.UTF-8 / en_US.UTF-8 / en_US.UTF-8 / C / en_US.UTF-8 / en_US.UTF-8

time zone: Asia/Shanghai
tzcode source: internal

Package version:
  abess_0.4.7               bayesplot_1.10.0          BB_2019.10-1             
  beanplot_1.3.1            broom_1.0.5               car_3.1-2                
  cmdstanr_0.6.1            coin_1.4-2                data.table_1.14.8        
  datasauRus_0.1.6          dbplyr_2.3.3              downlit_0.4.3            
  dplyr_1.1.3               DT_0.29                   dunn.test_1.3.5          
  dygraphs_1.1.1.6          e1071_1.7-13              ECOSolveR_0.5.5          
  expm_0.999-7              fastmatrix_0.5            fmesher_0.1.2            
  GA_3.2.3                  geodata_0.5-8             ggalluvial_0.12.5        
  gganimate_1.0.8           ggbeeswarm_0.7.2          ggbump_0.1.99999         
  ggdensity_1.0.0           ggeffects_1.3.1           ggExtra_0.10.1           
  ggforce_0.4.1             ggfortify_0.4.16          ggmosaic_0.3.3           
  ggnewscale_0.4.9          ggplot2_3.4.3             ggraph_2.1.0             
  ggrepel_0.9.3             ggridges_0.5.4            ggsignif_0.6.4           
  ggstats_0.4.0             ggTimeSeries_1.0.2        ggVennDiagram_1.2.3      
  ggwordcloud_0.5.0         gifski_1.12.0-2           GLMMadaptive_0.9-0       
  glmnet_4.1-8              gt_0.9.0                  hexbin_1.28.3            
  HistData_0.9-1            INLA_23.08.26             kernlab_0.9-32           
  knitr_1.44                lars_1.3                  latticeExtra_0.6-30      
  lme4_1.1-34               loo_2.6.0                 lvplot_0.2.1             
  magick_2.7.5              maps_3.4.1                misc3d_0.9-1             
  ncvreg_3.14.1             nloptr_2.0.3              pals_1.8                 
  patchwork_1.1.3           pdftools_3.3.3            plot2_0.0.3.9010         
  plot3D_1.4                plotly_4.10.2             pls_2.8-2                
  pROC_1.18.4               purrr_1.0.2               pwr_1.3-0                
  quadprog_1.5-8            quantmod_0.4.25           ragg_1.2.5               
  randomForest_4.7-1.1      reticulate_1.32.0         ROI_1.0-1                
  ROI.plugin.ecos_1.0-2     ROI.plugin.glpk_1.0-0     ROI.plugin.nloptr_1.0-1  
  ROI.plugin.quadprog_1.0-1 ROI.plugin.scs_1.1-2      rootSolve_1.8.2.3        
  rpart.plot_3.1.1          RSQLite_2.3.1             scs_3.2.4                
  sf_1.0-14                 showtext_0.9-6            spaMM_4.4.0              
  splancs_2.01-44           stars_0.6-4               tidycensus_1.4.4         
  tidygraph_1.2.3           tikzDevice_0.12.5         titanic_0.1.0            
  treemapify_2.5.5          TSP_1.2-4                 vcd_1.4-11               
  vioplot_0.4.0             webshot2_0.1.1            xgboost_1.7.5.1          
  xml2_1.3.5                xts_0.13.1
```
