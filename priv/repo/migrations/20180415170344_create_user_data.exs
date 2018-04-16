defmodule UserEncryption.Repo.Migrations.CreateUserData do
  use Ecto.Migration

  def change do
    create table(:user_data) do
      add :user_id, :integer
      add :data_hash, :text

      timestamps()
    end

  end
end
