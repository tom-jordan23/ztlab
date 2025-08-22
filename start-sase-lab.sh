#!/bin/bash

# SASE Lab Environment Startup Script
# This script starts the complete SASE lab environment

echo "🚀 Starting SASE Lab Environment..."
echo "====================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose > /dev/null 2>&1; then
    echo "❌ Error: Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Start core services first
echo "📋 Starting core applications..."
docker compose up -d corporate-app-1 corporate-app-2 dmz-web-server external-service opnsense

# Wait a moment for core services to initialize
sleep 5

# Start identity and network services
echo "🔐 Starting identity and network services..."
docker compose up -d zitadel-simulation ziti-simulation

# Wait for identity services to initialize
sleep 10

# Start monitoring services
echo "📊 Starting monitoring services..."
docker compose up -d elasticsearch
sleep 15  # Wait for Elasticsearch to be ready
docker compose up -d logstash kibana

# Start remaining services
echo "🛠️ Starting remaining services..."
docker compose up -d vyos cloud-custodian client-workstation network-tools

# Check service status
echo ""
echo "✅ SASE Lab Services Status:"
echo "============================"
docker compose ps

echo ""
echo "🌐 Access URLs:"
echo "==============="
echo "📋 Zitadel IAM:        http://localhost:9080"
echo "🛡️  OpenZiti Console:  http://localhost:1280"
echo "🔥 OPNsense SWG:       https://localhost:443"
echo "📊 Kibana Dashboard:   http://localhost:5601"
echo "🏢 Corporate HR App:   http://localhost:9081"
echo "📁 Corporate Files:    http://localhost:9082"
echo "🌐 DMZ Web Server:     http://localhost:9083"
echo "🌍 External Service:   http://localhost:9084"

echo ""
echo "🎯 Lab is ready! Check the README.md and CLAUDE.md for usage instructions."
echo "⚠️  Note: Some services may take a few minutes to fully initialize."