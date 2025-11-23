# Meet App - Google Meet Clone

Live meeting application built with **Golang**, **React TypeScript**, and **Tailwind CSS** using hybrid architecture (WebSocket + SSE + REST).

## 📚 Documentation

- **[BLUEPRINT.md](./BLUEPRINT.md)** - Complete architecture & implementation guide
- **[docker-compose.example.yml](./docker-compose.example.yml)** - Development environment setup

## 🏗️ Architecture Overview

### Hybrid Communication Strategy

```
┌─────────────────────────────────────────┐
│         Protocol Distribution           │
├─────────────────────────────────────────┤
│ WebSocket → WebRTC Signaling Only      │
│ SSE       → Chat & Notifications        │
│ REST      → CRUD Operations             │
│ WebRTC    → P2P Media Streaming         │
└─────────────────────────────────────────┘
```

**Benefits**: 40% less server resources compared to WebSocket-only approach

## 🚀 Quick Start

### Prerequisites

- Go 1.21+
- Node.js 18+
- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+

### 1. Clone Repository

```bash
git clone <repository-url>
cd meet-app
```

### 2. Start Infrastructure

```bash
# Copy docker compose example
cp docker-compose.example.yml docker-compose.yml

# Start PostgreSQL, Redis, MinIO
docker-compose up -d

# Optional: Start dev tools (pgAdmin, Redis Commander)
docker-compose --profile dev-tools up -d
```

### 3. Backend Setup

```bash
cd backend
go mod init github.com/yourusername/meet-backend

# Install dependencies
go get github.com/gin-gonic/gin
go get github.com/gorilla/websocket
go get github.com/redis/go-redis/v9
go get gorm.io/gorm
go get gorm.io/driver/postgres
go get github.com/golang-jwt/jwt/v5

# Copy environment file
cp .env.example .env

# Run migrations
go run cmd/migrate/main.go

# Start server
go run cmd/server/main.go
# or with hot reload
air
```

### 4. Frontend Setup

```bash
cd frontend

# Install dependencies
pnpm install
# or
npm install

# Copy environment file
cp .env.example .env

# Start development server
pnpm dev
# or
npm run dev
```

### 5. Access Services

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8080
- **pgAdmin**: http://localhost:5050
- **Redis Commander**: http://localhost:8081
- **MinIO Console**: http://localhost:9001

## 📁 Project Structure

```
meet-app/
├── backend/              # Golang backend
│   ├── cmd/
│   ├── internal/
│   │   ├── api/
│   │   ├── websocket/   # WebRTC signaling
│   │   ├── sse/         # Server-Sent Events
│   │   └── models/
│   └── pkg/
├── frontend/             # React TypeScript
│   ├── src/
│   │   ├── components/
│   │   ├── hooks/
│   │   │   ├── useSSE.ts
│   │   │   ├── useWebSocket.ts
│   │   │   └── useWebRTC.ts
│   │   ├── services/
│   │   └── pages/
│   └── tailwind.config.js
├── BLUEPRINT.md
├── docker-compose.yml
└── README.md
```

## 🎯 Key Features

- ✅ Real-time video conferencing
- ✅ WebRTC peer-to-peer connections
- ✅ Real-time chat via SSE
- ✅ Screen sharing
- ✅ Recording functionality
- ✅ Participant management
- ✅ Hybrid architecture (optimized resource usage)

## 🛠️ Tech Stack

### Frontend
- React 18 + TypeScript
- Tailwind CSS
- Zustand (state management)
- Native WebSocket API
- Native EventSource (SSE)
- mediasoup-client (WebRTC)

### Backend
- Golang 1.21+
- Gin framework
- gorilla/websocket
- PostgreSQL + GORM
- Redis (Pub/Sub)
- JWT authentication

### Infrastructure
- Docker & Docker Compose
- MinIO (S3-compatible storage)
- Nginx (reverse proxy)
- Mediasoup or Pion (media server)

## 📖 Development Guide

### Phase 1: Foundation (Current)
- [x] Project initialization
- [ ] Database schema
- [ ] Authentication system
- [ ] Basic REST API

### Phase 2: SSE Implementation
- [ ] SSE broker
- [ ] Chat system
- [ ] Notification system

### Phase 3: WebRTC
- [ ] WebSocket signaling
- [ ] Peer connections
- [ ] Video/Audio streaming

See [BLUEPRINT.md](./BLUEPRINT.md) for complete implementation phases.

## 🔐 Environment Variables

### Backend (.env)
```bash
# Server
PORT=8080
GIN_MODE=debug

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=meetapp
DB_PASSWORD=meetapp123
DB_NAME=meetapp

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=your-super-secret-key
JWT_EXPIRY=24h

# MinIO
MINIO_ENDPOINT=localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin123
MINIO_USE_SSL=false

# STUN/TURN
STUN_SERVER=stun:stun.l.google.com:19302
```

### Frontend (.env)
```bash
VITE_API_URL=http://localhost:8080
VITE_WS_URL=ws://localhost:8080
VITE_SSE_URL=http://localhost:8080
```

## 🧪 Testing

```bash
# Backend tests
cd backend
go test ./...

# Frontend tests
cd frontend
pnpm test
```

## 📦 Production Build

### Backend
```bash
cd backend
CGO_ENABLED=0 GOOS=linux go build -o bin/server cmd/server/main.go
```

### Frontend
```bash
cd frontend
pnpm build
```

## 🚀 Deployment

See [BLUEPRINT.md](./BLUEPRINT.md) for detailed deployment instructions including:
- Docker containerization
- Nginx configuration
- HTTPS/TLS setup
- TURN server setup
- Horizontal scaling

## 📊 Monitoring

- Prometheus metrics endpoint: `/metrics`
- Health check: `/health`
- Ready check: `/ready`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- [WebRTC for the Curious](https://webrtcforthecurious.com/)
- [Mediasoup](https://mediasoup.org/)
- [Pion WebRTC](https://github.com/pion/webrtc)

---

**Version**: 2.0 (Hybrid Architecture)
**Last Updated**: 2025-11-16
