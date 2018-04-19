defmodule UserEncryption.Security.Utils do

    defp encode(d)do
        d        
        |> Base.encode64()
    end

    defp decode(d)do
        d        
        |> Base.decode64()
    end    

    defp generate_salt_bin()do                
        :enacl.randombytes(16)
    end

    defp generate_salt_string()do        
        generate_salt_bin()
        |> encode()
    end

    defp salt_string_to_bin(salt) do        
        {ok, data} = decode(salt)
        data
    end

    defp derive_pwd_key(pwd, salt) do
        case :enacl.pwhash(pwd, salt)do
            {:ok, h}-> h |> encode()
            other -> other
        end        
    end

    defp derive_pwd_key(pwd)do
        salt = generate_salt_bin()
        %{salt: encode(salt), key: derive_pwd_key(pwd, salt)}                    
    end

    defp generate_key()do
        key = :enacl.randombytes(:enacl.secretbox_key_size)
        encode(key)
    end
              

    defp encrypt(%{key: key, payload: payload}) do
        key_size = :enacl.secretbox_key_size
        {:ok, <<d_key::binary-size(key_size)>>} = decode(key)        
        nonce = :enacl.randombytes(:enacl.secretbox_nonce_size)
        ciphertext = :enacl.secretbox(payload, nonce, d_key)    
        encode(nonce <> ciphertext)
    end    

    defp decrypt(%{key: key, payload: payload}) do        
        key = decode_key(key, :enacl.secretbox_key_size)    
        nonce_size = :enacl.secretbox_nonce_size
        {:ok, <<nonce::binary-size(nonce_size), ciphertext::binary>>} = 
        decode(payload)
        :enacl.secretbox_open(ciphertext, nonce, key)               
    end


    defp decode_key(key, key_size) do

        {:ok, <<secret_key::binary-size(key_size)>>} = decode(key)
        secret_key          
    end


    #Public API functions

    @doc """
    Takes a password and generate encrypted unique user key.
    This key can only be decrypted with the same password
    """
    def generate_key_hash(pwd)do
        #derive a key from the password
        %{key: key, salt: salt} = derive_pwd_key(pwd)

        #generate unique key
        gen_key = generate_key() 

        #encrypt unique key with password derived key
        key_hash = encrypt(key, gen_key)

        #return encrypted key with the salt
        %{key_hash: salt <> "$" <> key_hash}
    end

    @doc """
    Take old password, key_hash and new password.
    Then decrypt key_hash
    """
    def update_key_hash(old_password, key_hash, new_password)do
        old_key = decrypt_key_hash(old_password, key_hash)
        %{key: key, salt: salt} = derive_pwd_key(new_password)
        key_hash = encrypt(key, old_key)
        %{key_hash: salt <> "$" <> key_hash}
    end

    def decrypt_key_hash(pwd, key_hash)do
        [salt, uk] = key_hash |> String.split("$")
        key = derive_pwd_key(pwd, salt_string_to_bin(salt))
        {:ok, d_key} = decrypt(key, uk)
        d_key
    end

    def decrypt(key, data)do
        decrypt(%{key: key, payload: data})
    end

    def encrypt(key, data)do
        encrypt(%{key: key, payload: data})
    end

    
end