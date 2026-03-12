defmodule PortalWeb.Page.HomeControllerTest do
  use PortalWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Latest Articles"
  end
end
