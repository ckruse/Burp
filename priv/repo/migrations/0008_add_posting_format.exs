defmodule Burp.Repo.Migrations.AddPostingFormat do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :posting_format, :string, null: false, default: "html"
    end
  end
end
