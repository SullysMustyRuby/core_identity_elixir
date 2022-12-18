defmodule CoreIdentityElixir.CoreIdentity.Server do
  @moduledoc false

  @http Application.compile_env(:core_identity_elixir, :http_client)
  @default_url Application.compile_env(:core_identity_elixir, :core_identity_url)
  @default_api Application.compile_env(:core_identity_elixir, :core_identity_api_version)

  def authenticate(params) do
    post("/users/authenticate", params, %{type: :public})
  end

  def base_url do
    case Application.get_env(:core_identity_elixir, :url) do
      url when is_binary(url) -> url
      _ -> @default_url
    end
  end

  def delete(url) do
    @http.delete("#{base_api_url()}#{url}", private_headers())
    |> parse_response()
  end

  def get(url, params \\ [], opts \\ %{}) do
    @http.request(:get, "#{base_api_url()}#{url}", "", get_headers(opts[:type]), params: params)
    |> parse_response()
  end

  def get_certs do
    with {:ok, certs} <- get("/oauth/certs", %{type: :public}) do
      certs
    end
  end

  def get_current_user(user_token) do
    get("/current_user/#{user_token}")
  end

  def get_providers do
    get("/providers", [], %{type: :public})
  end

  def post(url, body, opts \\ %{}) do
    @http.post("#{base_api_url()}#{url}", Jason.encode!(body), get_headers(opts[:type]))
    |> parse_response()
  end

  def put(url, body, opts \\ %{}) do
    @http.put("#{base_api_url()}#{url}", Jason.encode!(body), get_headers(opts[:type]))
    |> parse_response()
  end

  defp api_version do
    case Application.get_env(:core_identity_elixir, :api_version) do
      url when is_binary(url) -> url
      _ -> @default_api
    end
  end

  def base_api_url do
    "#{base_url()}#{api_version()}"
  end

  defp get_headers(:public), do: public_headers()

  defp get_headers(_), do: private_headers()

  defp parse_response({:ok, %HTTPoison.Response{status_code: 202, body: message}}),
    do: {:ok, message}

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
    |> Jason.decode()
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: status_code, body: message}}),
    do: {:error, "Returned status: #{status_code} with message: #{message}"}

  defp public_headers do
    [
      {"x-api-key", Application.get_env(:core_identity_elixir, :public_key)},
      {"Content-Type", "application/json"}
    ]
  end

  defp private_headers do
    [
      {"x-api-key", Application.get_env(:core_identity_elixir, :private_key)},
      {"Content-Type", "application/json"}
    ]
  end
end
