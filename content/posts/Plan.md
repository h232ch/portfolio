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

## ✅ Architecture Decisions (Confirmed)

| #   | Decision        | Choice                                                   |
| --- | --------------- | -------------------------------------------------------- |
| 1   | Kafka backend   | **Amazon MSK** (managed)                                 |
| 2   | ELK deployment  | **Elastic Cloud** (free trial → pay if needed)           |
| 3   | Terraform / IaC | **Manual first** → Terraform after                       |
| 4   | Identity        | **Okta developer account** (developer.okta.com)          |
| 5   | Endpoints       | **EC2** (Windows Server 2022 + Ubuntu 22.04 in same VPC) |

---

## Architecture Overview

```
React + Node.js App
       ↓
Vector (DaemonSet/Sidecar)
       ↓
Amazon MSK (Kafka)  ←── AWS WAF / GuardDuty / CloudTrail (S3 → Logstash)
       ↓             ←── EC2 Endpoints: Win 2022 + Ubuntu (Elastic Agent)
Logstash Aggregator
       ↓
Elastic Cloud (ELK SIEM)
       ├── ML Detection Rules
       ├── XDR (Elastic Security)
       ├── AI Assistant (LLM / RAG over log data)
       └── Kibana Dashboards ──→ Slack / JIRA Alerts

AWS Bedrock (Claude) ──→ Summarize & Contextualize Alerts ──→ ELK
Okta (Developer Acct) ──→ Logstash ──→ ELK (Identity logs + SSO)
Atomic Red Team ──→ EC2 Endpoints ──→ Validate Detection Rules
```

---

## Phase 1 — Application & Security Infrastructure

**Goal**: Stand up the core app and AWS security perimeter.

### What I'll Build

| Task                    | Tool / Service               | Notes                  |
| ----------------------- | ---------------------------- | ---------------------- |
| React + Node.js web app | GitHub repo + Docker         | Simple demo app        |
| EKS cluster             | `eksctl`                     | t3.medium nodes        |
| ALB Ingress + HTTPS     | AWS Load Balancer Controller | Exposes app publicly   |
| CI/CD pipeline          | GitHub Actions → ECR → EKS   | Auto-deploy on push    |
| AWS WAF                 | WAF v2 Web ACL on ALB        | OWASP rule group       |
| GuardDuty               | Account-level                | Threat detection       |
| CloudTrail              | Org-level trail → S3         | Audit logging          |
| VPC Flow Logs           | VPC → S3                     | Network visibility     |
| Terraform _(Phase 2)_   | Terraform OSS                | IaC after manual build |

### Portfolio Deliverables

- Architecture diagram
- CI/CD pipeline write-up (GitHub Actions → ECR → EKS rollout)
- Screenshot gallery: EKS console, WAF rules, GuardDuty dashboard
- Terraform module write-up (after manual phase is complete)

---

## Phase 2 — Log Pipelines

**Goal**: Unified log streaming from all sources into ELK.

### Pipeline Architecture

```
EC2 + EKS Pod Logs  → Vector (DaemonSet)    → MSK: app.logs.raw
WAF / GD / CT Logs  → S3 → Logstash S3 in  → MSK: security.logs.raw
EC2 Endpoints       → Elastic Agent          → MSK: endpoint.logs.raw
                                                      ↓
                                              Logstash Aggregator
                                                      ↓
                                               Elastic Cloud (ELK)
```

### Kafka — Amazon MSK ✅

| Setting       | Value                                |
| ------------- | ------------------------------------ |
| Instance type | `kafka.t3.small` (~$0.21/hr)         |
| Kafka version | 3.6.x (latest stable)                |
| Storage       | 100 GiB per broker                   |
| Auth          | IAM-based (no plaintext credentials) |
| Encryption    | TLS in-transit + at-rest             |

**Topics**: `app.logs.raw` · `security.logs.raw` · `endpoint.logs.raw`

### Vector Config (DaemonSet on EKS)

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
    bootstrap_servers: "${MSK_BOOTSTRAP_ENDPOINT}:9092"
    topic: "app.logs.raw"
    tls:
      enabled: true
```

### AWS Native Log Integration

- GuardDuty findings → Kinesis Data Firehose → S3
- WAF / CloudTrail → **Logstash S3 input plugin** directly into ELK (simpler for initial setup; move to Lambda when throughput scales)

### Portfolio Deliverables

- End-to-end pipeline diagram
- Vector config with MSK TLS explanation
- Kafka topic design rationale
- Log sample screenshots (raw → parsed → indexed)

---

## Phase 3 — SIEM & Monitoring (ELK)

**Goal**: Full SIEM with dashboards, field normalization, and identity integration.

### Elastic Cloud Deployment ✅

| Tier            | Cost         | Included                                 |
| --------------- | ------------ | ---------------------------------------- |
| Free trial      | $0 / 14 days | Full Enterprise (ML, XDR, LLM connector) |
| Standard (2 GB) | ~$95/mo      | All features                             |
| Standard (4 GB) | ~$175/mo     | Recommended if ingesting all sources     |

### What I'll Build

| Task                 | Detail                                                        |
| -------------------- | ------------------------------------------------------------- |
| Logstash pipeline    | Ingest from MSK (all 3 topics) + S3                           |
| Index templates      | ECS-normalized field mappings                                 |
| Ingest pipelines     | Grok/dissect for WAF, GuardDuty, CloudTrail, VPC Flow Logs    |
| Kibana dashboards    | Per-source + unified SOC dashboard                            |
| **Okta integration** | Okta System Log → Logstash → ELK (developer.okta.com ✅)      |
| XDR                  | Elastic Security XDR — endpoint + cloud telemetry in one view |
| Grafana _(optional)_ | EKS node/pod metrics via Prometheus Operator                  |

### Portfolio Deliverables

- ELK architecture write-up
- Kibana dashboard screenshots
- ECS field normalization guide
- Okta + SIEM integration walkthrough

---

## Phase 4 — Threat Detection & Ticketing

**Goal**: Detection rules mapped to MITRE ATT&CK with automated alerting.

### Detection Coverage

| Category  | Log Source     | Example Techniques                       |
| --------- | -------------- | ---------------------------------------- |
| Web App   | WAF logs       | SQLi, XSS, path traversal                |
| Container | EKS audit logs | Privilege escalation, container escape   |
| Identity  | **Okta logs**  | Brute force, MFA fatigue, session hijack |
| Cloud     | CloudTrail     | IAM anomaly, unusual API calls           |
| Network   | VPC Flow Logs  | Port scans, data exfiltration            |

### Alert Workflow

```
Detection Rule Fires in Kibana
       ↓
Kibana Connector
  ├── Slack webhook (immediate notification)
  └── JIRA REST API (auto-create ticket)
```

### Portfolio Deliverables

- Detection rule write-ups (3–5 highlighted rules with MITRE mapping)
- MITRE ATT&CK Navigator coverage map export
- Alert workflow diagram
- Example JIRA ticket screenshots

---

## Phase 5 — Active Threat Detection (EDR + Red Team)

**Goal**: Validate detection rules against simulated adversarial activity.

### Endpoint Setup — EC2 ✅

| OS                  | EC2 Type  | Role     | Agent                  |
| ------------------- | --------- | -------- | ---------------------- |
| Windows Server 2022 | t3.medium | Target   | Elastic Agent + Sysmon |
| Ubuntu 22.04        | t3.small  | Target   | Elastic Agent          |
| Kali Linux          | t3.small  | Attacker | Atomic Red Team        |

> All endpoints are in the **same VPC as EKS** — VPC Flow Logs capture all lateral movement for free.  
> Estimated cost: **~$50–80/mo** when all running. Shut down between sessions.

### Atomic Red Team Workflow

```
1. Pick ATT&CK technique  →  e.g. T1059.001 (PowerShell Execution)
2. Run Atomic test on Windows endpoint
3. Check Kibana: did the detection fire?
4. No alert?  →  write custom KQL/EQL rule
5. Document: technique + rule + screenshot in portfolio
```

### Portfolio Deliverables

- Elastic Agent install guide (Windows + Linux)
- Atomic Red Team results table (technique → detected? → rule name)
- Custom rule write-ups for coverage gaps

---

## Phase 6 — AI / ML Integration

**Goal**: Show AI/ML capability across both Elastic and AWS Bedrock.

### 6A — Elastic ML & AI Assistant

| Feature                  | Detail                                                                            |
| ------------------------ | --------------------------------------------------------------------------------- |
| Built-in ML rules        | [Elastic ML detection rules](https://elastic.github.io/detection-rules-explorer/) |
| Anomaly detection        | Unusual process, network, login behaviors                                         |
| **Elastic AI Assistant** | RAG over log data in real time (included in trial)                                |
| LLM connector            | Connect AI Assistant to **AWS Bedrock (Claude)**                                  |

### 6B — AWS Bedrock Integration

```
ELK Alert → Lambda
                ↓
         Amazon Bedrock (Claude 3 Sonnet)
                ↓
         Summarize + contextualize finding
         + suggest remediation steps
                ↓
         Response stored back in ELK index

Bedrock Guardrails:
  - Prompt injection protection
  - PII filtering
  - Guardrail logs → ingested into ELK
```

### Portfolio Deliverables

- Elastic ML rule coverage summary
- Bedrock architecture diagram
- Demo: natural-language query against security data
- Guardrail bypass attempt + detection write-up (AI security angle)

---

## Phase 7 — Vulnerability Management & DevSecOps

**Goal**: Integrate security into the SDLC and correlate VM findings in the SIEM.

### DevSecOps Pipeline

```
GitHub PR → GitHub Actions
  ├── SAST: CodeQL / SonarQube
  ├── Dependency scan: Snyk / Dependabot
  ├── Container scan: Trivy (ECR images)
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
| OpenVAS _(optional)_     | Self-hosted scanner       |

### Capstone Use Case

> **CVE discovered** by Inspector → **exploit attempt** seen in WAF logs → **correlated alert** in ELK → **JIRA incident** auto-created → **patch deployed** via CI/CD → **verified** by Inspector rescan

### Portfolio Deliverables

- DevSecOps pipeline diagram
- Scan results with triage decisions
- Capstone case study write-up (CVE → alert → remediation)

---

## Terraform Plan (After Manual Build)

Once each component is working manually, encode it as Terraform:

```
terraform/
  modules/
    eks/           # EKS cluster + node groups + IRSA
    msk/           # Amazon MSK cluster + topics
    security/      # WAF, GuardDuty, CloudTrail, VPC Flow Logs
    ec2-endpoints/ # Windows Server 2022 + Ubuntu + Kali
    iam/           # Roles, policies, instance profiles
  envs/
    lab/           # terraform.tfvars for lab
```

The portfolio story: **build manually to understand it → encode as IaC to prove you can automate it.**

---

## Hugo Site Content Structure

```
content/posts/
  ├── phase1-app-infrastructure.md
  ├── phase1-eks-cicd.md
  ├── phase2-log-pipeline.md
  ├── phase2-msk-vector.md
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

## Build Sequence & Timeline

| Phase                         | Estimated Duration | Depends On |
| ----------------------------- | ------------------ | ---------- |
| 1 – App & Security Infra      | 3 weeks            | —          |
| 2 – MSK + Log Pipeline        | 3 weeks            | Phase 1    |
| 3 – Elastic Cloud SIEM        | 2 weeks            | Phase 2    |
| 4 – Detection Rules           | 2 weeks            | Phase 3    |
| 5 – EDR + Atomic Red Team     | 2 weeks            | Phase 4    |
| 6 – AI/ML (Elastic + Bedrock) | 2 weeks            | Phase 3    |
| 7 – DevSecOps + VM            | 2 weeks            | Phase 4    |
| Terraform IaC pass            | 2 weeks            | All phases |

> ⚠️ **Cost estimate while building**: EKS (~$80) + MSK (~$150) + Elastic Cloud (~$95–175) + EC2 endpoints (~$50–80) ≈ **$375–505/mo**.  
> Shut down MSK, EC2 endpoints, and EKS node groups when not actively working.

---

## Verification Checkpoints

| Phase | How to Verify                                                           |
| ----- | ----------------------------------------------------------------------- |
| 1     | App accessible via ALB; WAF blocks OWASP Top 10 test payloads           |
| 2     | Messages in MSK topic; logs appear in ELK index                         |
| 3     | All sources in Kibana; **Okta login events** indexed                    |
| 4     | Simulated brute force triggers detection + Slack + JIRA                 |
| 5     | Atomic Red Team test fires alert in Kibana                              |
| 6     | ML anomaly detected; Bedrock returns contextualized response            |
| 7     | CodeQL finding creates JIRA ticket; Inspector finding correlated in ELK |
