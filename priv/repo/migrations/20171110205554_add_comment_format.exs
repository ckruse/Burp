defmodule Burp.Repo.Migrations.AddCommentFormat do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add(:format, :string, null: false, default: "markdown")
    end
  end
end
