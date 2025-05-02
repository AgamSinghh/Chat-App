# Stage 1: Build React frontend
FROM node:22-alpine AS frontend-builder

WORKDIR /app

# Install frontend dependencies
COPY frontend/package*.json ./frontend/
RUN cd frontend && npm install

# Build frontend
COPY frontend ./frontend
RUN cd frontend && npm run build

# Stage 2: Backend + Serve frontend
FROM node:22-alpine AS backend

WORKDIR /app

ENV NODE_ENV=production

# Install backend dependencies
COPY backend/package*.json ./backend/
RUN cd backend && npm install --omit=dev

# Copy backend code
COPY backend ./backend


COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Set backend working directory
WORKDIR /app/backend

EXPOSE 5001

CMD ["node", "src/index.js"]
