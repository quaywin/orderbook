defmodule OrderbookWeb.API do

  def post(url, data) do
    data = URI.encode_query(data)
    client = get_client("POST", url, data)
    Tesla.post(client, url, data)
  end

  @spec get(binary | [{:body | :headers | :method | :opts | :query | :url, any}]) ::
          {:error, any} | {:ok, Tesla.Env.t()}
  def get(url) do
    client = get_client("GET", url, "")
    Tesla.get(client, url)
  end

  def del(url) do
    client = get_client("DELETE", url, "")
    Tesla.delete(client, url)
  end

  def put(url, data) do
    data = URI.encode_query(data)
    client = get_client("PUT", url, data)
    Tesla.put(client, url, data)
  end
  def get_client(verb, url, data) do
    base_url = "https://testnet.bitmex.com/api/v1"
    header = Orderbook.Sign.get_auth_header(verb, "/api/v1#{url}", data)
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers, header}
    ]
    Tesla.client(middleware)
  end
end
