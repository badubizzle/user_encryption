defmodule UserEncryption.AccountTest do
  use UserEncryption.DataCase

  alias UserEncryption.Account

  describe "users" do
    alias UserEncryption.Account.User

    @valid_attrs %{email: "some email", key_hash: "some key_hash", name: "some name", password_hash: "some password_hash"}
    @update_attrs %{email: "some updated email", key_hash: "some updated key_hash", name: "some updated name", password_hash: "some updated password_hash"}
    @invalid_attrs %{email: nil, key_hash: nil, name: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.key_hash == "some key_hash"
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.key_hash == "some updated key_hash"
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "user_data" do
    alias UserEncryption.Account.UserData

    @valid_attrs %{data_hash: "some data_hash", user_id: 42}
    @update_attrs %{data_hash: "some updated data_hash", user_id: 43}
    @invalid_attrs %{data_hash: nil, user_id: nil}

    def user_data_fixture(attrs \\ %{}) do
      {:ok, user_data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user_data()

      user_data
    end

    test "list_user_data/0 returns all user_data" do
      user_data = user_data_fixture()
      assert Account.list_user_data() == [user_data]
    end

    test "get_user_data!/1 returns the user_data with given id" do
      user_data = user_data_fixture()
      assert Account.get_user_data!(user_data.id) == user_data
    end

    test "create_user_data/1 with valid data creates a user_data" do
      assert {:ok, %UserData{} = user_data} = Account.create_user_data(@valid_attrs)
      assert user_data.data_hash == "some data_hash"
      assert user_data.user_id == 42
    end

    test "create_user_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user_data(@invalid_attrs)
    end

    test "update_user_data/2 with valid data updates the user_data" do
      user_data = user_data_fixture()
      assert {:ok, user_data} = Account.update_user_data(user_data, @update_attrs)
      assert %UserData{} = user_data
      assert user_data.data_hash == "some updated data_hash"
      assert user_data.user_id == 43
    end

    test "update_user_data/2 with invalid data returns error changeset" do
      user_data = user_data_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user_data(user_data, @invalid_attrs)
      assert user_data == Account.get_user_data!(user_data.id)
    end

    test "delete_user_data/1 deletes the user_data" do
      user_data = user_data_fixture()
      assert {:ok, %UserData{}} = Account.delete_user_data(user_data)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user_data!(user_data.id) end
    end

    test "change_user_data/1 returns a user_data changeset" do
      user_data = user_data_fixture()
      assert %Ecto.Changeset{} = Account.change_user_data(user_data)
    end
  end
end
