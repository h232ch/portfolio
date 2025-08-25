---
title: Cybersecurity Project
date: 2025-08-24
tags:
  - obsidian
draft: false
---

---

# 🔐 End-to-End Cybersecurity Project Plan (High-Level)

## **Phase 1 – Application Deployment**

- **Stack & Platform**: Deploy your **React + Node.js** web service on **AWS EKS** using **eksctl**.
    
- **Ingress**: Provision **ALB + Target Group** via eksctl/ALB Ingress Controller.
    
- **Application Logs → Vector → Kafka**:
    
    - Run **Vector** to collect app logs from Pods/containers.
        
    - **Publish to Kafka** as the central streaming backbone.
        
- **Kafka Setup (high-level)**:
    
    - Choose **Amazon MSK** (managed) _or_ **Strimzi on EKS** (self-managed).
        
    - Create core topics (e.g., `app.logs.raw`, `security.logs.raw`).
        
    - Keep **JSON records** with consistent fields (timestamp, service, env, cluster, pod, level, message).
        
    - Define high-level retention and partitions appropriate for expected volume.
        

---

## **Phase 2 – Security Operation**

- **AWS Security Services**: Enable **CloudTrail, GuardDuty, Security Hub, WAF, VPC Flow Logs**.
    
- **Central Log Lake**: Store **all security alerts/logs in S3** (security account).
    
- **Ticketing (Initial)**: Basic automation to create **Jira tickets** from critical AWS findings.
    

---

## **Phase 3 – SOC Environment Setup**

- **SIEM**: Stand up **ELK/OpenSearch or Splunk**.
    
- **Pipelines**: Ingest from **S3 and Kafka** into the SIEM.
    
- **Normalization**: Apply **OCSF/ECS** for consistent fields and entities.
    
- **SOC Visuals & Alerts**: Build **dashboards** and **alert rules**; route alerts → **Jira**.
    

---

## **Phase 4 – Detection Engineering**

- **Detections**: Author rules mapped to **MITRE ATT&CK** (e.g., brute force, privilege escalation, data exfil, SQLi).
    
- **Playbooks**: Define **triage & escalation** runbooks for each detection.
    
- **Adversary Simulation**: Use **OWASP ZAP, Burp Suite, Metasploit** to validate detections end-to-end (alert → Jira workflow).
    

---

## **Phase 5 – Vulnerability Management (SOC-Centric)**

- **Scanning**: Run **Inspector / Nessus / OpenVAS** across workloads/nodes.
    
- **SIEM Correlation**: Ingest VM findings; correlate **vulnerabilities vs. attack attempts** in logs.
    
- **Lifecycle in Jira**: Track **discover → remediate → rescan → close**.
    

---

## **Phase 6 – Vulnerability Management (DevSecOps-Centric)**

- **CI/CD Security**: Integrate **SAST (CodeQL/SonarQube)**, **DAST (ZAP automation)**, **dependency/container scans (Trivy/Snyk)**.
    
- **Exposure Visibility**: Send **DevSecOps assessment logs** to SIEM; **auto-ticket** critical issues pre-deploy.
    
- **Trends**: Monitor **vulnerability trends** across builds and releases.
    

---

## **Phase 7 – Unified SOC + VM Operations**

- **Single Pane**: Combine **security logs, detections, and vulnerability findings** in the SIEM.
    
- **Jira as System of Record**: Incidents + vulnerabilities in one workflow.
    
- **Case Studies**: Document scenarios (e.g., CVE discovered → exploit attempt seen in WAF/CloudTrail → correlated alert → Jira incident → patch → verified by rescan).
    
- **Portfolio Package**: Final **architecture diagram**, **playbooks & detections**, **screenshots**, **repo + write-up + short demo video**.
    

---
