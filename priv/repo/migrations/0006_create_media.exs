defmodule Burp.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :name, :string, null: false
      add :media_type, :string, null: false
      add :url, :string, null: false
      add :path, :string, null: false
      add :blog_id, references(:blogs, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:media, [:blog_id])
    create index(:media, [:url])
    create unique_index(:media, [:blog_id, :url])
  end
end
