### Acuity Bootcamp

Acuity Bootcamp is a 2 weeks camp that help to train new members financial concepts and Elixir programming language.

##### Project 1: Building Elixir software that simulates the Bitmex testnet.

* Have a local copy of the testnet order book
* Implement API to create/update/cancel order
* Maintain current position in the software
* Implement API to show current balance
* Have a simple form so users can enter the order information. Example: see screenshot below
* Have a UI somewhere to show the current position
* Have a UI somewhere to show the current balance

**Note:**

Default Instrument ID: BTCUSD
Can use third party software libraries
Focus on the functionality
Recommend to use Phoenix framework

**Other info:**

https://testnet.bitmex.com/
https://www.bitmex.com/app/apiOverview

**Getting Free Bitcoin to your testnet account:**

https://coinfaucet.eu/en/btc-testnet/
https://tbtc.bitaps.com/
https://testnet-faucet.mempool.co/

**Phoenix Framework & Libraries**
https://www.phoenixframework.org/

**Websocket library:**
https://github.com/Azolo/websockex

**API library:**
https://github.com/edgurgel/httpoison
https://github.com/teamon/tesla

**For learning Elixir, please read the following document. This is official docs, it more than enough**

https://elixir-lang.org/getting-started/introduction.html

**Project Break Down**

* Initial Setup
* Implement Order Model that includes needed fields. https://www.bitmex.com/api/explorer/#!/Order/Order_getOrders
* Implement Balance Model that includes needed fields https://www.bitmex.com/api/explorer/#!/User/User_getWallet
* Implement Position Model that includes needed fields
https://www.bitmex.com/api/explorer/#!/Position/Position_get
* Implement API to create/update/cancel order https://www.bitmex.com/api/explorer/#!/Order/Order_new
* Implement API to get current balance
* Implement API to get current position
* To build a local copy of the live orderbook, we need to use websocket. https://www.bitmex.com/app/wsAPI. We need to subscribe to the right channel.
Implement a data structure that can maintain the order book. Please be aware of performance issues.
