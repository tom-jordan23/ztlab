# SASE Lab Environment - Common Use Cases

This document outlines real-world SASE (Secure Access Service Edge) use cases and provides step-by-step instructions for implementing and demonstrating them using the lab environment.

## Table of Contents

1. [Remote Worker Secure Access](#1-remote-worker-secure-access)
2. [Cloud Application Security](#2-cloud-application-security)
3. [Branch Office Connectivity](#3-branch-office-connectivity)
4. [Data Loss Prevention (DLP)](#4-data-loss-prevention-dlp)
5. [Web Threat Protection](#5-web-threat-protection)
6. [Shadow IT Discovery and Control](#6-shadow-it-discovery-and-control)
7. [Zero Trust Network Segmentation](#7-zero-trust-network-segmentation)
8. [Compliance and Audit Reporting](#8-compliance-and-audit-reporting)
9. [Incident Response and Forensics](#9-incident-response-and-forensics)
10. [Cloud Migration Security](#10-cloud-migration-security)

---

## 1. Remote Worker Secure Access

### **Business Scenario**
A distributed workforce needs secure access to corporate applications from anywhere, on any device, without traditional VPN complexity.

### **SASE Components Used**
- Zero Trust Network Access (OpenZiti)
- Identity and Access Management (Zitadel)
- Secure Web Gateway (OPNsense)

### **Lab Implementation**

#### Step 1: Start the Lab Environment
```bash
./start-sase-lab.sh
```

#### Step 2: Configure Identity Provider
```bash
# Access Zitadel IAM console
echo "Open browser to: http://localhost:9080"

# Create user accounts for remote workers
docker exec -it sase-zitadel /bin/sh
# Note: Use Zitadel web interface for user creation
```

#### Step 3: Set Up Zero Trust Access
```bash
# Access OpenZiti controller
echo "Open browser to: http://localhost:1280"

# Create identities for remote users
docker exec -it sase-ziti-controller ziti edge create identity user "remote-worker-1" -a "remote-workers"
docker exec -it sase-ziti-controller ziti edge create identity user "remote-worker-2" -a "remote-workers"

# Create service for HR application
docker exec -it sase-ziti-controller ziti edge create service "hr-portal" --configs "hr-config"

# Create service policy allowing access
docker exec -it sase-ziti-controller ziti edge create service-policy "remote-hr-access" Dial \
  --identity-roles "@remote-workers" --service-roles "@hr-services"
```

#### Step 4: Test Remote Access
```bash
# Simulate external user access attempt
curl -H "X-Forwarded-For: 203.0.113.45" http://localhost:9081

# Test authenticated access through secure gateway
curl -H "Authorization: Bearer demo-token" \
     -H "X-User-Email: remote-worker@company.com" \
     http://localhost:9081
```

#### Step 5: Monitor Access Patterns
```bash
# View access logs in Kibana
echo "Open Kibana dashboard: http://localhost:5601"
echo "Create index pattern: sase-logs-*"
echo "Filter by: component:ztna AND action:ALLOW"
```

### **Expected Outcomes**
- Secure access without VPN complexity
- Identity-based access control enforced
- All access attempts logged and monitored
- Automatic blocking of unauthorized access

---

## 2. Cloud Application Security

### **Business Scenario**
Organization uses multiple SaaS applications and needs to secure data, monitor usage, and prevent unauthorized access.

### **SASE Components Used**
- Cloud Access Security Broker (Cloud Custodian)
- Data Loss Prevention
- User and Entity Behavior Analytics

### **Lab Implementation**

#### Step 1: Configure CASB Policies
```bash
# Review existing CASB policies
cat config/custodian/policies.yaml

# Run policy evaluation
docker exec -it sase-casb custodian run --output-dir=/app/data /app/policies/policies.yaml

# Check for policy violations
docker exec -it sase-casb ls -la /app/data/
```

#### Step 2: Simulate Cloud Service Usage
```bash
# Simulate unauthorized file upload
echo "Confidential: Social Security Numbers: 123-45-6789, 987-65-4321" > /tmp/sensitive-data.txt

curl -X POST http://localhost:9084/upload \
  -F "file=@/tmp/sensitive-data.txt" \
  -H "X-User-Email: employee@company.com" \
  -H "X-Cloud-Service: unauthorized-storage"
```

#### Step 3: Monitor Cloud Security Events
```bash
# Generate cloud security logs
echo '{"timestamp":"'$(date -Iseconds)'","type":"casb","cloud_service":"Dropbox","user_email":"john.doe@company.com","action":"UPLOAD","resource":"financial-report.xlsx","risk_score":8}' | \
  docker exec -i sase-logstash logger

# View CASB activity in Corporate File Server
echo "Open browser to: http://localhost:9082"
echo "Check CASB Activity Log section"
```

#### Step 4: Test Data Classification
```bash
# Create files with different sensitivity levels
echo "Public information" > /tmp/public-doc.txt
echo "CONFIDENTIAL: Customer credit card data 4111-1111-1111-1111" > /tmp/pci-data.txt
echo "Employee SSN: 123-45-6789, Salary: $75,000" > /tmp/pii-data.txt

# Simulate uploads and check blocking
for file in public-doc.txt pci-data.txt pii-data.txt; do
  curl -X POST http://localhost:9082/upload -F "file=@/tmp/$file"
  sleep 1
done
```

### **Expected Outcomes**
- Automatic detection of sensitive data uploads
- Policy-based blocking of unauthorized cloud services
- Risk scoring and categorization of cloud activities
- Compliance reporting for cloud usage

---

## 3. Branch Office Connectivity

### **Business Scenario**
Multiple branch offices need secure, optimized connectivity to headquarters and cloud services.

### **SASE Components Used**
- SD-WAN (VyOS simulation)
- Secure Web Gateway
- Traffic Optimization and Routing

### **Lab Implementation**

#### Step 1: Configure SD-WAN Router
```bash
# Access the SD-WAN router
docker exec -it sase-vyos /bin/bash

# Check network interfaces and routing
ip addr show
ip route show

# Configure traffic policies
iptables -L
```

#### Step 2: Set Up Network Segmentation
```bash
# Test connectivity between network segments
docker exec -it sase-nettools ping -c 3 corporate-app-1
docker exec -it sase-nettools ping -c 3 dmz-web-server
docker exec -it sase-nettools ping -c 3 external-service

# Check network isolation
docker exec -it sase-vyos traceroute 10.10.1.1
docker exec -it sase-vyos traceroute 172.16.0.1
```

#### Step 3: Monitor Traffic Flows
```bash
# Generate inter-branch traffic
for i in {1..10}; do
  curl -s http://localhost:9081 > /dev/null
  curl -s http://localhost:9083 > /dev/null
  sleep 1
done

# View traffic statistics
docker exec -it sase-vyos netstat -i
docker exec -it sase-vyos ss -tuln
```

#### Step 4: Test Failover Scenarios
```bash
# Simulate network issues
docker exec -it sase-vyos iptables -A OUTPUT -d 172.16.0.0/24 -j DROP

# Test alternative routing
docker exec -it sase-nettools traceroute dmz-web-server

# Restore connectivity
docker exec -it sase-vyos iptables -F OUTPUT
```

### **Expected Outcomes**
- Optimized routing between branch offices
- Automatic failover and redundancy
- Centralized network management and monitoring
- Quality of Service (QoS) enforcement

---

## 4. Data Loss Prevention (DLP)

### **Business Scenario**
Prevent sensitive data from leaving the organization through email, file uploads, or unauthorized cloud services.

### **SASE Components Used**
- Data Loss Prevention Engine
- Content Inspection
- Cloud Access Security Broker

### **Lab Implementation**

#### Step 1: Create Test Data with PII
```bash
# Create various sensitive data patterns
cat > /tmp/customer-data.csv << EOF
Name,Email,SSN,Credit Card
John Doe,john@example.com,123-45-6789,4111-1111-1111-1111
Jane Smith,jane@example.com,987-65-4321,5555-5555-5555-4444
Bob Johnson,bob@example.com,456-78-9012,3782-822463-10005
EOF

cat > /tmp/financial-report.txt << EOF
Q3 Financial Report
Revenue: $2,500,000
Customer SSNs for reference:
- 123-45-6789
- 987-65-4321
Bank Account: 123456789
EOF
```

#### Step 2: Test DLP Policies
```bash
# Attempt to upload sensitive files
curl -X POST http://localhost:9082/upload \
  -F "file=@/tmp/customer-data.csv" \
  -H "X-User-Email: employee@company.com"

curl -X POST http://localhost:9082/upload \
  -F "file=@/tmp/financial-report.txt" \
  -H "X-User-Email: finance@company.com"

# Check DLP blocking in Corporate File Server
echo "Open browser to: http://localhost:9082"
echo "Look for blocked uploads in the file list"
```

#### Step 3: Monitor DLP Events
```bash
# Generate DLP violation logs
echo '{"timestamp":"'$(date -Iseconds)'","type":"dlp","violation":"PII_DETECTED","file":"customer-list.xlsx","patterns":["SSN","Credit Card"],"user":"john.doe@company.com","action":"BLOCKED"}' | \
  docker exec -i sase-logstash logger

# Create DLP dashboard queries
curl -X POST "localhost:5601/api/saved_objects/visualization" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "DLP Violations by Type",
      "type": "histogram"
    }
  }'
```

#### Step 4: Test Email DLP
```bash
# Simulate email with sensitive content
curl -X POST http://localhost:9083/send-email \
  -H "Content-Type: application/json" \
  -d '{
    "to": "external@competitor.com",
    "subject": "Customer Information",
    "body": "Customer SSN: 123-45-6789, Credit Card: 4111-1111-1111-1111"
  }'
```

### **Expected Outcomes**
- Automatic detection of sensitive data patterns
- Real-time blocking of data exfiltration attempts
- Detailed violation reporting and analytics
- Policy-based handling of different data types

---

## 5. Web Threat Protection

### **Business Scenario**
Protect users from web-based threats including malware, phishing, and malicious websites.

### **SASE Components Used**
- Secure Web Gateway (OPNsense)
- URL Filtering
- Malware Detection

### **Lab Implementation**

#### Step 1: Test Malware Blocking
```bash
# Test malware URL blocking
curl -v https://localhost:443/malware

# Test executable file blocking
wget --no-check-certificate https://localhost:443/malware/virus.exe

# Check blocked responses
curl -I https://localhost:443/malware/trojan.exe
```

#### Step 2: Test Phishing Protection
```bash
# Test phishing site blocking
curl -v https://localhost:443/phishing

# Simulate phishing email links
curl -H "Referer: phishing-email" https://localhost:443/fake-bank-login
```

#### Step 3: Test Category-Based Filtering
```bash
# Test different website categories
curl -H "Host: social-media.com" http://localhost:3128/
curl -H "Host: gambling.com" http://localhost:3128/
curl -H "Host: news.com" http://localhost:3128/

# Test suspicious file extensions
curl https://localhost:443/downloads/file.exe
curl https://localhost:443/downloads/document.pdf
```

#### Step 4: Monitor Threat Detection
```bash
# Generate web threat logs
for i in {1..5}; do
  curl -s https://localhost:443/malware >/dev/null 2>&1
  curl -s https://localhost:443/phishing >/dev/null 2>&1
  sleep 2
done

# View threat statistics in External Service
echo "Open browser to: http://localhost:9084"
echo "Check Attack Statistics section"
```

#### Step 5: Test SSL Inspection
```bash
# Test HTTPS inspection capabilities
openssl s_client -connect localhost:443 -servername sase-lab.local

# Check certificate validation
curl -v -k https://localhost:443/ 2>&1 | grep -i certificate
```

### **Expected Outcomes**
- Real-time malware detection and blocking
- Phishing site identification and prevention
- Category-based web filtering enforcement
- SSL/TLS inspection and certificate validation

---

## 6. Shadow IT Discovery and Control

### **Business Scenario**
Identify and control unauthorized cloud services and applications used by employees.

### **SASE Components Used**
- Cloud Access Security Broker
- Network Traffic Analysis
- Application Discovery

### **Lab Implementation**

#### Step 1: Simulate Shadow IT Usage
```bash
# Simulate unauthorized cloud storage access
curl -H "Host: unauthorized-dropbox.com" \
     -H "X-User: employee@company.com" \
     http://localhost:9084/upload-file

# Simulate personal cloud email
curl -H "Host: personal-gmail.com" \
     -H "X-User: employee@company.com" \
     http://localhost:9084/send-email

# Simulate unauthorized collaboration tools
curl -H "Host: unauthorized-slack.com" \
     -H "X-User: employee@company.com" \
     http://localhost:9084/chat
```

#### Step 2: Configure Shadow IT Detection
```bash
# Update CASB policies for shadow IT detection
docker exec -it sase-casb cat /app/policies/policies.yaml | grep -A 10 "shadow-it"

# Run shadow IT detection scan
docker exec -it sase-casb custodian run \
  --policy-filter="name=detect-shadow-it" \
  /app/policies/policies.yaml
```

#### Step 3: Monitor Unauthorized Services
```bash
# Generate shadow IT alerts
echo '{"timestamp":"'$(date -Iseconds)'","type":"casb","event":"shadow_it_detected","service":"unauthorized_dropbox","user":"john.doe@company.com","risk_level":"high","action":"blocked"}' | \
  docker exec -i sase-logstash logger

# Check Corporate File Server for shadow IT detection
echo "Open browser to: http://localhost:9082"
echo "Look for shadow IT detection in CASB Activity Log"
```

#### Step 4: Implement Control Policies
```bash
# Block unauthorized cloud services via proxy
curl -x localhost:3128 http://unauthorized-cloud-service.com

# Test approved vs. unapproved services
curl -x localhost:3128 http://approved-box.com
curl -x localhost:3128 http://unauthorized-dropbox.com
```

### **Expected Outcomes**
- Comprehensive discovery of unauthorized cloud services
- Risk assessment and categorization of shadow IT
- Automated blocking of high-risk services
- User awareness and policy enforcement

---

## 7. Zero Trust Network Segmentation

### **Business Scenario**
Implement microsegmentation to limit lateral movement and enforce least-privilege access.

### **SASE Components Used**
- Zero Trust Network Access
- Network Segmentation
- Identity-Based Access Control

### **Lab Implementation**

#### Step 1: Map Network Zones
```bash
# Identify network segments
docker network ls | grep ztlab

# Test current connectivity between zones
docker exec -it sase-nettools ping -c 1 corporate-app-1  # Should work
docker exec -it sase-nettools ping -c 1 dmz-web-server   # Should work
docker exec -it sase-client ping -c 1 dmz-web-server     # Should be limited
```

#### Step 2: Implement Microsegmentation
```bash
# Create identity-based network policies
docker exec -it sase-ziti-controller ziti edge create identity device "laptop-001" -a "employee-devices"
docker exec -it sase-ziti-controller ziti edge create identity device "server-001" -a "production-servers"

# Create segmentation policies
docker exec -it sase-ziti-controller ziti edge create edge-router-policy "employee-access" \
  --identity-roles "@employee-devices" --edge-router-roles "@employee-routers"

docker exec -it sase-ziti-controller ziti edge create service-policy "production-access" Bind \
  --identity-roles "@production-servers" --service-roles "@production-services"
```

#### Step 3: Test Access Controls
```bash
# Test legitimate access
curl -H "X-Device-ID: laptop-001" \
     -H "X-User-Role: employee" \
     http://localhost:9081

# Test unauthorized access
curl -H "X-Device-ID: unknown-device" \
     -H "X-User-Role: guest" \
     http://localhost:9081

# Test cross-segment access
docker exec -it sase-client curl http://dmz-web-server
docker exec -it sase-dmz-web curl http://corporate-app-1
```

#### Step 4: Monitor Segmentation Violations
```bash
# Generate segmentation violation logs
echo '{"timestamp":"'$(date -Iseconds)'","type":"ztna","event":"segmentation_violation","src_zone":"dmz","dst_zone":"corporate","user":"compromised-account","action":"DENIED"}' | \
  docker exec -i sase-logstash logger

# Create network flow visualization
echo "Open Kibana: http://localhost:5601"
echo "Create network flow dashboard with source/destination zones"
```

### **Expected Outcomes**
- Strict network segmentation between trust zones
- Identity-based access control enforcement
- Prevention of lateral movement
- Detailed network flow monitoring and alerting

---

## 8. Compliance and Audit Reporting

### **Business Scenario**
Generate compliance reports for regulations like GDPR, HIPAA, PCI-DSS, and SOX.

### **SASE Components Used**
- Security Information and Event Management
- Audit Logging
- Compliance Reporting

### **Lab Implementation**

#### Step 1: Configure Audit Logging
```bash
# Check logging configuration
docker exec -it sase-logstash cat /usr/share/logstash/pipeline/logstash.conf

# Verify log collection
curl http://localhost:9200/_cat/indices | grep sase-logs
```

#### Step 2: Generate Compliance Events
```bash
# Generate GDPR-related events
echo '{"timestamp":"'$(date -Iseconds)'","type":"gdpr","event":"data_access","user":"john.doe@company.com","data_type":"personal_data","purpose":"customer_service","legal_basis":"consent"}' | \
  docker exec -i sase-logstash logger

# Generate PCI-DSS events
echo '{"timestamp":"'$(date -Iseconds)'","type":"pci","event":"card_data_access","user":"payment_processor","card_holder":"*1111","transaction_id":"txn_123456"}' | \
  docker exec -i sase-logstash logger

# Generate access control events
echo '{"timestamp":"'$(date -Iseconds)'","type":"access_control","event":"privilege_elevation","user":"admin@company.com","previous_role":"user","new_role":"admin","approver":"manager@company.com"}' | \
  docker exec -i sase-logstash logger
```

#### Step 3: Create Compliance Dashboards
```bash
# Access Kibana for dashboard creation
echo "Open Kibana: http://localhost:5601"

# Create compliance-specific index patterns
curl -X POST "localhost:5601/api/saved_objects/index-pattern/compliance-logs" \
  -H "Content-Type: application/json" \
  -H "kbn-xsrf: true" \
  -d '{
    "attributes": {
      "title": "sase-logs-*",
      "timeFieldName": "@timestamp"
    }
  }'
```

#### Step 4: Generate Compliance Reports
```bash
# Query for GDPR compliance data
curl -X GET "localhost:9200/sase-logs-*/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"term": {"type": "gdpr"}},
          {"range": {"@timestamp": {"gte": "now-30d"}}}
        ]
      }
    },
    "aggs": {
      "data_types": {
        "terms": {"field": "data_type.keyword"}
      }
    }
  }' | jq '.aggregations'

# Generate access report
curl -X GET "localhost:9200/sase-logs-*/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "term": {"type": "access_control"}
    },
    "size": 100,
    "sort": [{"@timestamp": {"order": "desc"}}]
  }' | jq '.hits.hits[]._source'
```

### **Expected Outcomes**
- Comprehensive audit trails for all user activities
- Automated compliance reporting generation
- Real-time monitoring of compliance violations
- Historical data analysis for audit purposes

---

## 9. Incident Response and Forensics

### **Business Scenario**
Rapidly detect, investigate, and respond to security incidents using SASE telemetry.

### **SASE Components Used**
- Security Analytics
- Incident Detection
- Forensic Capabilities

### **Lab Implementation**

#### Step 1: Simulate Security Incident
```bash
# Simulate credential stuffing attack
for i in {1..20}; do
  curl -X POST http://localhost:9081/login \
    -H "X-Forwarded-For: 192.168.200.99" \
    -d "username=admin&password=password$i"
  sleep 0.5
done

# Simulate data exfiltration
curl -X POST http://localhost:9084/upload \
  -F "file=@/tmp/customer-data.csv" \
  -H "X-User-Email: compromised@company.com" \
  -H "X-Forwarded-For: 203.0.113.45"
```

#### Step 2: Configure Incident Detection Rules
```bash
# Generate security incident alerts
echo '{"timestamp":"'$(date -Iseconds)'","type":"security_incident","severity":"high","event":"brute_force_attack","source_ip":"192.168.200.99","target":"hr-portal","attempts":20,"time_window":"60s"}' | \
  docker exec -i sase-logstash logger

echo '{"timestamp":"'$(date -Iseconds)'","type":"security_incident","severity":"critical","event":"data_exfiltration","user":"compromised@company.com","file_size":"2.5MB","destination":"external_storage","data_classification":"confidential"}' | \
  docker exec -i sase-logstash logger
```

#### Step 3: Incident Investigation
```bash
# Search for related events
curl -X GET "localhost:9200/sase-security-alerts-*/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"term": {"source_ip": "192.168.200.99"}},
          {"range": {"@timestamp": {"gte": "now-1h"}}}
        ]
      }
    },
    "sort": [{"@timestamp": {"order": "asc"}}]
  }' | jq '.hits.hits[]._source'

# Timeline analysis
curl -X GET "localhost:9200/sase-logs-*/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "term": {"user.keyword": "compromised@company.com"}
    },
    "size": 50,
    "sort": [{"@timestamp": {"order": "asc"}}]
  }' | jq '.hits.hits[]._source | {timestamp, event, source_ip, action}'
```

#### Step 4: Automated Response
```bash
# Simulate automated blocking
echo '{"timestamp":"'$(date -Iseconds)'","type":"automated_response","action":"ip_blocked","source_ip":"192.168.200.99","rule":"brute_force_protection","duration":"24h"}' | \
  docker exec -i sase-logstash logger

# Simulate user account suspension
echo '{"timestamp":"'$(date -Iseconds)'","type":"automated_response","action":"account_suspended","user":"compromised@company.com","reason":"suspicious_activity","approver":"security_system"}' | \
  docker exec -i sase-logstash logger
```

### **Expected Outcomes**
- Rapid incident detection and alerting
- Comprehensive forensic data collection
- Automated response and containment
- Detailed incident timeline reconstruction

---

## 10. Cloud Migration Security

### **Business Scenario**
Securely migrate applications and data to the cloud while maintaining security controls.

### **SASE Components Used**
- Cloud Access Security Broker
- Data Protection
- Network Security

### **Lab Implementation**

#### Step 1: Pre-Migration Assessment
```bash
# Assess current security posture
docker exec -it sase-casb custodian run \
  --policy-filter="name=unencrypted-storage" \
  /app/policies/policies.yaml

# Inventory current applications
echo "Current on-premises applications:"
echo "- HR Portal: http://localhost:9081"
echo "- File Server: http://localhost:9082"
echo "- Web Services: http://localhost:9083"
```

#### Step 2: Implement Cloud Security Controls
```bash
# Configure cloud-specific policies
cat >> /tmp/cloud-migration-policies.yaml << 'EOF'
policies:
  - name: cloud-migration-encryption
    resource: aws.s3
    description: Ensure all migrated data is encrypted
    filters:
      - type: value
        key: encrypted
        value: false
    actions:
      - type: set-encryption
        key: AES256

  - name: cloud-migration-access
    resource: aws.iam-user
    description: Monitor new cloud access patterns
    filters:
      - type: credential-report
      - type: value
        key: access_key_1_last_used_date
        op: less-than
        value_type: age
        value: 1
    actions:
      - type: notify
        violation_desc: "New cloud access detected during migration"
EOF

# Apply migration policies
docker exec -it sase-casb custodian run /tmp/cloud-migration-policies.yaml
```

#### Step 3: Monitor Migration Activities
```bash
# Simulate cloud migration events
echo '{"timestamp":"'$(date -Iseconds)'","type":"cloud_migration","event":"data_transfer","source":"on_premises","destination":"aws_s3","data_size":"500MB","classification":"confidential","encrypted":true}' | \
  docker exec -i sase-logstash logger

echo '{"timestamp":"'$(date -Iseconds)'","type":"cloud_migration","event":"application_cutover","application":"hr_portal","old_endpoint":"internal","new_endpoint":"cloud","user_impact":"minimal"}' | \
  docker exec -i sase-logstash logger
```

#### Step 4: Validate Post-Migration Security
```bash
# Test cloud application security
curl -H "X-Cloud-Provider: AWS" \
     -H "X-Migration-Phase: post-cutover" \
     http://localhost:9081

# Verify data protection
curl -X GET http://localhost:9084/cloud-storage/validate-encryption

# Check compliance posture
curl -X GET "localhost:9200/sase-logs-*/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"term": {"type": "cloud_migration"}},
          {"term": {"encrypted": false}}
        ]
      }
    }
  }' | jq '.hits.total.value'
```

### **Expected Outcomes**
- Secure data migration with continuous protection
- Validation of cloud security controls
- Compliance maintenance during migration
- Real-time monitoring of migration activities

---

## Advanced Scenarios and Integration

### Multi-Use Case Integration

Many real-world scenarios combine multiple use cases. Here are some integrated examples:

#### Scenario: Remote Worker with Cloud Applications
```bash
# Start comprehensive monitoring
./start-sase-lab.sh

# Simulate remote worker accessing cloud SaaS
curl -H "X-Forwarded-For: 203.0.113.45" \
     -H "X-User-Role: remote-employee" \
     -H "X-Cloud-Service: approved-saas" \
     http://localhost:9081

# Monitor across all SASE components
echo "Check multiple dashboards:"
echo "- Identity: http://localhost:9080"
echo "- ZTNA: http://localhost:1280"
echo "- SWG: https://localhost:443"
echo "- Analytics: http://localhost:5601"
```

#### Scenario: Security Incident During Cloud Migration
```bash
# Simulate incident during migration
echo '{"timestamp":"'$(date -Iseconds)'","type":"security_incident","event":"migration_compromise","severity":"high","details":"Unauthorized access during cloud cutover"}' | \
  docker exec -i sase-logstash logger

# Implement emergency response
echo '{"timestamp":"'$(date -Iseconds)'","type":"incident_response","action":"emergency_rollback","migration_halted":true,"security_team_notified":true}' | \
  docker exec -i sase-logstash logger
```

### Custom Use Case Development

To create your own use cases:

1. **Identify Business Objective**: Define what you want to accomplish
2. **Map SASE Components**: Determine which components are needed
3. **Create Test Scenarios**: Develop realistic test data and situations
4. **Implement Monitoring**: Set up appropriate logging and alerting
5. **Validate Outcomes**: Verify that security objectives are met

### Troubleshooting Common Issues

#### Service Connectivity Issues
```bash
# Check service status
docker compose ps

# Test network connectivity
docker exec -it sase-nettools ping corporate-app-1
docker exec -it sase-nettools nslookup zitadel
```

#### Logging and Monitoring Issues
```bash
# Check Elasticsearch health
curl http://localhost:9200/_cluster/health

# Verify Logstash pipeline
docker exec -it sase-logstash /usr/share/logstash/bin/logstash --config.test_and_exit

# Check Kibana connectivity
curl http://localhost:5601/api/status
```

#### Configuration Issues
```bash
# Validate Docker Compose configuration
docker compose config --quiet

# Check service logs
docker compose logs sase-zitadel
docker compose logs sase-ziti-controller
```

---

## Conclusion

This SASE lab environment provides comprehensive hands-on experience with real-world security scenarios. Each use case demonstrates practical implementation of SASE principles and technologies, helping you understand how to:

- Implement zero trust security models
- Protect remote workers and cloud applications
- Prevent data loss and detect threats
- Maintain compliance and generate audit reports
- Respond to security incidents effectively

For additional use cases or custom scenarios, refer to the main documentation in `CLAUDE.md` and `prompt.md`. The lab environment is designed to be flexible and extensible for exploring various SASE concepts and implementations.

**Remember**: This lab is for educational purposes only. Always follow your organization's security policies and procedures when implementing SASE solutions in production environments.