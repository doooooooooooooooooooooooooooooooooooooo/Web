defmodule Portal.Repo.Migrations.AddCoverImageToContents do
  use Ecto.Migration

  def change do
    alter table(:contents) do
      add :cover_image, :string
    end
  end
end
