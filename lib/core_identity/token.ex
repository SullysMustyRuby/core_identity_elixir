defmodule CoreIdentityElixir.CoreIdentity.Token do
  @moduledoc false
  alias CoreIdentityElixir.CoreIdentity

  def parse(token) do
    with [header, claims, signature] <- String.split(token, "."),
         {:ok, user_params} <- build_user_params(claims),
         true <- verify_signature({header, claims}, signature) do
      {:ok, user_params}
    else
      {:error, message} -> {:error, message}
      false -> {:error, :signature_fail}
    end
  end

  defp base_jason_decode(string) do
    with {:ok, base_decoded} <- Base.url_decode64(string, padding: false),
         {:ok, jason_decoded} <- Jason.decode(base_decoded) do
      {:ok, jason_decoded}
    else
      _ -> {:error, :token_decode_fail}
    end
  end

  defp build_user_params(claims) do
    with {:ok, %{"sub" => subject}} <- base_jason_decode(claims),
         [user_type, uid] <- String.split(subject, ":") do
      {:ok, %{uid: uid, user_type: user_type}}
    else
      {:error, message} -> {:error, message}
      _ -> {:error, :claims_parse_fail}
    end
  end

  defp verify_signature({header, claims}, signature) do
    with {:ok, %{"kid" => key_id}} <- base_jason_decode(header),
         {:ok, decoded_signature} <- Base.url_decode64(signature, padding: false),
         %{"e" => encoded_e, "n" => encoded_n} <- CoreIdentity.get_certs(key_id),
         {:ok, e} <- Base.url_decode64(encoded_e, padding: false),
         {:ok, n} <- Base.url_decode64(encoded_n, padding: false) do
      :crypto.verify(:rsa, :sha256, "#{header}.#{claims}", decoded_signature, [e, n])
    else
      _ -> {:error, :signature_parse_fail}
    end
  end
end
