defmodule CoreIdentityElixir.Users.Verification do
  alias CoreIdentityElixir.CoreIdentity.Server

  def create(uid, reference) do
    Server.post("/users/#{uid}/verification", %{reference: reference})
  end

  def validate(uid, reference, code) do
    Server.put("/users/#{uid}/verification/validate", %{reference: reference, code: code})
  end

  def renew(uid, old_reference, new_reference) do
    Server.post("/users/#{uid}/verification/renew", %{
      old_reference: old_reference,
      new_reference: new_reference
    })
  end
end
