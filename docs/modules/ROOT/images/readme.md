# Architecture Diagrams Index

This folder contains architecture diagrams referenced by the ERSys Architecture Document, ADR set, and the ERS–ERE Technical Contract. The diagrams are provided as rendered images (`.png`) and represent **authoritative architectural views** at different abstraction levels.

Unless stated otherwise, these diagrams are **normative at their stated level** and are intended to be read together with the corresponding textual sections of the architecture documentation. Some diagrams provide high-level context, while others focus on specific concerns such as messaging, persistence, governance semantics, or deployment.

The views reflect the consolidated engine-authoritative baseline (13 Feb 2026), where cluster identifiers in ERE are canonical identifiers and ERS stores only the latest placement per mention.

---

## Context and layering diagrams

* [`L0.png`](./L0.png)
  System context diagram showing ERSys in relation to originators, downstream consumers, curators, and surrounding systems (e.g. TED-SWS pipeline).

* [`L1.png`](./L1.png)
  High-level functional decomposition of ERSys, identifying externally visible services and responsibility boundaries.

* [`L2 - Application Cooperation Overview.png`](./L2%20-%20Application%20Cooperation%20Overview.png)
  Application-level cooperation view showing how ERS (orchestration façade), ERE (authoritative clustering engine), and related components interact at runtime.

---

## Contract and integration diagrams

* [`L2 - Contract Realisation and Messaging Mediation (ERS-ERE).png`](./L2%20-%20Contract%20Realisation%20and%20Messaging%20Mediation%20%28ERS-ERE%29.png)
  Structural view of the ERS–ERE asynchronous contract, illustrating contract realisation by both components and mediation via messaging middleware.

* [`ERS messages.png`](./ERS%20messages.png)
  Overview of message types produced and consumed by ERS public APIs, including resolution, preview, decision submission, statistics, and refreshBulk.

* [`ere messages.png`](./ere%20messages.png)
  Overview of resolution request and response message types exchanged with the Entity Resolution Engine, including recommendation and reclustering variants.

* [`preview messages.png`](./preview%20messages.png)
  Message model related to entity and canonical preview operations, including pagination metadata.

* [`submit decision messages.png`](./submit%20decision%20messages.png)
  Message model for submission of curator recommendations (user actions) and associated cluster references.

* [`statistics messages.png`](./statistics%20messages.png)
  Messages exchanged for reporting and statistics purposes, including registry and curation metrics.

---

## Governance and persistence views

* [`decision store.png`](./decision%20store.png)
  Diagram illustrating the storage model of the Resolution Decision Store, containing the latest cluster placement and top N alternatives per mention.

* [`system of records.png`](./system%20of%20records.png)
  Overview of entity mentions, identifiers (sourceId, requestId, entityType), and lookup state within ERSys.

* [`user actions log.png`](./user%20actions%20log.png)
  Diagram of the User Action Log used for traceability and training, separated from canonical decision state.

Note: ERSys does not maintain a Canonical Entity Registry under the current baseline; canonical identity is materialised by ERE clusters.

---

## Technology and deployment diagrams

* [`Technology choices.png`](./Technology%20choices.png)
  Summary of selected technologies mapped to architectural roles (messaging, storage, identity, telemetry, container runtime).

* [`Technology deployment.png`](./Technology%20deployment.png)
  Reference deployment architecture illustrating runtime stacks (ERS, ERE, Link Curation), messaging middleware, datastores, and container isolation boundaries.

---

## Notes

* Diagram filenames correspond to figures referenced in the architecture document; titles in the document may be more descriptive than filenames.
* Some diagrams are intentionally high-level and omit implementation details; others focus on specific concerns (messaging, persistence, deployment).
* Behavioural details and step-by-step flows (e.g. provisional lifecycle, asynchronous resolution) are documented separately using sequence diagrams.
* Where both simplified and detailed views exist, the architecture document explicitly indicates which view is normative for the given section.
* In case of ambiguity, the consolidated engine-authoritative baseline governs interpretation.
