defmodule UserEncryption.Account.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :key_hash, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%{id: nil}=user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
    |> put_password()
    |> put_key_hash()

  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :key_hash])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> put_password()    
  end
   

  def put_password(%Ecto.Changeset{valid?: true, changes: %{password: password}}=changeset)do                
    changeset
    |>put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    
  end

  def put_password(c)do
    c
  end

  def put_key_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}}=changeset)do
    %{key_hash: key_hash} = UserEncryption.Security.Utils.generate_key_hash(password)
    changeset
    |>put_change(:key_hash, key_hash)
  end

  def put_key_hash(c)do
    c
  end
  
end
