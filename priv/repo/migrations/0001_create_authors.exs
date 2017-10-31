defmodule Burp.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :url, :string
      add :encrypted_password, :string, null: false, default: ""

      timestamps()
    end

    create unique_index(:authors, [:username])
    create unique_index(:authors, [:email])
  end
end
