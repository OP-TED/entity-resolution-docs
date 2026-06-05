# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [unreleased]

## [1.1.0] - 2026-05-15
### Added
* ERSys top-level section covering system scope and the role of each component
* User-facing sections and navigation structure for the ERSys documentation area
* Bulk actions section with annotated screenshots added to the curation decisions guide
* Documentation remediation specification capturing known issues and planned corrections

### Changed
* Home page renamed to Introduction throughout the navigation
* Acronyms expanded in top-level navigation labels; kept abbreviated in submenu entries
* Navigation restructured: ADR menu entry added, misnamed pages corrected
* Glossary consolidated onto a single page with shared Antora partials
* Architecture section revised for accuracy and consistency
* Architecture Decision Records revised and updated
* ERE developer guide and ERS-ERE technical contract revised
* Curation web application user guide revised
* Use case catalogue revised and realigned with the architecture
* ERS service documentation revised for correctness
* Antora playbook updated to source component content from the project repository fork
* Path templates escaped in the generated Curation API spec

## [1.0.0-rc.1] - 2026-04-21

### Added
* documentation site: Antora-based setup with CI build and GitHub Pages deployment
* architecture: system scope, actors, core capabilities, behaviour spines, conceptual model, and deployment architecture
* ERS-ERE contract: message-based interface specification, normative response ordering rules, and singleton cluster score semantics
* ERE developer guide: integration checklist, implementation guidelines, and compliance requirements
* ERE reference implementation page: online greedy clustering, Redis messaging, and configurable RDF parsing
* API reference: auto-generated documentation for ERS and Curation REST APIs; `make` target for regeneration
* user guide: curation app guide covering decision review, action history, and user management, with annotated screenshots
* use cases catalogue: worker and back-office workflows
* ADRs documenting key architectural decisions
* glossary of domain terms and abbreviations
