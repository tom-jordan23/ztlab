# SASE Lab Environment - CLAUDE Commands

This document contains the essential commands and procedures for setting up, managing, and demonstrating the SASE (Secure Access Service Edge) lab environment.

## Quick Start Commands

### Initial Setup
```bash
# Start the complete SASE lab environment
docker compose up -d

# Check status of all services
docker compose ps

# View logs for specific services
docker compose logs -f zitadel
docker compose logs -f ziti-controller
docker compose logs -f opnsense
```

### Service Access URLs
```bash
# Open web interfaces (use these URLs in your browser)
echo "Zitadel IAM: http://localhost:9080"
echo "OpenZiti Console: http://localhost:1280"
echo "OPNsense SWG: https://localhost:443"
echo "Kibana Dashboard: http://localhost:5601"
echo "Corporate HR App: http://localhost:9081"
echo "Corporate Files: http://localhost:9082"
echo "DMZ Web Server: http://localhost:9083"
echo "External Service: http://localhost:9084"
```

## Component Management

### Identity and Access Management (Zitadel)
```bash
# Access Zitadel admin console
docker exec -it sase-zitadel /bin/sh

# Reset Zitadel admin password
docker compose restart zitadel

# View Zitadel configuration
docker exec -it sase-zitadel cat /app/data/config.yaml
```

### Zero Trust Network Access (OpenZiti)
```bash
# Access Ziti controller
docker exec -it sase-ziti-controller /bin/bash

# Create a new Ziti identity
docker exec -it sase-ziti-controller ziti edge create identity user "TestUser" -a "test-users"

# List all identities
docker exec -it sase-ziti-controller ziti edge list identities

# Create a service
docker exec -it sase-ziti-controller ziti edge create service "web-service" --configs "web-config"

# Create service policy
docker exec -it sase-ziti-controller ziti edge create service-policy "web-access" Dial --identity-roles "@test-users" --service-roles "@web-services"
```

### Firewall and Secure Web Gateway
```bash
# Check OPNsense proxy status
docker exec -it sase-opnsense nginx -t

# View web gateway logs
docker compose logs -f opnsense

# Test web filtering
curl -x localhost:3128 http://malware.testcategory.com

# Check blocked content
curl -k https://localhost:443/malware
```

### SD-WAN Router (VyOS Simulation)
```bash
# Access VyOS configuration
docker exec -it sase-vyos /bin/bash

# Check routing table
docker exec -it sase-vyos ip route show

# Test connectivity between networks
docker exec -it sase-vyos ping 10.10.1.1

# SSH access to VyOS (after services are installed)
ssh root@localhost -p 2223
```

### Cloud Security (CASB Simulation)
```bash
# Run Cloud Custodian policies
docker exec -it sase-casb custodian run --output-dir=/app/data /app/policies/policies.yaml

# Check policy violations
docker exec -it sase-casb ls -la /app/data/

# View CASB logs
docker compose logs -f cloud-custodian
```

## Monitoring and Analytics

### ELK Stack Management
```bash
# Check Elasticsearch health
curl http://localhost:9200/_cluster/health?pretty

# Create index patterns in Kibana
curl -X POST "localhost:5601/api/saved_objects/index-pattern/sase-logs" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{"attributes":{"title":"sase-logs-*","timeFieldName":"@timestamp"}}'

# Send test log to Logstash
echo '{"message":"Test SASE event","@timestamp":"'$(date -Iseconds)'","component":"test"}' | \
  curl -X POST "localhost:5044" -H "Content-Type: application/json" -d @-
```

### Network Testing
```bash
# Access network tools container
docker exec -it sase-nettools /bin/bash

# Test network connectivity between zones
docker exec -it sase-nettools ping corporate-app-1
docker exec -it sase-nettools ping dmz-web-server
docker exec -it sase-nettools ping external-service

# Trace network path
docker exec -it sase-nettools traceroute 10.10.1.1

# Test DNS resolution
docker exec -it sase-nettools nslookup corporate-app-1

# Port scanning (ethical testing only)
docker exec -it sase-nettools nmap -p 80,443,22 corporate-app-1
```

### Security Testing
```bash
# Test web application firewall
curl -X GET "http://localhost:9081/admin?id=1' OR '1'='1"

# Test malware blocking
wget --no-check-certificate https://localhost:443/malware/test.exe

# Test unauthorized access
curl -H "Authorization: Bearer invalid_token" http://localhost:9081/payroll

# Generate security events
for i in {1..10}; do 
  curl -H "X-Forwarded-For: 192.168.200.99" http://localhost:9081/login
  sleep 1
done
```

## Lab Scenarios and Demonstrations

📋 **For comprehensive use case implementations, see [SASE-USE-CASES.md](./SASE-USE-CASES.md)**

The use cases document provides detailed, step-by-step implementations for:
- Remote Worker Secure Access
- Cloud Application Security  
- Data Loss Prevention (DLP)
- Web Threat Protection
- Shadow IT Discovery
- Zero Trust Network Segmentation
- Compliance and Audit Reporting
- Incident Response and Forensics
- Cloud Migration Security
- Multi-scenario integration

### Quick Demo Scenarios

### Scenario 1: Zero Trust Access Control
```bash
# Demonstrate identity-based access
echo "1. User without proper identity tries to access corporate app"
curl http://localhost:9081 # Should be accessible (demo mode)

echo "2. Configure Ziti for zero trust access"
# Visit http://localhost:1280 to configure policies

echo "3. Test access with proper identity"
# Use Ziti edge client to connect securely
```

### Scenario 2: Secure Web Gateway Protection
```bash
# Test malware blocking
echo "Testing malware URL blocking..."
curl -v https://localhost:443/malware

# Test phishing protection
echo "Testing phishing site blocking..."
curl -v https://localhost:443/phishing

# Check web filtering logs
docker compose logs opnsense | grep -i "blocked\|denied"
```

### Scenario 3: CASB Cloud Security
```bash
# Simulate cloud service usage
echo "Simulating unauthorized cloud upload..."
curl -X POST http://localhost:9084/upload \
  -F "file=@/tmp/sensitive-data.txt" \
  -H "X-User-Email: user@corp.com"

# Check CASB policy violations
docker exec -it sase-casb custodian run /app/policies/policies.yaml
```

### Scenario 4: Network Segmentation
```bash
# Test network isolation
echo "Testing corporate to DMZ access..."
docker exec -it sase-client ping 172.16.0.1

echo "Testing DMZ to corporate access (should be limited)..."
docker exec -it sase-dmz-web ping 10.10.1.1

# Show firewall rules
docker exec -it sase-opnsense cat /etc/nginx/nginx.conf | grep -A 10 "location"
```

## Troubleshooting Commands

### Service Health Checks
```bash
# Check all container health
docker compose ps

# Check specific service logs
docker compose logs -f [service-name]

# Restart failed services
docker compose restart [service-name]

# Check resource usage
docker stats
```

### Network Diagnostics
```bash
# Check Docker networks
docker network ls
docker network inspect ztlab_management
docker network inspect ztlab_corporate

# Check container connectivity
docker exec -it sase-nettools ping sase-zitadel
docker exec -it sase-nettools telnet opnsense 443
```

### Configuration Validation
```bash
# Validate nginx configuration
docker exec -it sase-opnsense nginx -t

# Check Ziti controller status
docker exec -it sase-ziti-controller ziti edge list controllers

# Validate Logstash configuration
docker exec -it sase-logstash /usr/share/logstash/bin/logstash --config.test_and_exit
```

## Data Generation for Testing

### Generate Sample Logs
```bash
# Generate firewall logs
for i in {1..50}; do
  echo "$(date -Iseconds) INFO [firewall] 192.168.200.$((RANDOM%100+1)):$((RANDOM%60000+1024)) -> 10.10.1.$((RANDOM%100+1)):80 ALLOW HTTP_ACCESS" | \
  docker exec -i sase-logstash logger
  sleep 0.1
done

# Generate security events
echo "$(date -Iseconds) ALERT [security] Malware detected: trojan.exe from 192.168.200.99" | \
docker exec -i sase-logstash logger

# Generate ZTNA authentication logs
echo "$(date -Iseconds) INFO [ztna] ALLOWED user=alice.smith@corp.com app=hr-portal src_ip=10.10.1.25 policy=corporate-users" | \
docker exec -i sase-logstash logger
```

### Simulate User Activity
```bash
# Simulate web browsing
for url in "hr-portal" "file-server" "external-site"; do
  curl -s http://localhost:908$((RANDOM%3+1)) > /dev/null
  sleep 2
done

# Simulate file uploads
echo "This is test data" > /tmp/test-file.txt
curl -X POST http://localhost:9082/upload -F "file=@/tmp/test-file.txt"
```

## Cleanup Commands

### Stop and Remove Lab
```bash
# Stop all services
docker compose down

# Remove all data volumes (WARNING: This will delete all lab data)
docker compose down -v

# Remove all images
docker compose down --rmi all

# Complete cleanup
docker system prune -a --volumes
```

### Selective Cleanup
```bash
# Restart specific service
docker compose restart zitadel

# Remove and recreate specific service
docker compose rm -f opnsense
docker compose up -d opnsense
```

## Security Best Practices for Lab Use

### Important Notes
- This lab is for educational purposes only
- Do not use in production environments
- All credentials are demonstration-only
- Network traffic may be logged for analysis
- Regularly update container images for security

### Lab Safety
```bash
# Check for exposed ports
docker compose ps --format "table {{.Name}}\t{{.Ports}}"

# Monitor resource usage
docker stats --no-stream

# Regular security updates
docker compose pull
docker compose up -d
```

## Advanced Configuration

### Custom SSL Certificates
```bash
# Generate self-signed certificates for HTTPS
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout config/opnsense/server.key \
  -out config/opnsense/server.crt \
  -subj "/C=US/ST=Lab/L=Demo/O=SASE/CN=localhost"
```

### External Integration
```bash
# Connect to external SIEM
# Configure Logstash to forward to external systems
# Update config/logstash/pipeline/logstash.conf output section

# Export security logs
docker exec -it sase-logstash curl -X GET "elasticsearch:9200/sase-logs-*/_search" > security-logs.json
```

This CLAUDE.md file provides comprehensive commands for managing and demonstrating the SASE lab environment. Use these commands to explore SASE concepts, test security controls, and understand modern network security architectures.