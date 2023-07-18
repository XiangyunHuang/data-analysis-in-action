# On CI connect to server, using API KEY and deploy using appId
rsconnect::addServer(url = "https://bookdown.org/", name = "quarto")
rsconnect::connectApiUser(
  account = "xiangyun", server = "quarto",
  apiKey = Sys.getenv("CONNECT_API_KEY")
)
rsconnect::deploySite(
  siteName = "data-analysis-in-action",
  siteTitle = "Data Analysis in Action",
  server = "quarto", account = "xiangyun",
  render = "none"
)
