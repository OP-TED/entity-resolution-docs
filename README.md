# Entity Resolution Service — Architecture and Specification Documentation

This repository contains the **official baseline architecture, technical specifications, and use-case catalogue** for the Entity Resolution System (ERSys) ecosystem.

The documentation establishes the architectural foundation, integration contracts, and decision records that govern all ERSys implementations.

## 📖 Documentation

**Live documentation:** https://meaningfy-ws.github.io/entity-resolution-docs/

## Contents

- **ERS Architecture** — System scope, actors, capabilities, behaviour spines, conceptual models, and deployment architecture
- **ERS–ERE Technical Contract** — Message-based integration specification, idempotent processing rules, and canonical identifier semantics
- **Annexe A: Glossary** — Normative definitions of all domain and system terms
- **Annexe B: Use Cases** — White (business) and Blue (system) level use cases using Cockburn format
- **Annexe C: Architecture Decision Records** — Key architectural decisions grouped by theme (A–G)

---

## Getting Started

### Prerequisites

- **Node.js** (v18+) and **npm** — for building the documentation
- **Python 3** — for local preview server
- **Make** — for convenient build commands (optional but recommended)

### Install Dependencies

```bash
# Initialize Antora and install required packages
make install-antora
```

Or manually:

```bash
npm install
npm install -D antora @antora/cli @antora/site-generator
npm i -D @sntke/antora-mermaid-extension
```

---

## Building the Documentation

### Build locally

```bash
make build-docs
```

Output is written to `docs/build/site/`.

**Or manually:**
```bash
npx antora docs/antora-playbook.local.yml
```

### Preview locally

Build and serve at `http://localhost:8080`:

```bash
make preview-docs
```

Then open your browser and navigate to `http://localhost:8080`.

To stop the server, press `Ctrl+C`.

### Clean build artifacts

```bash
make clean-docs
```

---

## Updating the Documentation

### Directory structure

```
docs/
├── modules/ROOT/
│   ├── pages/
│   │   ├── index.adoc              # Landing page (high-level orientation)
│   │   ├── ERSArchitecture/        # Baseline architecture
│   │   │   ├── introduction.adoc
│   │   │   ├── scope.adoc
│   │   │   ├── actors.adoc
│   │   │   └── ... (other pages)
│   │   ├── ERS-ERE-Contarct/       # Technical contract
│   │   ├── AnnexeA-Glossary/       # Glossary
│   │   ├── AnnexeB-UseCases/       # Use cases
│   │   └── AnnexeC-ADRs/           # Architecture Decision Records
│   ├── images/                      # Images and diagrams
│   └── nav.adoc                     # Navigation tree for the sidebar
├── antora-playbook.local.yml        # Local Antora config (development)
└── antora-playbook.yml              # Production Antora config

```

### Editing pages

1. **Edit an existing page** — modify the corresponding `.adoc` file in `docs/modules/ROOT/pages/`.
2. **Add a new page** — create a new `.adoc` file and update `nav.adoc` to include it in the navigation tree.
3. **Build locally** — run `make preview-docs` to see your changes.
4. **Commit and push** — once satisfied, commit and push to your feature branch.

## Deployment

### Manual deployment

To preview locally teh docs.

```bash
make preview-docs
# Upload docs/build/site/ to your host
```

Build the site and upload `docs/build/site/` to any static hosting:

```bash
make build-docs
# Upload docs/build/site/ to your host
```


---

## Contributing

1. **Create a feature branch** from `develop`:
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/ERS-XXX-description
   ```

2. **Edit documentation** using AsciiDoc (`.adoc` files).

3. **Preview locally:**
   ```bash
   make preview-docs
   ```

4. **Commit and push:**
   ```bash
   git add docs/modules/ROOT/pages/...
   git commit -m "Brief description of changes"
   git push origin feature/ERS-XXX-description
   ```

5. **Open a Pull Request** against `develop`.

6. **Merge** after approval. GitHub Actions will automatically build and deploy.

---


## License

This documentation is licensed under the **Apache License 2.0**.

You are free to:
- Use, copy, and modify the documentation
- Distribute it, with or without modifications
- Use it for commercial and private purposes

**Under the condition that you:**
- Include a copy of the Apache 2.0 license with any distribution
- Provide attribution to the original authors
- State significant changes you made to the documentation

See [LICENSE](./LICENSE) for the full text.
