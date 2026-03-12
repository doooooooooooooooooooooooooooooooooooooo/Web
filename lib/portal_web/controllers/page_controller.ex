defmodule PortalWeb.PageController do
  use PortalWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
