defmodule Burp.Repo.Migrations.CreateBlogs do
  use Ecto.Migration

  def change do
    create table(:blogs) do
      add :name, :string, null: false
      add :description, :text, null: false
      add :keywords, :string, null: false
      add :url, :string, null: false
      add :image_url, :string, null: false
      add :lang, :string, null: false
      add :host, :string, null: false
      add :attrs, :map, null: false, default: %{}
      add :author_id, references(:authors, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:blogs, [:host])
    create index(:blogs, [:author_id])
  end
end
