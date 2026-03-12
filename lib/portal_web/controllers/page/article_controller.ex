defmodule PortalWeb.Page.ArticleController do
  use PortalWeb, :controller

  alias Portal.Contents

  def show(conn, %{"slug" => slug}) do
    case Contents.get_content_by_slug(slug) do
      nil ->
        conn
        |> put_flash(:error, "Article not found")
        |> redirect(to: ~p"/")

      content ->
        render(conn, :show, content: content)
    end
  end
end
