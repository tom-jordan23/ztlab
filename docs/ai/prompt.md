# SASE Lab Environment - Educational Platform

## Overview

This lab provides a comprehensive, hands-on learning environment for understanding **Secure Access Service Edge (SASE)** architecture, implementation, and security concepts. SASE represents the convergence of networking and security services delivered as a unified, cloud-native platform.

## What is SASE?

**Secure Access Service Edge (SASE)** is a cybersecurity framework that combines:

- **Software-Defined Wide Area Network (SD-WAN)** - Intelligent traffic routing and network optimization
- **Zero Trust Network Access (ZTNA)** - Identity-based access control with continuous verification
- **Secure Web Gateway (SWG)** - Web traffic filtering, malware protection, and policy enforcement
- **Cloud Access Security Broker (CASB)** - Cloud service security, data protection, and compliance monitoring
- **Firewall as a Service (FWaaS)** - Next-generation firewall capabilities delivered from the cloud

## Lab Learning Objectives

By completing this lab, you will:

### 🎯 **Architecture Understanding**
- Understand SASE components and their interactions
- Learn how traditional network security evolves to cloud-native SASE
- Explore network segmentation and zero trust principles
- Analyze traffic flows between different security zones

### 🔐 **Security Concepts**
- Implement zero trust access controls with identity verification
- Configure secure web gateway policies and content filtering
- Deploy cloud access security broker for SaaS protection
- Set up network firewalls with advanced threat detection
- Monitor and analyze security events in real-time

### 🛠️ **Hands-On Experience**
- Deploy a complete SASE environment using open source tools
- Configure identity and access management systems
- Test security policies and incident response procedures
- Practice network troubleshooting and security analysis
- Generate and analyze security logs and metrics

### 📊 **Real-World Skills**
- Understand modern enterprise network architecture
- Learn cloud security best practices and compliance requirements
- Develop skills in security monitoring and incident detection
- Practice with industry-standard tools and technologies

## Lab Architecture

### 🏗️ **Network Topology**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   External      │    │      DMZ        │    │   Corporate     │
│   Internet      │    │   (172.16.0/24) │    │  (10.10.0/16)   │
│ (192.168.200/24)│    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Management    │
                    │ (192.168.100/24)│
                    └─────────────────┘
```

### 🛡️ **Security Components**

1. **Identity Management (Zitadel)**
   - Modern IAM platform with OAuth2/OIDC support
   - Multi-factor authentication and user lifecycle management
   - Integration with ZTNA for identity-based access control

2. **Zero Trust Access (OpenZiti)**
   - Application-specific micro-tunnels
   - Identity-based access policies
   - End-to-end encryption for all connections

3. **Secure Web Gateway (OPNsense + Nginx)**
   - URL filtering and content inspection
   - Malware detection and blocking
   - SSL/TLS inspection and certificate validation

4. **Cloud Security (Cloud Custodian)**
   - Policy-as-code for cloud resource governance
   - Automated compliance checking and remediation
   - Shadow IT detection and data loss prevention

5. **Network Security (Firewall)**
   - Network segmentation and traffic control
   - Intrusion detection and prevention
   - Geo-blocking and reputation-based filtering

6. **Monitoring Platform (ELK Stack)**
   - Centralized log collection and analysis
   - Real-time security dashboards
   - Automated alerting and incident detection

### 📱 **Simulated Applications**

- **Corporate HR Portal** - Internal employee management system
- **File Server** - Document storage with DLP protection
- **DMZ Web Services** - Public-facing applications and APIs
- **External Services** - Internet threats and attack simulations

## Use Cases and Scenarios

### 🎭 **Scenario 1: Remote Worker Access**
**Objective**: Demonstrate secure remote access to corporate applications

**Steps**:
1. Employee attempts to access HR portal from external network
2. ZTNA validates user identity and device compliance
3. Micro-tunnel established for secure application access
4. Activity monitored and logged for compliance

### 🎭 **Scenario 2: Web Threat Protection**
**Objective**: Show how SWG protects against web-based threats

**Steps**:
1. User attempts to visit malicious website
2. SWG blocks access based on threat intelligence
3. Alternative legitimate resources suggested
4. Security incident logged and reported

### 🎭 **Scenario 3: Cloud Service Monitoring**
**Objective**: Demonstrate CASB protection for cloud applications

**Steps**:
1. User uploads sensitive file to unauthorized cloud service
2. CASB detects policy violation and blocks transfer
3. Data classification and handling policies enforced
4. Compliance violation reported to security team

### 🎭 **Scenario 4: Network Segmentation**
**Objective**: Show zero trust network segmentation

**Steps**:
1. Application in DMZ attempts to access corporate database
2. Firewall enforces micro-segmentation policies
3. Only authorized connections permitted
4. All traffic logged and analyzed

## Prerequisites

### 💻 **Technical Requirements**
- Docker and Docker Compose installed
- Minimum 8GB RAM and 50GB disk space
- Modern web browser for accessing dashboards
- Basic understanding of networking concepts

### 📚 **Knowledge Prerequisites**
- Familiarity with IP networking and subnets
- Understanding of web protocols (HTTP/HTTPS)
- Basic knowledge of security concepts
- Experience with command-line interfaces

## Getting Started

### 🚀 **Quick Start (5 minutes)**
```bash
# Clone the lab environment
git clone https://github.com/your-repo/sase-lab
cd sase-lab

# Start all services
docker compose up -d

# Check service status
docker compose ps

# Access web interfaces
echo "Open your browser to:"
echo "- Zitadel IAM: http://localhost:8080"
echo "- OpenZiti Console: http://localhost:1280"
echo "- Kibana Dashboard: http://localhost:5601"
echo "- Corporate Apps: http://localhost:8081-8084"
```

### 🔧 **Configuration (15 minutes)**
1. Configure identity providers in Zitadel
2. Set up zero trust policies in OpenZiti
3. Define security policies for web gateway
4. Configure monitoring dashboards in Kibana

### 🧪 **Testing (30 minutes)**
1. Test user authentication and access controls
2. Simulate security threats and verify blocking
3. Monitor security events in real-time dashboards
4. Practice incident response procedures

## Learning Path

### 👶 **Beginner (Week 1-2)**
- Understand SASE concepts and architecture
- Explore the lab environment and components
- Complete basic configuration exercises
- Run simple security scenarios

### 🧑‍🎓 **Intermediate (Week 3-4)**
- Configure advanced security policies
- Integrate external threat intelligence
- Customize monitoring and alerting
- Practice incident response workflows

### 🏆 **Advanced (Week 5-6)**
- Design custom security architectures
- Integrate with external security tools
- Develop automation scripts and policies
- Lead security assessment exercises

## Assessment and Validation

### ✅ **Knowledge Checks**
- Configure ZTNA policies for different user roles
- Set up web filtering rules for various threat categories
- Create CASB policies for cloud service governance
- Design network segmentation for compliance requirements

### 🏅 **Practical Exercises**
- Conduct simulated phishing attack and measure response
- Implement data loss prevention for sensitive information
- Configure single sign-on for multiple applications
- Create security dashboard for executive reporting

### 📝 **Documentation Projects**
- Document your lab configuration and customizations
- Create incident response playbooks for common scenarios
- Develop security awareness training materials
- Write technical reports on security improvements

## Industry Relevance

### 🏢 **Real-World Applications**
- **Enterprise Security**: Modern companies use SASE to secure remote workforces
- **Cloud Migration**: Organizations adopt SASE when moving to cloud-first architectures
- **Compliance**: SASE helps meet regulatory requirements for data protection
- **Cost Optimization**: Unified platforms reduce complexity and operational costs

### 💼 **Career Opportunities**
- **Security Architect**: Design and implement SASE solutions
- **Network Security Engineer**: Configure and maintain SASE components
- **Cloud Security Specialist**: Secure cloud services and data
- **SOC Analyst**: Monitor and respond to security events
- **Compliance Manager**: Ensure regulatory compliance through SASE controls

## Support and Community

### 📖 **Documentation**
- [CLAUDE.md](./CLAUDE.md) - Complete command reference and procedures
- [Architecture Diagrams](./docs/) - Visual representations of lab components
- [Troubleshooting Guide](./docs/troubleshooting.md) - Common issues and solutions

### 🤝 **Community Resources**
- Join the SASE community discussion forums
- Follow industry blogs and threat intelligence sources
- Participate in security conferences and webinars
- Contribute to open source security projects

### 🆘 **Getting Help**
- Check the troubleshooting section in CLAUDE.md
- Review Docker logs for service-specific issues
- Consult vendor documentation for individual components
- Engage with the community for advanced questions

## Conclusion

This SASE lab environment provides a comprehensive platform for learning modern network security architectures. By working through the scenarios and exercises, you'll gain practical experience with cutting-edge security technologies and develop skills directly applicable to enterprise environments.

The hands-on approach ensures you understand not just the theory behind SASE, but also the practical implementation challenges and solutions. Whether you're a security professional looking to update your skills or a student entering the cybersecurity field, this lab provides valuable experience with industry-standard tools and methodologies.

**Start your SASE journey today and build the skills needed for tomorrow's security challenges!**

---

*This lab is designed for educational purposes. All simulated threats and vulnerabilities are contained within the lab environment and pose no risk to production systems.*