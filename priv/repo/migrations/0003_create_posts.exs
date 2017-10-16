defmodule Burp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :slug, :string, null: false
      add :guid, :string, null: false
      add :visible, :boolean, default: false, null: false

      add :subject, :string, null: false
      add :excerpt, :text
      add :content, :text, null: false
      add :format, :string, null: false, default: "html"
      add :attrs, :map, null: false, default: %{}
      add :published_at, :naive_datetime, null: false

      add :blog_id, references(:blogs, on_delete: :delete_all, on_update: :update_all)
      add :author_id, references(:authors, on_delete: :delete_all, on_update: :update_all)

      timestamps()
    end

    create unique_index(:posts, [:slug])
    create unique_index(:posts, [:guid])

    create index(:posts, [:blog_id])
    create index(:posts, [:author_id])
  end
end
