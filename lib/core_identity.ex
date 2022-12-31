defmodule CoreIdentityElixir.CoreIdentity do
  @moduledoc """
  An Elixir Package designed to make implementing CoreIdentity authentication easy and fast.
  In order to use this package you need to have an account with [CoreServer](https://core-apis.com/)

  Currently this is only for internal uses. If you have a commercial interest please contact the Package Manager
  Erin Boeger through linkedIn or Github
  """

  alias CoreIdentityElixir.CoreIdentity.{Server, Token}

  @doc """
  Authenticate with CoreIdentity using an email and password. This will call the CoreIdentity
  server and try to autheniticate.
  Use this method for users who authenticate directly with CoreIdentity.
  Upon successful email and password

  ## Examples

      iex> CoreIdentityElixir.CoreIdentity.authenticate(%{email: "erin@core_apis.co.jp", password: "password"})
      {:ok, %{"access_token" => access_token, "refresh_token" => refresh_token}}

      iex> CoreIdentityElixir.CoreIdentity.authenticate(%{email: "erin@core_apis.co.jp", password: "wrong"})
      {:error, "bad request"}

  """

  def authenticate(params), do: Server.authenticate(params)

  @doc """
  Create a new user with email and password ad CoreIdentity. This will trigger CoreIdentity to send an
  email message to the user. The email will have a link that will direct the user back to CoreIdentity.
  CoreIdentity will then create a new user and respond with a redirect back to your application based on
  the setting in the CoreIdentity dashboard.

  ## Examples

      iex> CoreIdentityElixir.CoreIdentity.create_user(%{email: "erin@core_apis.co.jp", password: "password"})
      {:ok, "email verification request sent"}

      iex> CoreIdentityElixir.CoreIdentity.authenticate(%{email: "erin@core_apis.co.jp", password: "existing_user"})
			%{
			"code" => "user_error",
			"error" => %{"message" => %{"address" => ["has already been taken"]}},
			"response" => "error"
			}
  """
  def create_user(%{email: _email, password: _password} = params), do: Server.create_user(params)

  @doc """
  Get the current servers public key certificates. These certificates are used to verify a CoreIdentity
  issued JWT signature. These certificates are rotated on a regular basis. If your website has significant
  activity, it may make sense to cache and refresh when they expire.
  Each certificate returned has a timestamp of when the certificate will expire.

  ## Examples

      iex> CoreIdentityElixir.CoreIdentity.get_certs()
      [
          {
              "alg": "RS256",
              "e": "AQAB",
              "expires": 1614837416,
              "kid": "C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM",
              "kty": "RSA",
              "n": "really long n",
              "use": "sig"
          },
          ...
      ]

  """
  def get_certs, do: Server.get_certs()

  @doc """
  Get a certificate by a kid. The kid is included with every CoreIdentity issued JWT and
  idetnitifies which certificate was used to generate the certificate.

  ## Examples

      iex> CoreIdentityElixir.CoreIdentity.get_certs("C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM")
        {
            "alg": "RS256",
            "e": "AQAB",
            "expires": 1614837416,
            "kid": "C8Rn3J8tPlMp8etztCsb4k51sjTFXbA-Til9XptF2FM",
            "kty": "RSA",
            "n": "really long n",
            "use": "sig"
        }

      iex> CoreIdentityElixir.get_certs("expired or not valid kid")
      nil
  """

  def get_certs(key_id) do
    get_certs()
    |> Enum.find(fn %{"kid" => kid} -> kid == key_id end)
  end

  def get_current_user(user_token), do: Server.get_current_user(user_token)

  @doc """
  Parse and validate a JWT from CoreIdentity.
  When successful will return an ok tuple with a current_user map.

  ## Examples

      iex> CoreIdentityElixir.CoreIdentity.parse_token(%{"access_token" => access JWT})
      {:ok, %{
          uid: "core_identity_uid_1234",
          user_type: "CoreIdentity.User"
        }
      }

      iex> CoreIdentityElixir.CoreIdentity.parse_token(%{"access_token" => invalid JWT})
      {:error, :claims_parse_fail}

  """
  def parse_token(%{"access_token" => access_token}), do: Token.parse(access_token)

  def parse_token(%{access_token: access_token}), do: Token.parse(access_token)

  @doc """
  Get the list of Open Authentication Providers from CoreIdentity.
  Remember these links are only good once, and one link. If a users authenticates
  with Google then the facebook link will be invalid.
  The links also expire with 10 minutes of issue.

  ## Examples

      iex> CoreIdentityElixir.CoreIdentity.get_providers()
      [
          {
              "logo_url": "https://stage-identity.hubsynch.com/images/facebook.png",
              "name": "facebook",
              "request_url": request_url
          }
      ]
  """
  def get_providers, do: Server.get_providers()

  def core_identity_url, do: Server.base_url()
end
