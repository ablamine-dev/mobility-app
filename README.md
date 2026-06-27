# 🚗 Mobility — MERN Cloud Native & DevSecOps

Application de gestion de flotte de mobilité (véhicules, disponibilités), construite en **stack MERN**, entièrement conteneurisée, et déployée sur **AWS** via un pipeline **CI/CD** intégrant des **scans de sécurité automatisés**.

> Projet personnel réalisé dans le cadre de mon Master **Cloud Computing & Mobility**, pour monter en compétences sur le **Cloud Native** et le **DevSecOps**.

![Node.js](https://img.shields.io/badge/Node.js-24-339933?logo=node.js&logoColor=white)
![React](https://img.shields.io/badge/React-Vite-61DAFB?logo=react&logoColor=black)
![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-ECS%20Fargate-FF9900?logo=amazonaws&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)

## ✨ Aperçu

Une API REST de mobilité (CRUD de véhicules) avec une interface React, le tout conteneurisé et déployé dans le cloud de façon **automatisée et sécurisée**. L'objectif n'est pas la complexité fonctionnelle, mais de démontrer une **chaîne Cloud Native complète**, du code local jusqu'à la production.

## 🏗️ Architecture

```
git push  ──►  GitHub Actions (CI/CD)
                 │  1. Gitleaks   (scan de secrets)
                 │  2. Build      (image Docker)
                 │  3. Trivy      (scan de vulnérabilités)
                 │  4. Push       ──►  AWS ECR (registre d'images)
                 └► 5. Deploy     ──►  AWS ECS Fargate (conteneur en ligne)
                                          │
                                          └──►  MongoDB Atlas (base managée)
```

Authentification GitHub → AWS via **OIDC** : aucun secret AWS longue durée n'est stocké.

## 🛠️ Stack technique

| Couche            | Technologies                                  |
|-------------------|-----------------------------------------------|
| Frontend          | React (Vite), servi par nginx                 |
| Backend           | Node.js, Express (API REST)                   |
| Base de données   | MongoDB (Mongoose) — Atlas en production      |
| Conteneurisation  | Docker, Docker Compose, build multi-stage     |
| Cloud             | AWS ECS Fargate, ECR, IAM                      |
| CI/CD             | GitHub Actions, OIDC                           |
| Sécurité (DevSecOps) | Gitleaks (secrets), Trivy (vulnérabilités) |

## 🔒 Pratiques DevSecOps mises en œuvre

- **Authentification OIDC** entre GitHub et AWS — pas de clés d'accès stockées.
- **Moindre privilège** : rôle IAM dédié, verrouillé sur le dépôt, permissions ciblées.
- **Gestion des secrets** : aucun secret dans le code (variables d'environnement, `.gitignore`).
- **Scan de secrets** (Gitleaks) et **scan de vulnérabilités d'image** (Trivy) à chaque push.
- **Images Docker durcies** : base Alpine, multi-stage, dépendances de production uniquement.

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

Chaque `git push` sur `main` déclenche le pipeline GitHub Actions qui build, scanne, pousse l'image sur ECR et redéploie le service ECS Fargate — sans intervention manuelle.

## 🗺️ Feuille de route

- [x] **Projet 1** — MERN conteneurisé en local (Docker Compose)
- [x] **Projet 2** — Déploiement AWS + CI/CD + scans de sécurité
- [ ] **Projet 3** — Infrastructure as Code (Terraform) + Secrets Manager
- [ ] **Projet 4** — Kubernetes (EKS) & observabilité
- [ ] **Projet 5** — GitOps (ArgoCD) & DevSecOps avancé

## 📝 Note

Projet d'apprentissage : certains choix privilégient la pédagogie (ex. variable d'environnement plutôt que Secrets Manager, pas de load balancer). Les améliorations « production » sont documentées dans la feuille de route.