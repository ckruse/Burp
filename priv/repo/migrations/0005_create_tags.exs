defmodule Burp.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :tag_name, :string, null: false
      add :post_id, references(:posts, on_delete: :delete_all, on_update: :update_all)
    end

  end
end
