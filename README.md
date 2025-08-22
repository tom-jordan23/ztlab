# SASE Lab Environment

A comprehensive Docker-based lab environment for learning and demonstrating **Secure Access Service Edge (SASE)** concepts using open source components.

## Quick Start

```bash
# Quick start using the startup script (recommended)
./start-sase-lab.sh

# Manual startup (alternative)
docker compose up -d

# Check service status
docker compose ps

# Access web interfaces
echo "Zitadel IAM: http://localhost:9080"
echo "OpenZiti Console: http://localhost:1280"
echo "OPNsense SWG: https://localhost:443"
echo "Kibana Dashboard: http://localhost:5601"
echo "Corporate HR App: http://localhost:9081"
echo "Corporate Files: http://localhost:9082"
echo "DMZ Web Server: http://localhost:9083"
echo "External Service: http://localhost:9084"

# Stop the lab
./stop-sase-lab.sh
```

## Architecture

This lab implements a complete SASE environment with:

- **Identity Management**: Zitadel for modern IAM
- **Zero Trust Access**: OpenZiti for ZTNA
- **Secure Web Gateway**: OPNsense with content filtering
- **Cloud Security**: Cloud Custodian for CASB simulation
- **Monitoring**: ELK Stack for security analytics
- **Network Simulation**: Multiple network zones and applications

## Documentation

- **[prompt.md](./prompt.md)** - Comprehensive lab overview and learning objectives
- **[CLAUDE.md](./CLAUDE.md)** - Complete command reference and operational procedures
- **[SASE-USE-CASES.md](./SASE-USE-CASES.md)** - Real-world use cases and implementation guides
- **[Architecture Diagrams](./docs/)** - Visual network and security architecture

## Directory Structure

```
ztlab/
├── docker-compose.yml          # Main orchestration file
├── config/                     # Service configurations
│   ├── ziti/                   # OpenZiti controller config
│   ├── opnsense/               # Firewall and SWG config
│   ├── vyos/                   # SD-WAN router config
│   ├── custodian/              # CASB policies
│   ├── logstash/               # Log processing pipelines
│   └── client/                 # Client configuration
├── apps/                       # Simulated applications
│   ├── corporate-app-1/        # HR Portal
│   ├── corporate-app-2/        # File Server
│   ├── dmz-web/                # DMZ Web Services
│   └── external-service/       # External/Internet simulation
├── CLAUDE.md                   # Command reference
├── prompt.md                   # Lab overview
└── README.md                   # This file
```

## SASE Components

### 🔐 Identity & Access Management (Simulation)
- Modern OAuth2/OIDC identity provider simulation
- Multi-factor authentication concepts
- User lifecycle management demonstration
- **Access**: http://localhost:9080

### 🛡️ Zero Trust Network Access (Simulation)
- Application-specific micro-tunnels concepts
- Identity-based access policies demonstration
- End-to-end encryption principles
- **Access**: http://localhost:1280

### 🌐 Secure Web Gateway (OPNsense)
- Web content filtering and inspection
- Malware detection and blocking
- SSL/TLS inspection
- **Access**: https://localhost:443

### ☁️ Cloud Access Security Broker (Simulation)
- Policy-as-code governance simulation
- Shadow IT detection concepts
- Data loss prevention demonstration
- **Access**: Docker exec commands

### 📊 Security Analytics (ELK Stack)
- Centralized log collection
- Real-time security dashboards
- Automated alerting
- **Access**: http://localhost:5601

## Network Topology

```
External Internet ←→ DMZ ←→ Corporate Internal
(192.168.200/24)   (172.16.0/24)   (10.10.0/16)
                          ↓
                   Management Network
                   (192.168.100/24)
```

## Lab Scenarios

1. **Zero Trust Access Control** - Secure remote access to corporate applications
2. **Web Threat Protection** - Malware and phishing detection/blocking
3. **Cloud Service Monitoring** - CASB protection for SaaS applications
4. **Network Segmentation** - Micro-segmentation and policy enforcement

## Learning Objectives

- Understand SASE architecture and components
- Implement zero trust security models
- Configure cloud-native security services
- Practice incident response and monitoring
- Develop practical enterprise security skills

## Prerequisites

- Docker and Docker Compose
- 8GB RAM minimum
- 50GB available disk space
- Basic networking knowledge
- Web browser for dashboards

## Port Usage

The lab uses the following ports (configured to avoid common conflicts):

- **9080**: Zitadel Identity Management
- **1280**: OpenZiti Controller Console  
- **443**: OPNsense Secure Web Gateway (HTTPS)
- **3128**: OPNsense Proxy Service
- **5601**: Kibana Analytics Dashboard
- **9081**: Corporate HR Application
- **9082**: Corporate File Server
- **9083**: DMZ Web Services
- **9084**: External/Internet Simulation
- **2223**: VyOS SSH Access
- **9444**: VyOS Web Interface

If you encounter port conflicts, check what services are using the ports:
```bash
# Check specific port usage
ss -tulpn | grep :PORT_NUMBER

# View all Docker containers and their ports
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

## Security Notice

⚠️ **For Educational Use Only**
- Contains simulated threats and vulnerabilities
- Do not use in production environments
- All credentials are demonstration-only
- Network traffic may be logged for analysis

## Support

- See [CLAUDE.md](./CLAUDE.md) for detailed commands and troubleshooting
- Check Docker logs for service-specific issues: `docker compose logs [service]`
- Consult [prompt.md](./prompt.md) for comprehensive lab documentation

## Contributing

This lab is designed for educational purposes. Contributions that enhance the learning experience or add new SASE components are welcome.

---

**Start exploring modern network security with hands-on SASE experience!**