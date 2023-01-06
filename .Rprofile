# Github Action 需要
if (file.exists("~/.Rprofile") & identical(Sys.getenv("CI"), "true")) sys.source("~/.Rprofile", envir = environment())

# 设置 Web GL 渲染
options(rgl.useNULL = TRUE)
options(rgl.printRglwidget = TRUE)
