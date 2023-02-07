
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
  ## 黑体
  sysfonts::font_add(
    family = "Noto Sans CJK SC",
    regular = "NotoSansCJKsc-Regular.otf",
    bold = "NotoSansCJKsc-Bold.otf"
  )
} else if (grepl(x = sessionInfo()$running, pattern = "Fedora")) { # Github Action custom Docker Container Based on Fedora
  sysfonts::font_paths(new = c(
    "/usr/share/fonts/google-noto/",
    "/usr/share/fonts/google-noto-cjk/"
  ))
  ## 宋体
  sysfonts::font_add(
    family = "Noto Serif CJK SC",
    regular = "NotoSerifCJK-Regular.ttc",
    bold = "NotoSerifCJK-Bold.ttc"
  )
  ## 黑体
  sysfonts::font_add(
    family = "Noto Sans CJK SC",
    regular = "NotoSansCJK-Regular.ttc",
    bold = "NotoSansCJK-Bold.ttc"
  )
} else { # Github Action Ubuntu
  sysfonts::font_paths(new = c(
    "/usr/share/fonts/opentype/noto/",
    "/usr/share/fonts/truetype/noto/"
  ))
  ## 宋体
  sysfonts::font_add(
    family = "Noto Serif CJK SC",
    regular = "NotoSerifCJK-Regular.ttc",
    bold = "NotoSerifCJK-Bold.ttc"
  )
  ## 黑体
  sysfonts::font_add(
    family = "Noto Sans CJK SC",
    regular = "NotoSansCJK-Regular.ttc",
    bold = "NotoSansCJK-Bold.ttc"
  )
}

## 衬线字体
sysfonts::font_add(
  family = "Noto Serif",
  regular = "NotoSerif-Regular.ttf",
  bold = "NotoSerif-Bold.ttf",
  italic = "NotoSerif-Italic.ttf",
  bolditalic = "NotoSerif-BoldItalic.ttf"
)
## 无衬线字体
sysfonts::font_add(
  family = "Noto Sans",
  regular = "NotoSans-Regular.ttf",
  bold = "NotoSans-Bold.ttf",
  italic = "NotoSans-Italic.ttf",
  bolditalic = "NotoSans-BoldItalic.ttf"
)

# 设置 Web GL 渲染
options(rgl.useNULL = TRUE)
options(rgl.printRglwidget = TRUE)
