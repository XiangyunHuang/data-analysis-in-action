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

if (grepl(x = sessionInfo()$running, pattern = "macOS")) {
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
    "/usr/share/fonts/google-noto-serif-cjk-fonts" # Fedora 39
  ))
  ## 宋体
  sysfonts::font_add(
    family = "Noto Serif CJK SC",
    regular = "NotoSerifCJK-Regular.ttc",
    bold = "NotoSerifCJK-Bold.ttc"
  )
} else if (grepl(x = sessionInfo()$running, pattern = "Rocky")) {
  sysfonts::font_paths(new = c(
    "/usr/share/fonts/google-noto-cjk/" # Rocky Linux 9
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
} else { # Ubuntu
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

# 设置 Web GL 渲染
options(rgl.useNULL = TRUE)
options(rgl.printRglwidget = TRUE)

# tinytex 不要自动安装宏包
options(tinytex.install_packages = FALSE)
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

# 设置 Python
Sys.setenv(RETICULATE_PYTHON = "/opt/.virtualenvs/r-tensorflow/bin/python")
Sys.setenv(RETICULATE_PYTHON_ENV = "/opt/.virtualenvs/r-tensorflow")
