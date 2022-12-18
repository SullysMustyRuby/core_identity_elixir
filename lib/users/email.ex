defmodule CoreIdentityElixir.Users.Email do
  alias CoreIdentityElixir.CoreIdentity.Server

  def create(uid, address) do
    Server.post("/users/#{uid}/emails", %{email: %{address: address}})
  end

  def get(uid) do
    Server.get("/users/#{uid}/emails")
  end

  def delete(user_uid, email_uid) do
    Server.delete("/users/#{user_uid}/emails/#{email_uid}")
  end
end
