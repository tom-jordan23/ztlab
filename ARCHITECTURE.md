# SASE Lab Architecture Documentation

This document provides comprehensive architectural diagrams and component relationships for the SASE (Secure Access Service Edge) lab environment.

## High-Level SASE Architecture

```mermaid
graph TB
    subgraph "External Network (192.168.200.0/24)"
        EXT[External Services<br/>Port 9084]
        THREATS[Simulated Threats<br/>Malware, Phishing]
    end

    subgraph "DMZ Network (172.16.0.0/24)"
        DMZ[DMZ Web Server<br/>Port 9083]
        LB[Load Balancer]
        API[API Gateway]
    end

    subgraph "SASE Security Layer"
        direction TB
        SWG[Secure Web Gateway<br/>OPNsense<br/>Port 443, 3128]
        FW[Firewall as a Service<br/>Integrated with SWG]
        ZTNA[Zero Trust Network Access<br/>OpenZiti Simulation<br/>Port 1280]
        IAM[Identity & Access Management<br/>Zitadel Simulation<br/>Port 9080]
        CASB[Cloud Access Security Broker<br/>Cloud Custodian Simulation]
        SDWAN[SD-WAN Router<br/>VyOS Simulation<br/>Ports 2223, 9444]
    end

    subgraph "Corporate Network (10.10.0.0/16)"
        CORP1[Corporate HR Portal<br/>Port 9081]
        CORP2[Corporate File Server<br/>Port 9082]
        CLIENT[Client Workstation]
    end

    subgraph "Management Network (192.168.100.0/24)"
        ES[Elasticsearch<br/>Port 9200]
        KIBANA[Kibana Dashboard<br/>Port 5601]
        LOGSTASH[Logstash<br/>Ports 5044, 9600]
        TOOLS[Network Tools<br/>NetShoot]
    end

    %% External connections
    EXT -.->|Malicious Traffic| SWG
    THREATS -.->|Attack Vectors| SWG

    %% SASE component relationships
    SWG -->|Filtered Traffic| DMZ
    SWG -->|Inspected Traffic| CORP1
    SWG -->|Inspected Traffic| CORP2
    
    IAM <-->|Identity Verification| ZTNA
    ZTNA -->|Zero Trust Policies| CORP1
    ZTNA -->|Zero Trust Policies| CORP2
    
    CASB -->|Policy Enforcement| CORP2
    CASB -->|Shadow IT Detection| EXT
    
    SDWAN -->|Optimized Routing| DMZ
    SDWAN -->|Traffic Engineering| SWG

    %% Monitoring and logging
    SWG -->|Security Logs| LOGSTASH
    ZTNA -->|Access Logs| LOGSTASH
    CASB -->|Policy Logs| LOGSTASH
    CORP1 -->|Application Logs| LOGSTASH
    CORP2 -->|Application Logs| LOGSTASH
    
    LOGSTASH -->|Processed Logs| ES
    ES -->|Search & Analytics| KIBANA

    %% Client access
    CLIENT -->|User Requests| ZTNA
    CLIENT -->|Web Browsing| SWG

    classDef saseComponent fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef networkZone fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef application fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef monitoring fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef threat fill:#ffebee,stroke:#c62828,stroke-width:2px

    class SWG,FW,ZTNA,IAM,CASB,SDWAN saseComponent
    class EXT,DMZ,CORP1,CORP2 application
    class ES,KIBANA,LOGSTASH,TOOLS monitoring
    class THREATS threat
```

## Detailed Component Architecture

```mermaid
graph LR
    subgraph "Identity & Access Management"
        direction TB
        IAM_SIM[Zitadel Simulation<br/>Port 9080]
        IAM_FEATURES[OAuth2/OIDC<br/>Multi-Factor Auth<br/>User Lifecycle<br/>Enterprise SSO]
        IAM_SIM --> IAM_FEATURES
    end

    subgraph "Zero Trust Network Access"
        direction TB
        ZTNA_SIM[OpenZiti Simulation<br/>Port 1280]
        ZTNA_FEATURES[Micro-tunnels<br/>Identity-based Policies<br/>End-to-End Encryption<br/>Application Access]
        ZTNA_SIM --> ZTNA_FEATURES
    end

    subgraph "Secure Web Gateway"
        direction TB
        SWG_NGINX[OPNsense + Nginx<br/>Port 443 (HTTPS)<br/>Port 3128 (Proxy)]
        SWG_FEATURES[URL Filtering<br/>Malware Detection<br/>SSL Inspection<br/>Content Blocking]
        SWG_SSL[SSL Certificates<br/>Self-signed for Demo]
        SWG_NGINX --> SWG_FEATURES
        SWG_NGINX --> SWG_SSL
    end

    subgraph "Cloud Access Security Broker"
        direction TB
        CASB_SIM[Cloud Custodian<br/>Ubuntu Container]
        CASB_FEATURES[Policy-as-Code<br/>Shadow IT Detection<br/>Data Loss Prevention<br/>Compliance Monitoring]
        CASB_POLICIES[Policy Files<br/>YAML Configuration<br/>AWS Simulation]
        CASB_SIM --> CASB_FEATURES
        CASB_SIM --> CASB_POLICIES
    end

    subgraph "SD-WAN Router"
        direction TB
        SDWAN_SIM[VyOS Simulation<br/>Ubuntu + Networking Tools]
        SDWAN_FEATURES[Traffic Optimization<br/>Routing Policies<br/>Quality of Service<br/>Failover]
        SDWAN_PORTS[SSH: Port 2223<br/>Web: Port 9444]
        SDWAN_SIM --> SDWAN_FEATURES
        SDWAN_SIM --> SDWAN_PORTS
    end

    %% Component interactions
    IAM_SIM <-->|Identity Verification| ZTNA_SIM
    ZTNA_SIM <-->|Access Control| SWG_NGINX
    SWG_NGINX <-->|Traffic Filtering| CASB_SIM
    SDWAN_SIM <-->|Network Routing| SWG_NGINX

    classDef identity fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef ztna fill:#f1f8e9,stroke:#388e3c,stroke-width:2px
    classDef gateway fill:#fff8e1,stroke:#f57c00,stroke-width:2px
    classDef casb fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef sdwan fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

    class IAM_SIM,IAM_FEATURES identity
    class ZTNA_SIM,ZTNA_FEATURES ztna
    class SWG_NGINX,SWG_FEATURES,SWG_SSL gateway
    class CASB_SIM,CASB_FEATURES,CASB_POLICIES casb
    class SDWAN_SIM,SDWAN_FEATURES,SDWAN_PORTS sdwan
```

## Network Topology and Segmentation

```mermaid
graph TB
    subgraph "Internet/External"
        direction LR
        INTERNET[Internet<br/>Untrusted Zone]
        EXTERNAL_SVC[External Service<br/>192.168.200.0/24<br/>Port 9084]
        MALWARE[Malware Sources]
        PHISHING[Phishing Sites]
        
        INTERNET --- EXTERNAL_SVC
        INTERNET --- MALWARE
        INTERNET --- PHISHING
    end

    subgraph "DMZ Zone"
        direction LR
        DMZ_WEB[DMZ Web Server<br/>172.16.0.0/24<br/>Port 9083]
        DMZ_SERVICES[Public Services<br/>Email Gateway<br/>VPN Gateway<br/>API Gateway]
        
        DMZ_WEB --- DMZ_SERVICES
    end

    subgraph "SASE Security Perimeter"
        direction TB
        SECURITY_STACK[Security Services Stack]
        
        subgraph "Security Services"
            SWG_MAIN[Secure Web Gateway<br/>443, 3128]
            FIREWALL[Firewall as a Service]
            ZTNA_MAIN[Zero Trust Access<br/>1280]
            IAM_MAIN[Identity Management<br/>9080]
            CASB_MAIN[CASB Policies]
            SDWAN_MAIN[SD-WAN Router<br/>2223, 9444]
        end
        
        SECURITY_STACK --- SWG_MAIN
        SECURITY_STACK --- FIREWALL
        SECURITY_STACK --- ZTNA_MAIN
        SECURITY_STACK --- IAM_MAIN
        SECURITY_STACK --- CASB_MAIN
        SECURITY_STACK --- SDWAN_MAIN
    end

    subgraph "Corporate Internal Network"
        direction LR
        CORP_NET[Corporate Network<br/>10.10.0.0/16]
        HR_APP[HR Portal<br/>Port 9081]
        FILE_SRV[File Server<br/>Port 9082]
        WORKSTATION[Client Workstation]
        
        CORP_NET --- HR_APP
        CORP_NET --- FILE_SRV
        CORP_NET --- WORKSTATION
    end

    subgraph "Management Network"
        direction LR
        MGMT_NET[Management<br/>192.168.100.0/24]
        ELASTIC[Elasticsearch<br/>9200]
        KIBANA_DASH[Kibana<br/>5601]
        LOGSTASH_SVC[Logstash<br/>5044, 9600]
        NET_TOOLS[Network Tools]
        
        MGMT_NET --- ELASTIC
        MGMT_NET --- KIBANA_DASH
        MGMT_NET --- LOGSTASH_SVC
        MGMT_NET --- NET_TOOLS
    end

    %% Traffic flows
    INTERNET -.->|Malicious Traffic| SECURITY_STACK
    EXTERNAL_SVC -.->|External Requests| SECURITY_STACK
    
    SECURITY_STACK -->|Filtered| DMZ_WEB
    SECURITY_STACK -->|Authorized| CORP_NET
    
    WORKSTATION -->|User Traffic| SECURITY_STACK
    
    %% Monitoring flows
    SECURITY_STACK -->|Logs| MGMT_NET
    CORP_NET -->|Logs| MGMT_NET
    DMZ_WEB -->|Logs| MGMT_NET

    classDef untrusted fill:#ffebee,stroke:#d32f2f,stroke-width:3px
    classDef dmz fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef security fill:#e8f5e8,stroke:#388e3c,stroke-width:3px
    classDef corporate fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef management fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

    class INTERNET,EXTERNAL_SVC,MALWARE,PHISHING untrusted
    class DMZ_WEB,DMZ_SERVICES dmz
    class SECURITY_STACK,SWG_MAIN,FIREWALL,ZTNA_MAIN,IAM_MAIN,CASB_MAIN,SDWAN_MAIN security
    class CORP_NET,HR_APP,FILE_SRV,WORKSTATION corporate
    class MGMT_NET,ELASTIC,KIBANA_DASH,LOGSTASH_SVC,NET_TOOLS management
```

## Data Flow and Security Enforcement

```mermaid
sequenceDiagram
    participant User as 👤 Remote User
    participant IAM as 🔐 Identity Mgmt
    participant ZTNA as 🛡️ Zero Trust
    participant SWG as 🌐 Web Gateway
    participant FW as 🔥 Firewall
    participant CASB as ☁️ CASB
    participant App as 🏢 Corporate App
    participant Monitor as 📊 Monitoring

    Note over User, Monitor: SASE Security Flow

    User->>IAM: 1. Authentication Request
    IAM->>IAM: Verify credentials, MFA
    IAM->>User: 2. Identity Token

    User->>ZTNA: 3. Access Request + Token
    ZTNA->>IAM: Validate token
    IAM->>ZTNA: Token valid
    ZTNA->>ZTNA: Check access policies
    ZTNA->>User: 4. Access granted

    User->>SWG: 5. Web request
    SWG->>SWG: URL filtering, malware scan
    SWG->>FW: 6. Forward if clean
    FW->>FW: Apply firewall rules
    
    FW->>CASB: 7. Check cloud policies
    CASB->>CASB: Evaluate DLP, compliance
    CASB->>FW: Policy decision
    
    FW->>App: 8. Forward to application
    App->>App: Process request
    App->>FW: 9. Response
    
    FW->>SWG: 10. Response
    SWG->>User: 11. Filtered response

    Note over Monitor: Continuous Monitoring
    SWG->>Monitor: Security events
    ZTNA->>Monitor: Access logs
    CASB->>Monitor: Policy violations
    FW->>Monitor: Traffic logs
    App->>Monitor: Application logs
```

## Container and Service Mapping

```mermaid
graph TB
    subgraph "Docker Host"
        subgraph "Corporate Network Containers"
            C1[sase-corp-app-1<br/>nginx:alpine<br/>HR Portal]
            C2[sase-corp-app-2<br/>httpd:alpine<br/>File Server]
            C3[sase-client<br/>ubuntu:22.04<br/>Workstation]
        end

        subgraph "DMZ Network Containers"
            D1[sase-dmz-web<br/>nginx:alpine<br/>Public Web]
        end

        subgraph "External Network Containers"
            E1[sase-external-service<br/>httpd:alpine<br/>Internet Sim]
        end

        subgraph "Security Service Containers"
            S1[sase-opnsense<br/>nginx:alpine<br/>SWG + Firewall]
            S2[sase-zitadel-simulation<br/>nginx:alpine<br/>IAM]
            S3[sase-ziti-simulation<br/>nginx:alpine<br/>ZTNA]
            S4[sase-casb<br/>ubuntu:22.04<br/>CASB]
            S5[sase-vyos<br/>ubuntu:22.04<br/>SD-WAN]
        end

        subgraph "Management Network Containers"
            M1[sase-elasticsearch<br/>elasticsearch:8.11.0<br/>Search Engine]
            M2[sase-kibana<br/>kibana:8.11.0<br/>Analytics UI]
            M3[sase-logstash<br/>logstash:8.11.0<br/>Log Processing]
            M4[sase-nettools<br/>nicolaka/netshoot<br/>Network Utils]
        end

        subgraph "Docker Networks"
            N1[ztlab_corporate<br/>10.10.0.0/16]
            N2[ztlab_dmz<br/>172.16.0.0/24]
            N3[ztlab_external<br/>192.168.200.0/24]
            N4[ztlab_management<br/>192.168.100.0/24]
        end

        subgraph "Persistent Volumes"
            V1[opnsense_data]
            V2[cloud_custodian_data]
            V3[elasticsearch_data]
            V4[kibana_data]
            V5[logstash_data]
        end
    end

    %% Container to Network mappings
    C1 --- N1
    C2 --- N1
    C3 --- N1
    
    D1 --- N2
    
    E1 --- N3
    
    S1 --- N1
    S1 --- N2
    S1 --- N3
    S1 --- N4
    
    S2 --- N1
    S2 --- N4
    
    S3 --- N1
    S3 --- N4
    
    S4 --- N1
    S4 --- N4
    
    S5 --- N1
    S5 --- N2
    S5 --- N3
    S5 --- N4
    
    M1 --- N4
    M2 --- N4
    M3 --- N4
    M4 --- N1
    M4 --- N2
    M4 --- N3
    M4 --- N4

    %% Volume mappings
    S1 -.-> V1
    S4 -.-> V2
    M1 -.-> V3
    M2 -.-> V4
    M3 -.-> V5

    classDef container fill:#e1f5fe,stroke:#01579b,stroke-width:1px
    classDef network fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef volume fill:#fff3e0,stroke:#e65100,stroke-width:1px

    class C1,C2,C3,D1,E1,S1,S2,S3,S4,S5,M1,M2,M3,M4 container
    class N1,N2,N3,N4 network
    class V1,V2,V3,V4,V5 volume
```

## Port Mapping and Service Access

| Component | Container Name | Image | Internal Port | External Port | Purpose |
|-----------|---------------|-------|---------------|---------------|---------|
| **Corporate Applications** |
| HR Portal | sase-corp-app-1 | nginx:alpine | 80 | 9081 | Internal employee portal |
| File Server | sase-corp-app-2 | httpd:alpine | 80 | 9082 | Document management |
| **DMZ Services** |
| Web Server | sase-dmz-web | nginx:alpine | 80 | 9083 | Public web services |
| **External Services** |
| Internet Sim | sase-external-service | httpd:alpine | 80 | 9084 | External threat simulation |
| **SASE Security Services** |
| Secure Web Gateway | sase-opnsense | nginx:alpine | 443, 3128 | 443, 3128 | Web filtering, SSL inspection |
| Identity Management | sase-zitadel-simulation | nginx:alpine | 80 | 9080 | OAuth2/OIDC simulation |
| Zero Trust Access | sase-ziti-simulation | nginx:alpine | 80 | 1280 | ZTNA policy simulation |
| SD-WAN Router | sase-vyos | ubuntu:22.04 | 22, 8443 | 2223, 9444 | Network routing simulation |
| **Monitoring Stack** |
| Elasticsearch | sase-elasticsearch | elasticsearch:8.11.0 | 9200 | 9200 | Search and analytics |
| Kibana | sase-kibana | kibana:8.11.0 | 5601 | 5601 | Visualization dashboard |
| Logstash | sase-logstash | logstash:8.11.0 | 5044, 9600 | 5044, 9600 | Log processing |

## Security Zones and Trust Levels

```mermaid
graph LR
    subgraph "Trust Levels"
        direction TB
        UNTRUSTED[Untrusted Zone<br/>External Network<br/>🔴 No Trust]
        LIMITED[Limited Trust<br/>DMZ Network<br/>🟡 Controlled Access]
        TRUSTED[Trusted Zone<br/>Corporate Network<br/>🟢 Full Trust]
        MANAGEMENT[Management Zone<br/>Admin Network<br/>🔵 Administrative]
    end

    subgraph "Security Controls"
        direction TB
        PERIMETER[Perimeter Security<br/>SWG + Firewall]
        IDENTITY[Identity Controls<br/>IAM + ZTNA]
        DATA[Data Protection<br/>CASB + DLP]
        MONITORING[Continuous Monitoring<br/>SIEM + Analytics]
    end

    UNTRUSTED -->|All Traffic Inspected| PERIMETER
    PERIMETER -->|Authenticated Users| IDENTITY
    IDENTITY -->|Authorized Access| LIMITED
    IDENTITY -->|Verified Identity| TRUSTED
    
    DATA -->|Policy Enforcement| LIMITED
    DATA -->|Data Classification| TRUSTED
    
    MONITORING -->|Event Collection| UNTRUSTED
    MONITORING -->|Log Analysis| LIMITED
    MONITORING -->|Behavioral Analytics| TRUSTED
    MONITORING -->|Administrative Oversight| MANAGEMENT

    classDef untrusted fill:#ffebee,stroke:#d32f2f,stroke-width:2px
    classDef limited fill:#fff8e1,stroke:#f57c00,stroke-width:2px
    classDef trusted fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef mgmt fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef security fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px

    class UNTRUSTED untrusted
    class LIMITED limited
    class TRUSTED trusted
    class MANAGEMENT mgmt
    class PERIMETER,IDENTITY,DATA,MONITORING security
```

## Component Dependencies and Startup Order

```mermaid
graph TD
    START[Lab Startup]
    
    subgraph "Phase 1: Infrastructure"
        NETWORKS[Create Docker Networks]
        VOLUMES[Initialize Volumes]
    end
    
    subgraph "Phase 2: Core Applications"
        CORP_APPS[Corporate Applications<br/>HR Portal, File Server]
        DMZ_APPS[DMZ Applications<br/>Web Server]
        EXT_APPS[External Services<br/>Internet Simulation]
    end
    
    subgraph "Phase 3: Security Services"
        GATEWAY[Secure Web Gateway<br/>OPNsense]
        IDENTITY_SIM[Identity Simulation<br/>Zitadel]
        ZTNA_SIM[ZTNA Simulation<br/>OpenZiti]
    end
    
    subgraph "Phase 4: Monitoring"
        ELASTICSEARCH[Elasticsearch]
        LOGSTASH[Logstash]
        KIBANA[Kibana]
    end
    
    subgraph "Phase 5: Advanced Services"
        CASB_SVC[CASB Service<br/>Cloud Custodian]
        SDWAN_SVC[SD-WAN Router<br/>VyOS]
        NET_TOOLS[Network Tools]
        CLIENT[Client Workstation]
    end

    START --> NETWORKS
    START --> VOLUMES
    
    NETWORKS --> CORP_APPS
    NETWORKS --> DMZ_APPS
    NETWORKS --> EXT_APPS
    NETWORKS --> GATEWAY
    
    CORP_APPS --> IDENTITY_SIM
    CORP_APPS --> ZTNA_SIM
    GATEWAY --> IDENTITY_SIM
    
    IDENTITY_SIM --> ELASTICSEARCH
    ZTNA_SIM --> ELASTICSEARCH
    ELASTICSEARCH --> LOGSTASH
    ELASTICSEARCH --> KIBANA
    
    LOGSTASH --> CASB_SVC
    LOGSTASH --> SDWAN_SVC
    KIBANA --> NET_TOOLS
    KIBANA --> CLIENT

    classDef phase1 fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef phase2 fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef phase3 fill:#fff3e0,stroke:#f57c00,stroke-width:2px
    classDef phase4 fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef phase5 fill:#fce4ec,stroke:#c2185b,stroke-width:2px

    class NETWORKS,VOLUMES phase1
    class CORP_APPS,DMZ_APPS,EXT_APPS phase2
    class GATEWAY,IDENTITY_SIM,ZTNA_SIM phase3
    class ELASTICSEARCH,LOGSTASH,KIBANA phase4
    class CASB_SVC,SDWAN_SVC,NET_TOOLS,CLIENT phase5
```

---

This architecture documentation provides comprehensive visual representations of the SASE lab environment, including component relationships, network topology, data flows, and security zones. The diagrams can be rendered in any Markdown-compatible environment that supports Mermaid syntax.