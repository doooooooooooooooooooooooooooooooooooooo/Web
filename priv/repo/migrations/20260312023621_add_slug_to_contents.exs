defmodule Portal.Repo.Migrations.AddSlugToContents do
  use Ecto.Migration

  def change do
    alter table(:contents) do
      add :slug, :string
    end

    create unique_index(:contents, [:slug])
  end
end
