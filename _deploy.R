# On CI connect to server, using API KEY and deploy using appId
rsconnect::addServer(url = "https://bookdown.org/", name = "quarto")
rsconnect::connectApiUser(
  account = "xiangyun", server = "quarto",
  apiKey = Sys.getenv("CONNECT_API_KEY")
)
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
