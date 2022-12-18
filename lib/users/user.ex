defmodule CoreIdentityElixir.Users.User do
  alias CoreIdentityElixir.CoreIdentity.Server

  def create(email, password) do
    Server.post("/users", %{user: %{email: email, password: password}})
  end

  def get(%{uid: uid}) do
    Server.get("/users", uid: uid)
  end

  def get(%{email: email}) do
    Server.get("/users", email: email)
  end

  def reset_password(email) do
    Server.post("/users/reset_password", %{email: email}, %{type: :public})
  end

  def delete(uid) do
    Server.delete("/users/#{uid}")
  end
end
