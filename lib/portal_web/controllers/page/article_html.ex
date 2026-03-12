defmodule PortalWeb.Page.ArticleHTML do
  @moduledoc """
  This module contains pages rendered by Page.ArticleController.

  See the `page_html` directory for all templates available.
  """
  use PortalWeb, :html

  embed_templates "page_html/*"
end
