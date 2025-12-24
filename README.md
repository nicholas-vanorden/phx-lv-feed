# phx-lv-feed

A small real-time chat/feed application built with **Phoenix LiveView**, **Phoenix.Presence**, **ETS**, and **GenServers** — no database required.

This project demonstrates how to build a clean, production-style LiveView app using OTP primitives and Phoenix’s real-time tooling instead of a traditional persistence layer.


## ✨ Features

- ⚡ **Real-time feed** using Phoenix LiveView
- 👥 **Online user tracking** with Phoenix Presence
- 🟢 System messages when users **join / leave**
- 🧠 **Crash-safe in-memory storage** using ETS
- 📡 Real-time updates via Phoenix PubSub
- 🧼 Clean separation of concerns (LiveView vs GenServer)
- 🚫 No database, no Ecto, no Postgres

---

## 🏗️ Architecture Overview

This app intentionally avoids a database to showcase how far you can go with Phoenix + OTP alone.

### Key Components

| Component | Responsibility |
|---------|----------------|
| **LandingLive** | Entry page, shows online users, collects display name |
| **FeedLive** | Renders the live feed and message input |
| **Feed GenServer** | Owns message state (backed by ETS) |
| **ETS Table** | Stores messages safely across LiveView crashes |
| **Presence** | Tracks who is currently online |
| **PresenceListener** | Single process that posts join/leave system messages |
| **PubSub** | Broadcasts feed updates to all connected clients |


### Prerequisites

- Elixir 1.15+
- Erlang / OTP 26+
- Node.js (for assets)

### Setup

```bash
git clone https://github.com/nicholas-vanorden/phx-lv-feed.git
cd phx_lv_feed

mix deps.get
mix phx.server
```
Then visit: http://localhost:4000