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

options(
  tinytex.engine = "xelatex",
  tikzDefaultEngine = "xetex",
  tikzDocumentDeclaration = "\\documentclass[tikz]{standalone}\n",
  tikzXelatexPackages = c(
    "\\usepackage[fontset=fandol]{ctex}",
    "\\usepackage{amsfonts,mathrsfs,amssymb}\n"
  )
)
# 用 magick 将 pdf 格式图片转化为 png 格式
to_png <- function(fig_path) {
  png_path <- sub("\\.pdf$", ".png", fig_path)
  magick::image_write(magick::image_read_pdf(fig_path),
                      format = "png", path = png_path,
                      density = 300, quality = 100
  )
  return(png_path)
}
