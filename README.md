# 🚗 Mobility — Cloud Native, DevSecOps, IaC, Kubernetes & GitOps

Application de gestion de flotte de mobilité (véhicules, disponibilités), construite en **stack MERN**, conteneurisée, déployée sur **AWS** via un pipeline **CI/CD** sécurisé, avec une infrastructure décrite en **Infrastructure as Code (Terraform)**, orchestrée sur **Kubernetes** et pilotée en **GitOps** (ArgoCD).

> Projet personnel réalisé dans le cadre de mon Master (Réseaux & Infrastructures Cloud), pour monter en compétences sur le **Cloud Native**, le **DevSecOps**, l'**IaC**, l'**orchestration** et le **GitOps**.

![Node.js](https://img.shields.io/badge/Node.js-24-339933?logo=node.js&logoColor=white)
![React](https://img.shields.io/badge/React-Vite-61DAFB?logo=react&logoColor=black)
![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-ECS%20Fargate-FF9900?logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-kind-326CE5?logo=kubernetes&logoColor=white)
![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-EF7B4D?logo=argo&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)

## ✨ Aperçu

Une API REST de mobilité (CRUD de véhicules) avec une interface React, déployée de façon **automatisée, sécurisée et reproductible** — sur AWS (ECS Fargate), sur **Kubernetes**, et gérée en **GitOps**. L'objectif : démontrer une **chaîne Cloud Native complète**, du code local jusqu'au déploiement continu piloté par Git.

## 🏗️ Architecture (déploiement AWS)

```
git push  ──►  GitHub Actions (CI/CD)
                 │  1. Gitleaks   (scan de secrets)
                 │  2. Build      (image Docker)
                 │  3. Trivy      (scan de vulnérabilités)
                 │  4. Push       ──►  AWS ECR (registre d'images)
                 └► 5. Deploy     ──►  AWS ECS Fargate
                                          │
                          ┌───────────────┴───────────────┐
                          ▼                               ▼
                 MongoDB Atlas (base managée)   AWS Secrets Manager
```

Authentification GitHub → AWS via **OIDC** (aucun secret AWS stocké). Infrastructure **décrite et gérée avec Terraform**.

## 🔄 GitOps avec ArgoCD

L'application est aussi gérée en **GitOps** : Git est l'**unique source de vérité**, et **ArgoCD** (installé dans le cluster) synchronise en continu l'état du cluster avec le dépôt.

```
git push (k8s/)  ──►  Git  ──►  ArgoCD  ──►  Cluster Kubernetes
                       (source          (réconcilie en continu :
                        de vérité)        Synced / Healthy)
```

- **Déploiement = `git push`** : plus aucun `kubectl apply` manuel.
- **Self-heal** : toute modification faite hors de Git est automatiquement annulée.
- **Rollback** : revenir à un état précédent = un `git revert`.
- **Séparation des responsabilités** : manifestes applicatifs dans `k8s/`, définition ArgoCD dans `argocd/`.

## 🛠️ Stack technique

| Couche               | Technologies                                     |
|----------------------|--------------------------------------------------|
| Frontend             | React (Vite), servi par nginx                    |
| Backend              | Node.js, Express (API REST)                       |
| Base de données      | MongoDB (Mongoose) — Atlas en production          |
| Conteneurisation     | Docker, Docker Compose, build multi-stage         |
| Cloud                | AWS ECS Fargate, ECR, IAM, Secrets Manager        |
| Infrastructure (IaC) | Terraform (HCL)                                   |
| Orchestration        | Kubernetes (kind en local), kubectl               |
| GitOps               | ArgoCD                                            |
| CI/CD                | GitHub Actions, OIDC                              |
| Sécurité (DevSecOps) | Gitleaks (secrets), Trivy (vulnérabilités)        |
| Observabilité        | Amazon CloudWatch Logs                            |

## 🔒 Pratiques DevSecOps mises en œuvre

- **Authentification OIDC** entre GitHub et AWS — pas de clés d'accès stockées.
- **Gestion des secrets** : AWS Secrets Manager (AWS) et Secret Kubernetes (K8s) — l'URI MongoDB n'est jamais en clair.
- **Moindre privilège** : rôles et permissions IAM ciblés.
- **Scan de secrets** (Gitleaks) et **scan de vulnérabilités** (Trivy) à chaque push.
- **Images Docker durcies** : base Alpine, multi-stage, dépendances de production uniquement.

## 🧱 Infrastructure as Code (Terraform)

L'infrastructure AWS est décrite dans `terraform/` (cycle `init` → `plan` → `apply`) : dépôt **ECR** (scan activé), **Secrets Manager** + politique IAM de lecture, **task definition** et **service ECS Fargate**, **security group**, **groupe de logs CloudWatch**. `terraform.tfstate` et `*.tfvars` exclus du dépôt ; `.terraform.lock.hcl` versionné.

## ☸️ Kubernetes

Manifestes déclaratifs dans `k8s/` : **Deployment** (réplicas + auto-réparation), **Service** (adresse stable), **Secret** (`MONGO_URI` référencé, jamais en clair). Cluster local via **kind** (choix assumé pour le coût), transférable vers un cluster managé.

```bash
kind create cluster --name mobility
docker build -t mobility-backend:local ./backend
kind load docker-image mobility-backend:local --name mobility
kubectl create secret generic mobility-secrets --from-literal=MONGO_URI='<votre-uri>'
kubectl apply -f argocd/application.yaml   # ArgoCD déploie depuis Git
```

## 🚀 Lancer le projet en local (Docker Compose)

```bash
git clone https://github.com/ablamine-dev/mobility-app.git
cd mobility-app
docker compose up --build
```

Puis ouvrir http://localhost:3000

## 📡 Endpoints de l'API

| Méthode | Route             | Description              |
|---------|-------------------|--------------------------|
| GET     | /api/health       | État de santé de l'API   |
| GET     | /api/vehicles     | Liste des véhicules      |
| POST    | /api/vehicles     | Ajoute un véhicule       |

## 📁 Structure du projet

```
mobility-app/
├── backend/                # API Node.js + Express
├── frontend/               # App React (Vite) + nginx
├── terraform/              # Infrastructure as Code (AWS)
├── k8s/                    # Manifestes Kubernetes (Deployment, Service)
├── argocd/                 # Définition ArgoCD (Application GitOps)
├── .github/workflows/      # Pipeline CI/CD
└── docker-compose.yml
```

## 🗺️ Feuille de route

- [x] **Projet 1** — MERN conteneurisé en local (Docker Compose)
- [x] **Projet 2** — Déploiement AWS + CI/CD + scans de sécurité
- [x] **Projet 3** — Infrastructure as Code (Terraform) + Secrets Manager
- [x] **Projet 4** — Orchestration Kubernetes (kind en local)
- [x] **Projet 5** — GitOps avec ArgoCD

## 📝 Notes & limites assumées

Projet d'apprentissage, avec des améliorations « production » identifiées :
- Les rôles **IAM/OIDC** ont été créés manuellement (piste : les migrer en Terraform).
- Le **state Terraform** est local ; en production : backend S3 chiffré + verrouillage.
- Pas de **load balancer** sur ECS : IP publique changeante (piste : ALB + HTTPS).
- **Kubernetes et ArgoCD tournent en local (kind)** pour le coût ; le setup est transférable vers un cluster managé.
- Secrets créés en CLI ; en production : **Sealed Secrets** ou **External Secrets Operator**.
- Une seule application gérée ; étape suivante : pattern **app-of-apps** ArgoCD.