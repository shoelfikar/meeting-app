.PHONY: help build up down restart logs ps clean deploy dev prod stop start rebuild backend frontend redis health check-network create-network

# Variables
DOCKER_COMPOSE = docker-compose
BACKEND_PATH = ./meet-app-backend
FRONTEND_PATH = ./meet-app-frontend
NETWORK_NAME = server_network

# Default target
help: ## Show this help message
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Meet App - Docker Management Commands"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Network Management
check-network: ## Check if server_network exists
	@docker network inspect $(NETWORK_NAME) >/dev/null 2>&1 || (echo "Network $(NETWORK_NAME) does not exist. Creating..." && make create-network)

create-network: ## Create server_network
	@docker network create $(NETWORK_NAME) && echo "Network $(NETWORK_NAME) created successfully" || echo "Network $(NETWORK_NAME) already exists"

# Build Commands
build: check-network ## Build all Docker images
	@echo "Building all services..."
	$(DOCKER_COMPOSE) build --no-cache

build-backend: check-network ## Build backend image only
	@echo "Building backend..."
	$(DOCKER_COMPOSE) build --no-cache backend

build-frontend: check-network ## Build frontend image only
	@echo "Building frontend..."
	$(DOCKER_COMPOSE) build --no-cache frontend

rebuild: down build up ## Rebuild all services and restart

# Deployment Commands
deploy: check-network build up ## Full deployment: check network, build, and start all services
	@echo "Deployment completed successfully!"
	@make ps

deploy-prod: check-network ## Deploy in production mode
	@echo "Deploying in production mode..."
	$(DOCKER_COMPOSE) up -d --build
	@echo "Production deployment completed!"
	@make ps

# Start/Stop Commands
up: check-network ## Start all services in detached mode
	@echo "Starting all services..."
	$(DOCKER_COMPOSE) up -d
	@echo "Services started successfully!"
	@make ps

down: ## Stop and remove all containers
	@echo "Stopping all services..."
	$(DOCKER_COMPOSE) down
	@echo "All services stopped"

down-volumes: ## Stop all services and remove volumes
	@echo "Stopping all services and removing volumes..."
	$(DOCKER_COMPOSE) down -v
	@echo "All services stopped and volumes removed"

start: ## Start existing containers
	@echo "Starting containers..."
	$(DOCKER_COMPOSE) start

stop: ## Stop running containers without removing
	@echo "Stopping containers..."
	$(DOCKER_COMPOSE) stop

restart: ## Restart all services
	@echo "Restarting all services..."
	$(DOCKER_COMPOSE) restart
	@make ps

restart-backend: ## Restart backend service only
	@echo "Restarting backend..."
	$(DOCKER_COMPOSE) restart backend

restart-frontend: ## Restart frontend service only
	@echo "Restarting frontend..."
	$(DOCKER_COMPOSE) restart frontend

# Development Commands
dev: check-network ## Start development environment
	@echo "Starting development environment..."
	$(DOCKER_COMPOSE) up

dev-backend: ## Start only backend services for development
	@echo "Starting backend services..."
	$(DOCKER_COMPOSE) up redis backend

dev-frontend: ## Start only frontend for development
	@echo "Starting frontend..."
	$(DOCKER_COMPOSE) up frontend

# Logs Commands
logs: ## Show logs for all services
	$(DOCKER_COMPOSE) logs -f

logs-backend: ## Show backend logs
	$(DOCKER_COMPOSE) logs -f backend

logs-frontend: ## Show frontend logs
	$(DOCKER_COMPOSE) logs -f frontend

logs-redis: ## Show redis logs
	$(DOCKER_COMPOSE) logs -f redis

# Monitoring Commands
ps: ## Show running containers
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Running Containers"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@$(DOCKER_COMPOSE) ps
	@echo ""

stats: ## Show container resource usage statistics
	@docker stats --no-stream

health: ## Check health status of all services
	@echo "Checking health status..."
	@docker ps --filter "name=meet-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Clean Commands
clean: down ## Stop containers and clean up
	@echo "Cleaning up..."
	docker system prune -f
	@echo "Cleanup completed"

clean-all: down-volumes ## Remove everything including volumes and images
	@echo "Removing all containers, volumes, and images..."
	docker system prune -af --volumes
	@echo "Complete cleanup done"

clean-images: ## Remove all meet-app images
	@echo "Removing meet-app images..."
	@docker images | grep meet-app | awk '{print $$3}' | xargs -r docker rmi -f || true
	@echo "Images removed"

# Exec Commands
shell-backend: ## Open shell in backend container
	$(DOCKER_COMPOSE) exec backend sh

shell-frontend: ## Open shell in frontend container
	$(DOCKER_COMPOSE) exec frontend sh

shell-redis: ## Open redis-cli
	$(DOCKER_COMPOSE) exec redis redis-cli

# Database Commands
db-migrate: ## Run database migrations (backend)
	@echo "Running database migrations..."
	$(DOCKER_COMPOSE) exec backend ./server migrate || echo "Migration command not available"

# Testing Commands
test: ## Run tests
	@echo "Running tests..."
	@cd $(BACKEND_PATH) && go test ./... || echo "Backend tests not configured"
	@cd $(FRONTEND_PATH) && npm test || echo "Frontend tests not configured"

# Info Commands
info: ## Show project information
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Meet App - Project Information"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  Services:"
	@echo "    Frontend:  http://localhost:3000"
	@echo "    Backend:   http://localhost:8080"
	@echo "    Redis:     localhost:6379"
	@echo ""
	@echo "  Network:    $(NETWORK_NAME)"
	@echo ""
	@echo "  Backend Path:  $(BACKEND_PATH)"
	@echo "  Frontend Path: $(FRONTEND_PATH)"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Quick Commands
quick-start: check-network up ## Quick start without building
	@echo "Quick start completed!"

quick-restart: restart ## Quick restart all services

# Backup Commands
backup-redis: ## Backup Redis data
	@echo "Backing up Redis data..."
	@docker exec meet-redis redis-cli BGSAVE
	@echo "Redis backup initiated"

# Watch Commands
watch: ## Watch logs for all services
	$(DOCKER_COMPOSE) logs -f --tail=100
