defmodule UserEncryption.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hash, :text
      add :key_hash, :text

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
