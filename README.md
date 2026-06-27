# 🚗 Mobility — MERN Cloud Native, DevSecOps & IaC

Application de gestion de flotte de mobilité (véhicules, disponibilités), construite en **stack MERN**, conteneurisée, déployée sur **AWS** via un pipeline **CI/CD** sécurisé, et dont l'infrastructure est entièrement décrite en **Infrastructure as Code (Terraform)**.

> Projet personnel réalisé dans le cadre de mon Master **Cloud Computing & Mobility**, pour monter en compétences sur le **Cloud Native**, le **DevSecOps** et l'**IaC**.

![Node.js](https://img.shields.io/badge/Node.js-24-339933?logo=node.js&logoColor=white)
![React](https://img.shields.io/badge/React-Vite-61DAFB?logo=react&logoColor=black)
![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-ECS%20Fargate-FF9900?logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)

## ✨ Aperçu

Une API REST de mobilité (CRUD de véhicules) avec une interface React, conteneurisée et déployée dans le cloud de façon **automatisée, sécurisée et reproductible**. L'objectif n'est pas la complexité fonctionnelle, mais de démontrer une **chaîne Cloud Native complète**, du code local jusqu'à une infrastructure gérée par code.

## 🏗️ Architecture

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
                                                (URI lu au démarrage,
                                                 jamais en clair)
```

Authentification GitHub → AWS via **OIDC** (aucun secret AWS stocké). Infrastructure (ECR, ECS, pare-feu, logs, secret) **décrite et gérée avec Terraform**.

## 🛠️ Stack technique

| Couche               | Technologies                                     |
|----------------------|--------------------------------------------------|
| Frontend             | React (Vite), servi par nginx                    |
| Backend              | Node.js, Express (API REST)                       |
| Base de données      | MongoDB (Mongoose) — Atlas en production          |
| Conteneurisation     | Docker, Docker Compose, build multi-stage         |
| Cloud                | AWS ECS Fargate, ECR, IAM, Secrets Manager        |
| Infrastructure (IaC) | Terraform (HCL)                                   |
| CI/CD                | GitHub Actions, OIDC                              |
| Sécurité (DevSecOps) | Gitleaks (secrets), Trivy (vulnérabilités)        |
| Observabilité        | Amazon CloudWatch Logs                            |

## 🔒 Pratiques DevSecOps mises en œuvre

- **Authentification OIDC** entre GitHub et AWS — pas de clés d'accès stockées.
- **Gestion des secrets** via AWS Secrets Manager : l'URI MongoDB est stocké chiffré et lu par le conteneur au démarrage (`valueFrom`), jamais en clair dans la configuration.
- **Moindre privilège** : rôles et permissions IAM ciblés (lecture du secret limitée à la ressource concernée).
- **Scan de secrets** (Gitleaks) et **scan de vulnérabilités d'image** (Trivy) à chaque push.
- **Images Docker durcies** : base Alpine, multi-stage, dépendances de production uniquement.

## 🧱 Infrastructure as Code (Terraform)

L'infrastructure AWS est décrite dans le dossier `terraform/` et appliquée via le cycle `init` → `plan` → `apply`. Ressources gérées en code :

- Dépôt **ECR** (avec scan d'images à la poussée activé)
- **Secrets Manager** : le secret `MONGO_URI` + une politique IAM de lecture au moindre privilège
- **Task definition** et **service ECS Fargate** (lecture du secret via `valueFrom`)
- **Security group** (pare-feu, port 5000)
- **Groupe de logs CloudWatch**

Bonnes pratiques appliquées : variables paramétrées, idempotence vérifiée (`plan` sans changement), `terraform.tfstate` et `*.tfvars` exclus du dépôt (jamais de secret commité), `.terraform.lock.hcl` versionné.

## 🚀 Lancer le projet en local

Prérequis : Docker et Docker Compose.

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

## ☁️ Déploiement

Chaque `git push` sur `main` déclenche le pipeline GitHub Actions qui build, scanne, pousse l'image sur ECR et redéploie le service ECS Fargate (géré par Terraform) — sans intervention manuelle.

## 📁 Structure du projet

```
mobility-app/
├── backend/                # API Node.js + Express
├── frontend/               # App React (Vite) + nginx
├── terraform/              # Infrastructure as Code
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf             # ECR
│   ├── secrets.tf          # Secrets Manager + IAM
│   ├── ecs.tf              # Task definition + service + logs
│   └── network.tf          # VPC/subnets + security group
├── .github/workflows/      # Pipeline CI/CD
└── docker-compose.yml
```

## 🗺️ Feuille de route

- [x] **Projet 1** — MERN conteneurisé en local (Docker Compose)
- [x] **Projet 2** — Déploiement AWS + CI/CD + scans de sécurité
- [x] **Projet 3** — Infrastructure as Code (Terraform) + Secrets Manager
- [ ] **Projet 4** — Kubernetes (EKS) & observabilité
- [ ] **Projet 5** — GitOps (ArgoCD) & DevSecOps avancé

## 📝 Notes & limites assumées

Projet d'apprentissage, avec des améliorations « production » identifiées et documentées :
- Les rôles **IAM/OIDC** ont été créés manuellement (prochaine étape : les migrer en Terraform pour une infra 100 % IaC).
- Le **state Terraform** est local ; en production, un backend distant chiffré (S3 + verrouillage) serait utilisé.
- Pas de **load balancer** : l'IP publique du service change à chaque déploiement (amélioration prévue : un Application Load Balancer pour une adresse stable, puis HTTPS).