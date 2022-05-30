defmodule OrderbookWeb.API do

  def post(url, data) do
    client = get_client("POST", url, URI.encode_query(data))
    Tesla.post(client, url, data)
  end

  def put(url, data) do
    client = get_client("PUT", url, URI.encode_query(data))
    Tesla.put(client, url, data)
  end

  def get(url) do
    client = get_client("GET", url, "")
    Tesla.get(client, url)
  end

  def delete(url, data) do
    client = get_client("DELETE", url, URI.encode_query(data))
    Tesla.delete(client, url, body: data)
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
