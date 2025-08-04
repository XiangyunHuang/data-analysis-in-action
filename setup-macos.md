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
R version 4.5.1 (2025-06-13)
Platform: aarch64-apple-darwin20
Running under: macOS Sequoia 15.5, RStudio 2025.5.1.513

Locale: en_US.UTF-8 / en_US.UTF-8 / en_US.UTF-8 / C / en_US.UTF-8 / en_US.UTF-8

Package version:
  BB_2019.10.1              broom_1.0.9               car_3.1.3                
  coin_1.4.3                data.table_1.17.8         datasauRus_0.1.9         
  dbplyr_2.5.0              downlit_0.4.4             dplyr_1.1.4              
  DT_0.33                   dunn.test_1.3.6           dygraphs_1.1.1.6         
  e1071_1.7.16              ECOSolveR_0.5.5           GA_3.2.4                 
  ggalluvial_0.12.5         gganimate_1.0.10          ggfortify_0.4.19         
  ggplot2_3.5.2.9002        ggraph_2.2.1              ggrepel_0.9.6            
  ggridges_0.5.6            ggstats_0.10.0            ggwordcloud_0.6.2        
  gifski_1.32.0.2           glmnet_4.1.10             gt_1.0.0                 
  hexbin_1.28.5             HistData_0.9.3            kernlab_0.9.33           
  knitr_1.50                latticeExtra_0.6.30       lvplot_0.2.1             
  magick_2.8.7              maps_3.4.3                misc3d_0.9.1             
  nloptr_2.2.1              nomnoml_0.3.0             patchwork_1.3.1          
  pdftools_3.5.0            plot3D_1.4.2              plotly_4.11.0            
  pROC_1.19.0.1             purrr_1.1.0               pwr_1.3.0                
  quadprog_1.5.8            quanteda_4.3.1            quantmod_0.4.28          
  ragg_1.4.0                readxl_1.4.5              ROI_1.0.1                
  ROI.plugin.ecos_1.0.2     ROI.plugin.glpk_1.0.0     ROI.plugin.nloptr_1.0.1  
  ROI.plugin.quadprog_1.0.1 ROI.plugin.scs_1.1.2      rootSolve_1.8.2.4        
  RSQLite_2.4.2             scs_3.2.7                 shiny_1.11.1             
  showtext_0.9.7            spacyr_1.3.0              text2vec_0.6.4           
  tidygraph_1.3.1           tikzDevice_0.12.6         titanic_0.1.0            
  treemapify_2.5.6          TSP_1.2.5                 vcd_1.4.13               
  visNetwork_2.1.2          webshot2_0.1.2            xml2_1.3.8               
  xts_0.14.1        
```
