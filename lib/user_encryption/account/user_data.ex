defmodule UserEncryption.Account.UserData do
  use Ecto.Schema
  import Ecto.Changeset


  schema "user_data" do
    field :data_hash, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user_data, attrs) do
    user_data
    |> cast(attrs, [:user_id, :data_hash])
    |> validate_required([:user_id, :data_hash])
  end
end
