# On CI connect to server, using API KEY and deploy using appId
rsconnect::addServer(url = "https://bookdown.org/", name = "quarto")
rsconnect::connectApiUser(
  account = "xiangyun", server = "quarto",
  apiKey = Sys.getenv("CONNECT_API_KEY")
)
## TODO: rsconnect 1.0.0 发布后使用 deploySite 部署
# rsconnect::deploySite(
#   siteName = "data-analysis-in-action",
#   siteTitle = "Data Analysis in Action",
#   server = "quarto", account = "xiangyun",
#   render = "none"
# )
## TODO: rsconnect 1.0.0 发布后去掉下面的部署代码
rsconnect::addServer(url = "https://bookdown.org/__api__/", name = "quarto")
rsconnect::deployApp(
  appDir = "_book",
  appId = Sys.getenv("CONTENT_ID"),
  contentCategory = "site",
  appName = "data-analysis-in-action",
  appTitle = "Data Analysis in Action",
  server = "quarto", account = "xiangyun",
  forceUpdate = TRUE
)
