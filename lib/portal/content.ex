defmodule Portal.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contents" do
    field(:title, :string)
    field(:body, :string)
    field(:category, :string)
    field(:status, :string, default: "draft")
    field(:slug, :string)
    field(:cover_image, :string)

    timestamps()
  end

  def changeset(content, attrs) do
    content
    |> cast(attrs, [:title, :body, :category, :status, :slug, :cover_image])
    |> validate_required([:title, :body, :slug])
    |> unique_constraint(:slug)
  end
end
