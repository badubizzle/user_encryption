defmodule UserEncryptionWeb.PageController do
  use UserEncryptionWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def encrypt(conn, _params)do
    user = get_session(conn, :user)
    key = get_session(conn, :key)
    user_data = 
    UserEncryption.Account.get_all_user_data(user.id)
    |> Enum.map(fn it ->       
        %{hash: it.data_hash, data: nil, id: it.id}                  
    end)
    render conn, "encrypt.html", data: user_data
  end

  def register(conn, _params)do
    render conn, "register.html"
  end

  def do_register(conn, %{"name"=>name, "email"=> email, 
  "password"=>password, 
  "confirm_password"=>confirm_password})do
    case confirm_password === password do
      true->
        case UserEncryption.Account.create_user(%{name: name, email: email, password: password}) do
          {:ok, u}->
            conn
            |>clear_session()
            |>redirect(to: "/login")
          _ -> 
            conn|>redirect(to: "/register")
        end
      _ ->
        conn|>redirect(to: "/register")
    end
    
  end

  def logout(conn, _p)do
    conn |> clear_session()
    |> redirect(to: "/login")  
  end

  def login(conn, _params)do
    render conn, "login.html"
  end

  def do_login(conn, %{"email"=>email, "password"=>password})do
    
    user = UserEncryption.Account.get_user_by_email(email)    
    case UserEncryption.Account.validate_user(user, password)do
      %{key: key}->
        conn
        |>put_session(:key, key)
        |>put_session(:user, user)
        |>redirect(to: "/encrypt")
      _ -> conn |> redirect(to: "/login")
    end
  end


  def do_encrypt(conn, %{"data"=>data})do
    user = get_session(conn, :user)
    key = get_session(conn, :key)
    data_hash = UserEncryption.Security.Utils.encrypt(key, data)
    UserEncryption.Account.create_user_data(%{user_id: user.id, data_hash: data_hash})
    conn |> redirect(to: "/encrypt")
  end

  def do_decrypt(conn, %{"id"=>id})do
    user = get_session(conn, :user)
    key = get_session(conn, :key)
    user_data = UserEncryption.Account.get_user_data!(id)
    d = case UserEncryption.Security.Utils.decrypt(key, user_data.data_hash)do
      {:ok, data}->
        %{hash: user_data.data_hash, data: data}
      _ ->
        %{hash: user_data.data_hash, data: nil}
    end

    conn|> render("decrypt.html", data: [d])
    
  end

  def do_decrypt(conn, _p)do
    user = get_session(conn, :user)
    key = get_session(conn, :key)
    user_data = case UserEncryption.Account.get_all_user_data(user.id)do
      items when is_list(items) ->
        items
        |> Enum.map(fn it -> 
          case UserEncryption.Security.Utils.decrypt(key, it.data_hash)do
            {:ok,  d} -> %{hash: it.data_hash, data: d}
            _ -> %{hash: it.data_hash, data: nil}
          end
          
        end)
    end
    conn|> render("decrypt.html", data: user_data)
  end

  
  def do_change_password(conn, %{"old_password"=>old_password, "new_password"=>new_password})do    
    user = get_session(conn, :user)    
    case UserEncryption.Account.validate_user(user, old_password)do
      %{key: key}->
        %{key_hash: key_hash} = UserEncryption.Security.Utils.update_key_hash(old_password, user.key_hash,  new_password)
        UserEncryption.Account.update_user(user, %{key_hash: key_hash, password: new_password})
        conn 
        |>clear_session()
        |> redirect(to: "/login")
    end    
  end

  def change_password(conn, _p)do
    render(conn, "changepassword.html")
  end

  

end
