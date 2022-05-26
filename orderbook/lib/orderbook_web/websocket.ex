defmodule OrderbookWeb.WebSocket do
  use WebSockex

  def start_link(topic, is_auth \\ false) do
    endpoint = "wss://ws.testnet.bitmex.com/realtime?subscribe=#{topic}"
    auth_query = URI.encode_query(Orderbook.Sign.get_auth_query())
    url = if is_auth do
      "#{endpoint}&#{auth_query}"
    else
      endpoint
    end
    IO.puts(url)
    WebSockex.start(url, __MODULE__, topic)
  end

  def handle_frame({type, msg}, state) do
    # IO.inspect(msg)
    msg_decode = Jason.decode(msg)
    msg_map = elem(msg_decode, 1)
    table = msg_map["table"]
    case table do
      "orderBookL2_25" ->
        data = msg_map["data"]
        Orderbook.Orderbook.insert_list(data)
      _ -> ""
    end
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end
end
