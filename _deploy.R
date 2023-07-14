# On CI connect to server, using API KEY and deploy using appId
rsconnect::addServer(url = "https://bookdown.org/", name = "quarto")
rsconnect::connectApiUser(
  account = "xiangyun", server = "quarto",
  apiKey = Sys.getenv("CONNECT_API_KEY")
)
rsconnect::addServer(url = "https://bookdown.org/__api__/", name = "quarto")
quarto::quarto_publish_site(
  name = "data-analysis-in-action", render = "none",
  server = "quarto", account = "xiangyun",
  title = "Data Analysis in Action"
)
