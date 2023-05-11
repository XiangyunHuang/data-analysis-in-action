knitr::knit_hooks$set(par = function(before, options, envir) {
  if (before && options$fig.show != "none") {
    par(
      mar = c(4, 4, .5, .5)
    )
  }
})

knitr::opts_chunk$set(
  comment = "#>"
)

if (xfun::is_macos()) {
  # 准备 Noto 中英文字体
  sysfonts::font_paths(new = "~/Library/Fonts/")
  ## 宋体
  sysfonts::font_add(
    family = "Noto Serif CJK SC",
    regular = "NotoSerifCJKsc-Regular.otf",
    bold = "NotoSerifCJKsc-Bold.otf"
  )
} else { # Github Action custom Docker Container Based on Fedora
  sysfonts::font_paths(new = c(
    "/usr/share/fonts/google-noto-serif-cjk-fonts" # Fedora 38
  ))
  ## 宋体
  sysfonts::font_add(
    family = "Noto Serif CJK SC",
    regular = "NotoSerifCJK-Regular.ttc",
    bold = "NotoSerifCJK-Bold.ttc"
  )
}

# 设置 Web GL 渲染
options(rgl.useNULL = TRUE)
options(rgl.printRglwidget = TRUE)
