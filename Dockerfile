# Stage 1: Build React frontend
FROM node:18-alpine AS frontend-builder

WORKDIR /app

# Copy and install frontend dependencies
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm install

# Copy all frontend files and build
COPY frontend ./frontend
RUN cd frontend && npm run build

# Stage 2: Backend with frontend build included
FROM node:22-alpine AS backend

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Copy and install backend dependencies
COPY backend/package*.json ./backend/
RUN cd backend && npm install --omit=dev

# Copy backend code
COPY backend ./backend

# Copy frontend build into backend public directory
COPY --from=frontend-builder /app/frontend/dist ./backend/frontend/dist

# Set working directory to backend
WORKDIR /app/backend

# Expose backend port
EXPOSE 5001

# Start server
CMD ["node", "src/index.js"]
