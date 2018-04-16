defmodule UserEncryption.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias UserEncryption.Repo

  alias UserEncryption.Account.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user_by_email(email)do
    (from u in User, 
    where: u.email == ^email)
    |>Repo.one()
  end

  def validate_user(%{password_hash: password_hash, key_hash: key_hash}, password)do
    case Comeonin.Bcrypt.checkpw(password, password_hash)do
      true->
        %{key: UserEncryption.Security.Utils.decrypt_key_hash(password, key_hash)}
      false -> false
    end
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do    
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias UserEncryption.Account.UserData

  @doc """
  Returns the list of user_data.

  ## Examples

      iex> list_user_data()
      [%UserData{}, ...]

  """
  def list_user_data do
    Repo.all(UserData)
  end

  @doc """
  Gets a single user_data.

  Raises `Ecto.NoResultsError` if the User data does not exist.

  ## Examples

      iex> get_user_data!(123)
      %UserData{}

      iex> get_user_data!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_data!(id), do: Repo.get!(UserData, id)

  def get_all_user_data(user_id)do
    (from d in UserData, where: d.user_id ==^user_id)
    |> Repo.all()
  end
  @doc """
  Creates a user_data.

  ## Examples

      iex> create_user_data(%{field: value})
      {:ok, %UserData{}}

      iex> create_user_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_data(attrs \\ %{}) do
    %UserData{}
    |> UserData.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_data.

  ## Examples

      iex> update_user_data(user_data, %{field: new_value})
      {:ok, %UserData{}}

      iex> update_user_data(user_data, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_data(%UserData{} = user_data, attrs) do
    user_data
    |> UserData.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserData.

  ## Examples

      iex> delete_user_data(user_data)
      {:ok, %UserData{}}

      iex> delete_user_data(user_data)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_data(%UserData{} = user_data) do
    Repo.delete(user_data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_data changes.

  ## Examples

      iex> change_user_data(user_data)
      %Ecto.Changeset{source: %UserData{}}

  """
  def change_user_data(%UserData{} = user_data) do
    UserData.changeset(user_data, %{})
  end
end
