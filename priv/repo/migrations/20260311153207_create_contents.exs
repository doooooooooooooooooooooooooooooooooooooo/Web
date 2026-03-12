defmodule Portal.Repo.Migrations.CreateContents do
  use Ecto.Migration

  def change do
    create table(:contents) do
      add(:title, :string, null: false)
      add(:body, :text, null: false)
      add(:category, :string)
      add(:status, :string, default: "draft")

      timestamps()
    end
  end
end
