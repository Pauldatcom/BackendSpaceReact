# 🚀 BackendSpaceReact

Un backend Express + TypeScript conçu pour alimenter un système solaire interactif avec des données d’exoplanètes issues de la NASA.

## 🧠 Objectif

Ce projet fournit une API simple et optimisée pour récupérer dynamiquement des exoplanètes en s'appuyant sur la **NASA Exoplanet Archive**. Il est destiné à être consommé par une application React Three Fiber.

---

## 🛠️ Stack Technique

- **Node.js + Express** : serveur HTTP léger et performant
- **TypeScript** : typage strict pour éviter les erreurs
- **Axios** : client HTTP pour requêtes externes
- **Node-Cache** : système de cache en mémoire (TTL configurable)
- **Railway** : déploiement cloud en continu

---

## ⚙️ Fonctionnalité principale

### 📡 Contrôleur Exoplanets

Le contrôleur `exoplanets.ts` envoie une **requête SQL personnalisée** à l’API publique de la NASA :
> [NASA Exoplanet Archive TAP](https://exoplanetarchive.ipac.caltech.edu/docs/program_interfaces.html)

#### Exemple de requête SQL utilisée :
     $query = <<<EOD
    SELECT top 500 pl_name, MAX(pl_rade) AS pl_rade, MAX(disc_year) AS disc_year
    FROM ps
    WHERE pl_rade IS NOT NULL
    GROUP BY pl_name
EOD;

$encodedQuery = urlencode($query);
$url = "https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query={$encodedQuery}&format=csv";

Passage des informations du CSV au PHP. 
