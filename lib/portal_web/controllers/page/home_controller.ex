defmodule PortalWeb.Page.HomeController do
  use PortalWeb, :controller

  alias Portal.Contents

  def index(conn, _params) do
    # 只拿已发布的内容
    contents = Contents.list_published()
    render(conn, :home, contents: contents)
  end
end
