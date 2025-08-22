# SASE Lab Environment - Common Use Cases

This document provides step-by-step instructions for experiencing real-world SASE (Secure Access Service Edge) scenarios using the lab environment. Each use case demonstrates how modern organizations implement zero trust security.

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

### **SASE Components Demonstrated**
- Zero Trust Network Access (ZTNA)
- Identity and Access Management (IAM)
- Secure Web Gateway (SWG)

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Explore Identity Management
1. Open your web browser
2. Navigate to **http://localhost:9080** (Identity Management)
3. Review the IAM simulation interface
4. Note the features: Multi-factor authentication, User lifecycle management, Enterprise SSO

#### Step 3: Access Zero Trust Controller
1. In your browser, navigate to **http://localhost:1280** (Zero Trust Access)
2. Observe the ZTNA simulation interface
3. In production, this would show:
   - Application-specific micro-tunnels
   - Identity-based access policies
   - Real-time access decisions

#### Step 4: Test Corporate Application Access
1. Navigate to **http://localhost:9081** (Corporate HR Portal)
2. Notice the security status indicators:
   - ✅ ZTNA Protected
   - 🛡️ Firewall Enabled
   - 🔐 End-to-End Encrypted
   - 👤 Identity Verified
3. Review the access log at the bottom showing security events

#### Step 5: Monitor Security Analytics
1. Open **http://localhost:5601** (Kibana Dashboard)
2. Set up index patterns for `sase-logs-*`
3. Create visualizations to monitor:
   - User authentication attempts
   - Application access patterns
   - Geographic access locations
   - Failed access attempts

### **What You've Learned**
- How zero trust validates every access request
- The role of identity in modern security architecture
- Real-time monitoring of user access patterns
- Benefits of application-specific security controls

---

## 2. Cloud Application Security

### **Business Scenario**
Organization uses multiple SaaS applications and needs to secure data, monitor usage, and prevent unauthorized access.

### **SASE Components Used**
- Cloud Access Security Broker (Cloud Custodian)
- Data Loss Prevention
- User and Entity Behavior Analytics

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access CASB Configuration
1. Navigate to **http://localhost:9082** (Corporate File Server)
2. Scroll down to the "CASB Activity Log" section
3. Review existing policy configurations and monitoring capabilities
4. Note the different risk levels and policy enforcement options

#### Step 3: Test Cloud Service Usage
1. Open **http://localhost:9084** (External Service)
2. In the "Cloud Service Simulation" section:
   - Select "Unauthorized Storage" from the dropdown
   - Try uploading a test file
   - Observe the security blocking and risk assessment
3. Return to **http://localhost:9082** to view the blocked attempt in the CASB Activity Log

#### Step 4: Monitor Data Classification
1. In the External Service (**http://localhost:9084**):
   - Test uploading files with different sensitivity levels:
     - Public documents (allowed)
     - Files containing credit card numbers (blocked)
     - Files containing social security numbers (blocked)
2. Watch real-time data classification in action
3. Check the Corporate File Server (**http://localhost:9082**) for detailed classification reports

### **What You've Learned**
- How CASB solutions monitor and control cloud service usage
- Automatic data classification and sensitivity detection
- Policy-based blocking of unauthorized cloud services
- Real-time risk assessment and compliance monitoring for cloud activities

---

## 3. Branch Office Connectivity

### **Business Scenario**
Multiple branch offices need secure, optimized connectivity to headquarters and cloud services.

### **SASE Components Used**
- SD-WAN (VyOS simulation)
- Secure Web Gateway
- Traffic Optimization and Routing

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Network Management
1. Navigate to **http://localhost:9444** (VyOS Network Management)
2. Review the network topology showing different zones:
   - Corporate Network (10.10.0.0/16)
   - DMZ Network (172.16.0.0/24)
   - External Network (192.168.200.0/24)
   - Management Network (192.168.100.0/24)
3. Observe the routing policies and traffic optimization settings

#### Step 3: Test Network Connectivity
1. Open **http://localhost:9081** (Corporate HR Portal)
2. Notice the network path indicators showing optimized routing
3. Try accessing **http://localhost:9083** (DMZ Web Server)
4. Compare response times and routing efficiency between different network zones

#### Step 4: Monitor Traffic Flows
1. Return to the VyOS interface (**http://localhost:9444**)
2. View the "Traffic Statistics" section
3. Generate test traffic by refreshing the corporate applications multiple times
4. Watch real-time traffic flow visualization and bandwidth utilization

#### Step 5: Explore Failover Capabilities
1. In the VyOS interface, locate the "Network Resilience" section
2. Review failover policies and redundancy configurations
3. Observe how traffic automatically reroutes during network issues
4. Check the "Network Health" dashboard for connectivity status

### **What You've Learned**
- How SD-WAN optimizes routing between distributed locations
- The benefits of centralized network management and monitoring
- Automatic failover and redundancy capabilities
- Quality of Service (QoS) enforcement for business-critical applications

---

## 4. Data Loss Prevention (DLP)

### **Business Scenario**
Prevent sensitive data from leaving the organization through email, file uploads, or unauthorized cloud services.

### **SASE Components Used**
- Data Loss Prevention Engine
- Content Inspection
- Cloud Access Security Broker

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Data Loss Prevention Interface
1. Navigate to **http://localhost:9082** (Corporate File Server)
2. Scroll to the "Data Loss Prevention" section
3. Review the current DLP policies:
   - Social Security Number detection
   - Credit card number detection
   - Confidential document classification
   - Email content scanning

#### Step 3: Test File Upload Protection
1. In the Corporate File Server, try the "Test DLP" feature:
   - Upload a "Normal Document" (should be allowed)
   - Upload "Customer Data with SSN" (should be blocked)
   - Upload "Financial Report with Credit Cards" (should be blocked)
2. Observe the real-time DLP analysis and blocking messages
3. Note the detailed violation reports showing exactly what sensitive data was detected

#### Step 4: Monitor DLP Analytics
1. Open **http://localhost:5601** (Kibana Dashboard)
2. Look for the DLP monitoring section
3. Review visualizations showing:
   - Types of sensitive data detected
   - Violation trends over time
   - User behavior patterns
   - Most common policy violations

#### Step 5: Test Email DLP Protection
1. Navigate to **http://localhost:9083** (DMZ Web Server)
2. Find the "Email DLP Test" section
3. Try sending emails with different content:
   - Normal business email (allowed)
   - Email containing credit card numbers (blocked)
   - Email with social security numbers (blocked)
4. Watch real-time email content analysis and policy enforcement

### **What You've Learned**
- How DLP systems automatically detect sensitive data patterns
- Real-time blocking of data exfiltration attempts
- The importance of policy-based data classification
- How to monitor and analyze data protection violations

---

## 5. Web Threat Protection

### **Business Scenario**
Protect users from web-based threats including malware, phishing, and malicious websites.

### **SASE Components Used**
- Secure Web Gateway (OPNsense)
- URL Filtering
- Malware Detection

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Secure Web Gateway
1. Navigate to **https://localhost:443** (OPNsense Secure Web Gateway)
2. Accept the security certificate to access the management interface
3. Review the SWG dashboard showing:
   - Real-time threat detection status
   - Web filtering categories
   - SSL inspection capabilities
   - Malware detection statistics

#### Step 3: Test Malware Protection
1. Open **http://localhost:9084** (External Service)
2. In the "Threat Simulation" section:
   - Click "Test Malware URL" - should be blocked
   - Try "Download Suspicious File" - should be prevented
   - Attempt "Access Infected Site" - should show warning page
3. Return to the SWG interface to see blocked threats in real-time

#### Step 4: Test Phishing Protection
1. In the External Service threat simulation:
   - Click "Simulate Phishing Email"
   - Try "Fake Banking Site" - should be blocked with warning
   - Test "Credential Harvesting" - should be prevented
2. Observe how the SWG identifies and blocks phishing attempts

#### Step 5: Test Web Content Filtering
1. In the External Service, try accessing different website categories:
   - Business/News sites (allowed)
   - Social media (may be restricted based on policy)
   - Gambling/Adult content (blocked)
2. Review the SWG policy enforcement and category-based filtering

#### Step 6: Monitor Security Analytics
1. Open **http://localhost:5601** (Kibana Dashboard)
2. Navigate to the "Web Security" section
3. Review real-time visualizations of:
   - Blocked threats by type
   - Website category access patterns
   - SSL inspection statistics
   - Geographic threat sources

### **What You've Learned**
- How Secure Web Gateways provide real-time threat protection
- The effectiveness of phishing detection and prevention
- Category-based web filtering for organizational policy enforcement
- SSL/TLS inspection capabilities for encrypted traffic analysis

---

## 6. Shadow IT Discovery and Control

### **Business Scenario**
Identify and control unauthorized cloud services and applications used by employees.

### **SASE Components Used**
- Cloud Access Security Broker
- Network Traffic Analysis
- Application Discovery

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Shadow IT Discovery Dashboard
1. Navigate to **http://localhost:9082** (Corporate File Server)
2. Scroll to the "Shadow IT Discovery" section
3. Review the dashboard showing:
   - Discovered unauthorized cloud services
   - Risk assessment for each service
   - User activity patterns
   - Policy compliance status

#### Step 3: Simulate Shadow IT Usage
1. Open **http://localhost:9084** (External Service)
2. In the "Shadow IT Simulation" section:
   - Try "Unauthorized Cloud Storage" (should be detected and flagged)
   - Test "Personal Email Service" (should trigger risk alert)
   - Use "Unapproved Collaboration Tool" (should be logged as violation)
3. Each action will be logged and analyzed for risk

#### Step 4: Monitor Shadow IT Detection
1. Return to the Corporate File Server (**http://localhost:9082**)
2. Check the "CASB Activity Log" for new shadow IT detections
3. Review the risk scores and policy violations
4. Note how the system categorizes different types of unauthorized services

#### Step 5: Review Control Policies
1. In the Shadow IT Discovery section, examine:
   - Approved vs. unapproved service lists
   - Automated blocking policies
   - User notification procedures
   - Risk-based access controls
2. See how policies adapt based on service risk levels

#### Step 6: Analyze Shadow IT Analytics
1. Open **http://localhost:5601** (Kibana Dashboard)
2. Navigate to the "Shadow IT Analytics" section
3. Review visualizations showing:
   - Most commonly used unauthorized services
   - Shadow IT usage by department/user
   - Risk trends over time
   - Policy effectiveness metrics

### **What You've Learned**
- How CASB solutions discover and monitor unauthorized cloud services
- Automated risk assessment and categorization of shadow IT
- Policy-based control and blocking of high-risk services
- The importance of user awareness and education in shadow IT management

---

## 7. Zero Trust Network Segmentation

### **Business Scenario**
Implement microsegmentation to limit lateral movement and enforce least-privilege access.

### **SASE Components Used**
- Zero Trust Network Access
- Network Segmentation
- Identity-Based Access Control

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Zero Trust Network Access Console
1. Navigate to **http://localhost:1280** (OpenZiti Controller)
2. Review the Zero Trust network segmentation dashboard
3. Examine the network zones:
   - Corporate Zone (high trust)
   - DMZ Zone (medium trust)
   - External Zone (low trust)
   - Management Zone (administrative access)

#### Step 3: Explore Network Segmentation Policies
1. In the ZTNA console, review the "Microsegmentation Policies" section:
   - Identity-based access rules
   - Device trust levels
   - Application-specific permissions
   - Network zone isolation rules
2. Notice how access is granted based on identity verification, not network location

#### Step 4: Test Access Controls
1. Open **http://localhost:9081** (Corporate HR Portal)
2. Observe the security indicators showing:
   - ✅ Identity Verified
   - ✅ Device Trusted
   - ✅ Network Segment Authorized
   - 🛡️ Zero Trust Enforced
3. Try accessing from different simulated contexts (employee, contractor, guest)

#### Step 5: Test Cross-Zone Access Restrictions
1. Navigate to **http://localhost:9083** (DMZ Web Server)
2. Attempt to access corporate resources from the DMZ
3. Observe how zero trust policies prevent lateral movement
4. Check the access denied messages and security logging

#### Step 6: Monitor Network Segmentation
1. Open **http://localhost:5601** (Kibana Dashboard)
2. Navigate to the "Network Segmentation" section
3. Review visualizations showing:
   - Network flow patterns between zones
   - Access violations and denied connections
   - Identity-based access decisions
   - Microsegmentation effectiveness metrics

### **What You've Learned**
- How zero trust implements strict network segmentation
- The power of identity-based access control over network-based rules
- How microsegmentation prevents lateral movement in security breaches
- The importance of continuous monitoring and verification in zero trust

---

## 8. Compliance and Audit Reporting

### **Business Scenario**
Generate compliance reports for regulations like GDPR, HIPAA, PCI-DSS, and SOX.

### **SASE Components Used**
- Security Information and Event Management
- Audit Logging
- Compliance Reporting

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Compliance Dashboard
1. Navigate to **http://localhost:5601** (Kibana Dashboard)
2. Look for the "Compliance & Audit" section
3. Review the pre-configured compliance dashboards:
   - GDPR Data Processing Activities
   - PCI-DSS Payment Card Data Access
   - SOX Financial Controls Monitoring
   - HIPAA Healthcare Data Protection

#### Step 3: Explore GDPR Compliance Monitoring
1. In Kibana, select the "GDPR Compliance" dashboard
2. Review real-time monitoring of:
   - Personal data access events
   - Data processing purposes and legal basis
   - User consent tracking
   - Data retention compliance
3. Notice automated alerts for potential GDPR violations

#### Step 4: Review PCI-DSS Payment Security
1. Switch to the "PCI-DSS Monitoring" dashboard
2. Examine:
   - Payment card data access logs
   - Encryption status of cardholder data
   - Access control effectiveness
   - Security policy compliance metrics
3. View automated compliance scoring and violation alerts

#### Step 5: Generate Compliance Reports
1. In the "Compliance Reporting" section:
   - Generate a monthly GDPR compliance report
   - Export PCI-DSS audit trail for the last quarter
   - Create access control summary for SOX compliance
2. Review how reports are automatically formatted for auditors

#### Step 6: Test Audit Trail Integrity
1. Navigate to **http://localhost:9081** (Corporate HR Portal)
2. Perform various actions (login, data access, configuration changes)
3. Return to Kibana to see these actions logged in real-time
4. Verify the completeness and tamper-proof nature of audit logs

### **What You've Learned**
- How SASE provides comprehensive audit trails for regulatory compliance
- The automation of compliance reporting for GDPR, PCI-DSS, and other regulations
- Real-time monitoring and alerting for compliance violations
- The importance of tamper-proof audit logs for legal and regulatory requirements

---

## 9. Incident Response and Forensics

### **Business Scenario**
Rapidly detect, investigate, and respond to security incidents using SASE telemetry.

### **SASE Components Used**
- Security Analytics
- Incident Detection
- Forensic Capabilities

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Security Operations Center
1. Navigate to **http://localhost:5601** (Kibana Dashboard)
2. Go to the "Security Operations" section
3. Review the incident detection dashboard showing:
   - Real-time threat alerts
   - Attack patterns and trends
   - Automated response actions
   - Forensic investigation tools

#### Step 3: Simulate a Security Incident
1. Open **http://localhost:9084** (External Service)
2. In the "Security Incident Simulation" section:
   - Click "Simulate Brute Force Attack" to generate failed login attempts
   - Try "Simulate Data Exfiltration" to trigger data loss alerts
   - Use "Simulate Malware Activity" to test threat detection
3. Watch real-time alerts appear in the security dashboard

#### Step 4: Investigate the Incident
1. Return to the Kibana Security Operations dashboard
2. Click on the generated incident alerts
3. Review the incident details:
   - Attack timeline and progression
   - Affected systems and users
   - IOCs (Indicators of Compromise)
   - Risk assessment and impact analysis

#### Step 5: Analyze Forensic Data
1. In the "Incident Investigation" section:
   - Examine the attack timeline visualization
   - Review network traffic patterns during the incident
   - Analyze user behavior anomalies
   - Check for lateral movement indicators
2. Use the forensic search tools to correlate related events

#### Step 6: Review Automated Response
1. Navigate to the "Automated Response" section
2. Observe how the system automatically:
   - Blocks suspicious IP addresses
   - Suspends compromised user accounts
   - Isolates affected network segments
   - Escalates critical incidents to security teams
3. Review the response effectiveness and timeline

### **What You've Learned**
- How SASE enables rapid incident detection and automated alerting
- The importance of comprehensive forensic data collection
- How automated response systems contain threats in real-time
- The value of detailed incident timeline reconstruction for post-incident analysis

---

## 10. Cloud Migration Security

### **Business Scenario**
Securely migrate applications and data to the cloud while maintaining security controls.

### **SASE Components Used**
- Cloud Access Security Broker
- Data Protection
- Network Security

### **Step-by-Step Instructions**

#### Step 1: Start the Lab Environment
1. Open a terminal in the lab directory
2. Run the startup script: `./start-sase-lab.sh`
3. Wait for all services to start (approximately 2-3 minutes)

#### Step 2: Access Cloud Migration Dashboard
1. Navigate to **http://localhost:9082** (Corporate File Server)
2. Scroll to the "Cloud Migration Security" section
3. Review the migration planning dashboard showing:
   - Current on-premises applications
   - Cloud security readiness assessment
   - Migration risk analysis
   - Security control implementation status

#### Step 3: Pre-Migration Security Assessment
1. In the Cloud Migration section, examine:
   - Data classification and encryption status
   - Application security posture
   - Compliance requirements mapping
   - Risk assessment for each workload
2. Review recommendations for secure cloud migration

#### Step 4: Simulate Cloud Migration Process
1. Open **http://localhost:9084** (External Service)
2. In the "Cloud Migration Simulation" section:
   - Start "Data Migration" to simulate secure data transfer
   - Initiate "Application Cutover" to test service transition
   - Monitor "Security Control Deployment" in real-time
3. Watch how SASE maintains security during migration

#### Step 5: Monitor Migration Security
1. Navigate to **http://localhost:5601** (Kibana Dashboard)
2. Access the "Cloud Migration Monitoring" section
3. Review real-time visualizations of:
   - Data transfer security status
   - Application availability during migration
   - Security control effectiveness
   - Compliance maintenance metrics

#### Step 6: Validate Post-Migration Security
1. After the simulated migration, test the applications:
   - **http://localhost:9081** (HR Portal) - now "cloud-hosted"
   - **http://localhost:9082** (File Server) - hybrid cloud setup
2. Verify that all security controls remain effective:
   - Identity and access management
   - Data encryption and protection
   - Network security and monitoring
   - Compliance reporting

#### Step 7: Review Migration Success Metrics
1. Return to the Cloud Migration Dashboard
2. Examine the post-migration assessment:
   - Security posture comparison (before vs. after)
   - Performance and availability metrics
   - Cost optimization achievements
   - Compliance certification status

### **What You've Learned**
- How SASE ensures secure cloud migration with continuous protection
- The importance of maintaining security controls during digital transformation
- How to validate and monitor cloud security posture post-migration
- The role of SASE in enabling safe and compliant cloud adoption

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