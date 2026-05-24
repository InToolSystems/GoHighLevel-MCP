# --- Build Stage ---
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ALL dependencies (including devDependencies like typescript)
RUN npm ci

# Copy source code
COPY . .

# Build the TypeScript project
RUN npm run build

# --- Production Stage ---
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy built artifacts from builder stage
COPY --from=builder /app/dist ./dist

# Expose port
EXPOSE 8000

ENV NODE_ENV=production

CMD ["npm", "start"]
