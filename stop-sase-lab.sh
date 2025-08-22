#!/bin/bash

# SASE Lab Environment Stop Script
# This script stops the complete SASE lab environment

echo "🛑 Stopping SASE Lab Environment..."
echo "===================================="

# Stop all services
docker compose down

echo ""
echo "✅ All SASE Lab services have been stopped."
echo ""
echo "📝 To remove all data volumes (WARNING: This will delete all lab data):"
echo "   docker compose down -v"
echo ""
echo "🔄 To restart the lab:"
echo "   ./start-sase-lab.sh"