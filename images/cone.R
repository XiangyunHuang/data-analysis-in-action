# 用 magick 将 pdf 格式图片转化为 png 格式
to_png <- function(fig_path) {
  png_path <- sub("\\.pdf$", ".png", fig_path)
  magick::image_write(magick::image_read_pdf(fig_path),
                      format = "png", path = png_path,
                      density = 300, quality = 100
  )
  return(png_path)
}
# 转化图片
to_png(fig_path = "images/cone.pdf")
# 优化压缩图片
xfun::tinify("images/cone.png")
