defmodule PortalWeb.Page.ArticleControllerTest do
  use PortalWeb.ConnCase

  test "GET /articles/:slug with published content", %{conn: conn} do
    # Create a published content with slug
    {:ok, _content} =
      Portal.Contents.create_content(%{
        title: "Test Article",
        body: "This is a test article content.",
        category: "Test",
        status: "published",
        slug: "test-article"
      })

    conn = get(conn, ~p"/articles/test-article")
    assert html_response(conn, 200) =~ "Test Article"
    assert html_response(conn, 200) =~ "This is a test article content"
  end

  test "GET /articles/:slug with non-existent content", %{conn: conn} do
    conn = get(conn, ~p"/articles/non-existent")
    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Article not found"
  end

  test "GET /articles/:slug with draft content", %{conn: conn} do
    # Create a draft content with slug
    {:ok, _content} =
      Portal.Contents.create_content(%{
        title: "Draft Article",
        body: "This is a draft article.",
        status: "draft",
        slug: "draft-article"
      })

    conn = get(conn, ~p"/articles/draft-article")
    assert redirected_to(conn) == ~p"/"
    assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Article not found"
  end
end
