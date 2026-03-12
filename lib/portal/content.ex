defmodule Portal.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contents" do
    field(:title, :string)
    field(:body, :string)
    field(:category, :string)
    field(:status, :string, default: "draft")

    timestamps()
  end

  def changeset(content, attrs) do
    content
    |> cast(attrs, [:title, :body, :category, :status])
    |> validate_required([:title, :body])
  end
end
