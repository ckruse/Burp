defmodule Burp.Repo.Migrations.AddAdminFlag do
  use Ecto.Migration

  def change do
    alter table(:authors) do
      add :admin, :boolean, null: false, default: false
    end
  end
end
