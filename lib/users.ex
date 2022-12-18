defmodule CoreIdentityElixir.Users do
  alias CoreIdentityElixir.Users.{Email, Verification}

  @doc """
  Get the list of a users emails from CoreIdentity.

  ## Examples

      iex> CoreIdentityElixir.User.get_emails(user_uid)
      {:ok,
      [
        %{
          "Object" => "Email",
          "address" => "test@core_apis.co.jp",
          "confirmed_at" => "2021-04-07T02:52:31Z",
          "primary" => true,
          "uid" => "81b7d2ef-43ef-42f8-922d-62602eac518a"
        },
        %{
          "Object" => "Email",
          "address" => "test2@core_apis.co.jp",
          "confirmed_at" => "2021-06-03T07:59:55Z",
          "primary" => false,
          "uid" => "8c8c09a7-b500-430c-a45c-569bd9fa5a08"
        }
      ]}
  """

  def get_emails(user_uid) do
    Email.get(user_uid)
  end

  @doc """
  Sends an email confirmation to the email address to add a new users email.

  ## Examples

      iex> CoreIdentityElixir.User.add_email(user_uid, address)
        {:ok, %HTTPoison{body: "{\"success\":\"email verification request sent\"}"}
  """
  def add_email(user_uid, address) do
    Email.create(user_uid, address)
  end

  @doc """
  Remove a users email.
  ## Examples
      iex> CoreIdentityElixir.CoreIdentity.remove_user_email(user_uid, email_uid)
      {:ok, %HTTPoison{body: "{\"success\":\"email email_uid deleted\"}"}}
  """
  def remove_email(user_uid, email_uid) do
    Email.delete(user_uid, email_uid)
  end

  @doc """
  Sends an email verification code to the email address.

  Reference length must be between 22 and 44 characters
  ## Examples

      iex> CoreIdentityElixir.User.send_verification(user_uid, reference)
        {:ok, %HTTPoison{body: "successful operation"}
  """
  def send_verification(user_uid, reference) do
    Verification.create(user_uid, reference)
  end

  @doc """
  Verify the code and reference to validate the user.
  You have 3 attemps.
  ## Examples
      iex> CoreIdentityElixir.User.validate_verification_code(user_uid, reference, valid_code)
        {:ok, %{"ok" => "verification success"}}

      iex> CoreIdentityElixir.User.validate_verification_code(user_uid, reference, wrong_code)
        {:error, "{\"error\":\"verification failed\"}"}

      iex> CoreIdentityElixir.User.validate_verification_code(user_uid, reference, 3rd_attemp_code)
        {:error, "{\"error\":\"max attempts reached\"}"}
  """
  def validate_verification_code(user_uid, reference, code) do
    Verification.validate(user_uid, reference, code)
  end

  @doc """
  Renew the reference and sends a new verification code to the user.

  ## Examples

      iex> CoreIdentityElixir.User.renew_verification_code(user_uid, old_reference, new_reference)
        {:ok, %HTTPoison{body: "successful operation"}
  """
  def renew_verification_code(user_uid, old_reference, new_reference) do
    Verification.renew(user_uid, old_reference, new_reference)
  end
end
