# 🚗 Mobility — MERN Cloud Native

Application de gestion de flotte de mobilité (véhicules, disponibilités),
construite avec la stack MERN et entièrement conteneurisée.

Projet réalisé dans le cadre de mon Master Cloud Computing & Mobility,
avec un objectif de montée en compétences DevSecOps & Cloud Native.

## 🛠️ Stack technique

- **Frontend** : React (Vite), servi par nginx
- **Backend** : Node.js / Express (API REST)
- **Base de données** : MongoDB (Mongoose)
- **Conteneurisation** : Docker, Docker Compose (build multi-stage)

## 🏗️ Architecture

Trois services orchestrés par Docker Compose, communiquant sur un réseau privé :

| Service   | Rôle                         | Port (hôte) |
|-----------|------------------------------|-------------|
| frontend  | Interface React (nginx)      | 3000        |
| backend   | API REST Express             | 5000        |
| mongo     | Base de données MongoDB      | 27017       |

## 🚀 Lancer le projet en local

Prérequis : Docker et Docker Compose installés.

```bash
git clone https://github.com/ablamine-dev/mobility-app.git
cd mobility-app
docker compose up --build
```

Puis ouvrir : http://localhost:3000

## 📡 Endpoints de l'API

| Méthode | Route             | Description                  |
|---------|-------------------|------------------------------|
| GET     | /api/health       | Vérifie que l'API répond     |
| GET     | /api/vehicles     | Liste tous les véhicules     |
| POST    | /api/vehicles     | Ajoute un véhicule           |

## 🗺️ Feuille de route

- [x] Projet 1 — MERN conteneurisé en local
- [ ] Projet 2 — Déploiement AWS + CI/CD + scans de sécurité
- [ ] Projet 3 — Infrastructure as Code (Terraform)
- [ ] Projet 4 — Kubernetes & observabilité
- [ ] Projet 5 — GitOps & DevSecOps complet