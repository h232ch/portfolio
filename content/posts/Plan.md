---
title: "Cybersecurity Portfolio — Master Plan"
date: 2026-03-17
tags:
  - eks
  - aws
  - detection-engineering
  - elk
  - kafka
  - vector
  - okta
  - xdr
  - ml
  - bedrock
  - vulnerability-management
  - devsecops
  - mitre-attack
draft: false
---

# 🔐 End-to-End Cybersecurity Portfolio — Master Plan

This document is a living roadmap for an end-to-end cybersecurity portfolio built on AWS.  
Each phase covers what will be **built in the lab** and what will be **documented here**.

---

## Architecture Overview

```
React + Node.js App
       ↓
Vector (DaemonSet/Sidecar)
       ↓
Kafka (MSK or Strimzi)  ←── AWS WAF / GuardDuty / CloudTrail (S3 → Lambda)
       ↓                ←── Windows / Linux Endpoints (Elastic Agent)
Vector Aggregator / Logstash
       ↓
Elastic Cloud (ELK SIEM)
       ├── ML Detection Rules
       ├── XDR
       ├── Kibana Dashboards ──→ Slack / JIRA Alerts
       └── AI Assistant (LLM / RAG)

AWS Bedrock ──→ Summarize & Contextualize Alerts ──→ ELK
Atomic Red Team ──→ Endpoints ──→ Validate Detection Rules
```

---

## Phase 1 — Application & Security Infrastructure

**Goal**: Stand up the core app and AWS security perimeter.

### What I'll Build

| Task                    | Tool / Service                 |
| ----------------------- | ------------------------------ |
| React + Node.js web app | GitHub repo + Docker           |
| EKS cluster             | `eksctl` (t3.medium nodes)     |
| ALB Ingress + HTTPS     | AWS Load Balancer Controller   |
| CI/CD pipeline          | GitHub Actions → ECR → EKS     |
| AWS WAF                 | WAF v2 Web ACL on ALB          |
| GuardDuty               | Account-level threat detection |
| CloudTrail              | Org-level trail → S3           |
| VPC Flow Logs           | VPC → S3                       |
| _(Optional)_ Terraform  | IaC for all the above          |

### Portfolio Deliverables

- Architecture diagram
- CI/CD pipeline write-up
- Screenshot gallery: EKS console, WAF rules, GuardDuty dashboard
- Terraform module structure (if used)

---

## Phase 2 — Log Pipelines

**Goal**: Unified log streaming from all sources into ELK.

### Pipeline Architecture

```
Pod / App Logs      → Vector (DaemonSet)   → Kafka: app.logs.raw
WAF / GD / CT Logs  → S3 → Lambda          → Kafka: security.logs.raw
Endpoints           → Elastic Agent         → Kafka: endpoint.logs.raw
                                                     ↓
                                         Vector Aggregator / Logstash
                                                     ↓
                                           Elastic Cloud (ELK)
```

### Kafka Topics

| Topic               | Source                     |
| ------------------- | -------------------------- |
| `app.logs.raw`      | EKS pods (via Vector)      |
| `security.logs.raw` | WAF, GuardDuty, CloudTrail |
| `endpoint.logs.raw` | Windows / Linux endpoints  |

### Vector Config (DaemonSet)

```yaml
sources:
  kubernetes_logs:
    type: kubernetes_logs
transforms:
  parse_json:
    type: remap
    inputs: [kubernetes_logs]
    source: ". = parse_json!(string!(.message)) ?? ."
sinks:
  kafka_out:
    type: kafka
    inputs: [parse_json]
    bootstrap_servers: "msk-endpoint:9092"
    topic: "app.logs.raw"
```

### AWS Native Log Integration

- GuardDuty findings → Kinesis Firehose → S3
- WAF / CloudTrail → S3 Event Notification → Lambda → Kafka (or Logstash S3 input directly)

### Portfolio Deliverables

- End-to-end pipeline diagram
- Vector config explanation
- Kafka topic design rationale
- Log sample screenshots (raw → parsed)

---

## Phase 3 — SIEM & Monitoring (ELK)

**Goal**: Full SIEM with dashboards, field normalization, and identity integration.

### ELK Deployment

| Option                            | Recommendation                            |
| --------------------------------- | ----------------------------------------- |
| Elastic Cloud (14-day free trial) | ✅ Best for portfolio (includes ML + XDR) |
| Self-managed on EC2               | Good if you want to show ops depth        |
| AWS OpenSearch                    | Good AWS-native alternative               |

### What I'll Build

| Task               | Detail                                      |
| ------------------ | ------------------------------------------- |
| Ingest pipeline    | Kafka + S3 → Logstash/Beats → ELK           |
| Index templates    | ECS-normalized field mappings               |
| Parsers            | Grok/dissect for WAF, GuardDuty, CloudTrail |
| Kibana dashboards  | Per-source dashboards                       |
| Okta integration   | SSO logs via free developer account         |
| XDR                | Elastic Security XDR module                 |
| Grafana (optional) | EKS metrics overlay (Prometheus)            |

### Portfolio Deliverables

- ELK architecture write-up
- Kibana dashboard screenshots
- Field normalization (ECS) guide
- Okta + SIEM integration walkthrough

---

## Phase 4 — Threat Detection & Ticketing

**Goal**: Detection rules mapped to MITRE ATT&CK with automated alerting.

### Detection Coverage

| Category  | Source         | Example Techniques                     |
| --------- | -------------- | -------------------------------------- |
| Web App   | WAF logs       | SQLi, XSS, path traversal              |
| Container | EKS audit logs | Privilege escalation, container escape |
| Identity  | Okta logs      | Brute force, credential stuffing       |
| Cloud     | CloudTrail     | IAM anomaly, unusual API calls         |
| Network   | VPC Flow Logs  | Port scans, data exfiltration          |

### Alert Workflow

```
Detection Rule Fires
       ↓
Kibana Alert
       ↓
Slack Notification + JIRA Ticket (auto-created)
```

### Portfolio Deliverables

- Detection rule write-ups (3–5 highlighted rules with MITRE mapping)
- MITRE ATT&CK Navigator coverage map
- Alert workflow diagram
- Example JIRA ticket screenshots

---

## Phase 5 — Active Threat Detection (EDR + Red Team)

**Goal**: Validate detection rules against simulated adversarial activity.

### Endpoint Setup

| OS                        | Role     | Agent                  |
| ------------------------- | -------- | ---------------------- |
| Windows Server 2022 (EC2) | Target   | Elastic Agent + Sysmon |
| Ubuntu 22.04 (EC2)        | Target   | Elastic Agent          |
| Kali Linux                | Attacker | Atomic Red Team        |

### Test Workflow

```
1. Pick ATT&CK technique (e.g. T1059.001 – PowerShell)
2. Run Atomic Red Team test on Windows endpoint
3. Verify detection fires in Kibana
4. If no alert → write custom detection rule
5. Document result in portfolio
```

### Portfolio Deliverables

- Elastic Agent install guide (Windows + Linux)
- Atomic Red Team results table (technique → detected? → rule)
- Custom rule write-ups for coverage gaps

---

## Phase 6 — AI / ML Integration

**Goal**: Show AI/ML capability across both Elastic and AWS Bedrock.

### 6A — Elastic ML & AI

| Feature              | Detail                                                                            |
| -------------------- | --------------------------------------------------------------------------------- |
| Built-in ML rules    | [Elastic ML detection rules](https://elastic.github.io/detection-rules-explorer/) |
| Anomaly detection    | Unusual process, network, login behaviors                                         |
| Elastic AI Assistant | RAG over log data in real time                                                    |
| LLM connector        | OpenAI or Bedrock as the backend                                                  |

### 6B — AWS Bedrock

```
ELK Alert → Lambda → Bedrock (Claude 3 Sonnet)
                     → Summarize + Contextualize finding
                     → Response stored back in ELK index
Bedrock Guardrails: prompt injection protection + PII filtering
Guardrail logs → ingested into ELK
```

### Portfolio Deliverables

- ML rule coverage summary
- Bedrock architecture diagram
- Demo: natural-language query against security data
- Guardrail bypass attempt + detection write-up

---

## Phase 7 — Vulnerability Management & DevSecOps

**Goal**: Integrate security into the SDLC and correlate VM findings in the SIEM.

### DevSecOps Pipeline

```
GitHub PR → GitHub Actions
  ├── SAST: CodeQL / SonarQube
  ├── Dependency scan: Snyk / Dependabot
  ├── Container scan: Trivy
  └── DAST (post-deploy): OWASP ZAP
         ↓
  Critical findings → JIRA (auto-ticket)
         ↓
  Scan logs → ELK (vulnerability index)
```

### Runtime VM Scanning

| Tool                     | Target                    |
| ------------------------ | ------------------------- |
| AWS Inspector v2         | EC2 + Lambda + ECR images |
| Nessus Essentials (free) | EC2 endpoints             |
| OpenVAS (optional)       | Self-hosted scanner       |

### Capstone Use Case

> CVE discovered by Inspector → exploit attempt seen in WAF logs → correlated alert in ELK → JIRA incident created → patch deployed via CI/CD → verified by rescan in Inspector

### Portfolio Deliverables

- DevSecOps pipeline diagram
- Scan results with triage decisions
- Capstone case study write-up

---

## Hugo Site Content Structure

```
content/posts/
  ├── phase1-app-infrastructure.md
  ├── phase1-eks-cicd.md
  ├── phase2-log-pipeline.md
  ├── phase2-kafka-vector.md
  ├── phase3-elk-siem.md
  ├── phase3-okta-integration.md
  ├── phase4-detection-rules.md
  ├── phase4-mitre-mapping.md
  ├── phase5-edr-atomicredteam.md
  ├── phase6-ml-detection.md
  ├── phase6-aws-bedrock.md
  ├── phase7-devsecops.md
  └── phase7-capstone.md
```

---

## Build Sequence

| Phase                     | Estimated Duration | Dependencies |
| ------------------------- | ------------------ | ------------ |
| Phase 1 – App & Infra     | 3 weeks            | None         |
| Phase 2 – Log Pipeline    | 3 weeks            | Phase 1      |
| Phase 3 – ELK SIEM        | 2 weeks            | Phase 2      |
| Phase 4 – Detection Rules | 2 weeks            | Phase 3      |
| Phase 5 – EDR + Red Team  | 2 weeks            | Phase 4      |
| Phase 6 – AI/ML           | 2 weeks            | Phase 3      |
| Phase 7 – DevSecOps + VM  | 2 weeks            | Phase 4      |

> ⚠️ **Cost Watch**: EKS + MSK + Elastic Cloud + EC2 endpoints ≈ **$150–400/mo**.  
> Tear down non-essential resources between work sessions.

---

## Verification Checkpoints

| Phase | How to Verify                                                           |
| ----- | ----------------------------------------------------------------------- |
| 1     | App accessible via ALB; WAF blocks OWASP Top 10 test payloads           |
| 2     | Messages visible in Kafka; logs appear in ELK index                     |
| 3     | All sources visible in Kibana; Okta login events indexed                |
| 4     | Simulated brute force triggers detection + Slack notification           |
| 5     | Atomic Red Team test fires alert in Kibana                              |
| 6     | ML anomaly detected; Bedrock returns contextualized response            |
| 7     | CodeQL finding creates JIRA ticket; Inspector finding correlated in ELK |
