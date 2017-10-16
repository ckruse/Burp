defmodule Burp.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :visible, :boolean, default: false, null: false
      add :author, :string, null: false
      add :email, :string
      add :url, :string
      add :attrs, :map, null: false, default: %{}
      add :content, :text, null: false

      add :post_id, references(:posts, on_delete: :delete_all, on_update: :update_all)

      timestamps()
    end

    create index(:comments, [:post_id])
  end
end
