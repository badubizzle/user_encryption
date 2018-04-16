defmodule UserEncryptionWeb.ValidUserPlug do
  import Plug.Conn

  def init(opt \\ [])do
    opt
  end

  def call(conn, opt)do
    case get_session(conn, :user)do
      nil -> 
        conn 
        |> Phoenix.Controller.redirect(to: "/login")
        |> halt()        
      _ ->
        conn
    end  
  end
end

defmodule UserEncryptionWeb.Router do
  use UserEncryptionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :valid_user do
    plug UserEncryptionWeb.ValidUserPlug
  end

  scope "/", UserEncryptionWeb do
    pipe_through [:browser , :valid_user] # Use the default browser stack
    get "/encrypt", PageController, :encrypt
    post "/encrypt", PageController, :do_encrypt
    post "/decrypt/:id", PageController, :do_decrypt
    get "/decrypt/:id", PageController, :do_decrypt
    get "/decrypt", PageController, :do_decrypt
    
    get "/changepassword", PageController, :change_password
    post "/changepassword", PageController, :change_password
  end

  scope "/", UserEncryptionWeb do
    pipe_through :browser # Use the default browser stack
    resources "/users", UserController, except: [:new, :edit]
    get "/", PageController, :index
    get "/register", PageController, :register
    post "/register", PageController, :do_register
    get "/login", PageController, :login
    post "/login", PageController, :do_login

    get "/logout", PageController, :logout
    post "/logout", PageController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", UserEncryptionWeb do
  #   pipe_through :api
  # end
end
