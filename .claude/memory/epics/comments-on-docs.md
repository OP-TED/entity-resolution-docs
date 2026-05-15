# Documentation Remediation Specification

Single source of truth for the documentation revision pass. Scope: the whole
docset **except `ERSArchitecture/`** (architecture pages are tracked
separately — see _Section 9_ for the one item that crosses over).

Methodology: Antora (AsciiDoc) conventions + Diátaxis applied _loosely_. The
operative Diátaxis rule is: **do not mix tutorial / how-to / reference /
explanation registers within a single page.**

Status legend: ✅ decided · ▶ actionable · ⏸ deferred · ❓ needs author input

---

## 0. Drift control (read before editing anything)

The dominant risk in a 25-page editorial pass is **semantic drift**:
rewording prose until a technical claim quietly changes meaning, or applying a
terminology decision unevenly so the docset contradicts itself. Mitigations,
enforced for every edit:

1. **Separate _editorial_ edits from _semantic_ edits.** Editorial =
   restructure, relabel, de-hedge, fix register, apply naming/anchor/format
   conventions. Semantic = change what a sentence asserts. Editorial edits
   **preserve every technical claim verbatim in meaning** — only the framing
   changes. Any semantic change (a corrected channel name, a reconciled
   threshold, a contract assertion) is called out explicitly in the commit and
   never bundled with editorial churn.
2. **The terminology table (Section 2) is the contract.** No synonym is
   introduced that is not in it. Decided terms are applied by mechanical
   sweep + grep gate, not by eye.
3. **Mechanical verification gates** (run after each batch, evidence reported):
   - `grep -rn "clusterId\|canonical_entity_id" pages/` → must be empty
   - `grep -rni "draft identifier\|draftIdentifier" pages/` → empty
   - `grep -rn "this document" pages/` → empty
   - `grep -rn "\[\[" pages/` (legacy anchors) → empty
   - `grep -rn "xref:ROOT:" pages/` → empty
   - emoji sweep (`🔴🟡🟢` and friends) → empty
   - `make build-docs` → succeeds with no new broken-xref warnings
4. **Batch by risk, lowest first.** Pure mechanical sweeps before structural
   moves before prose rewrites. Each batch is independently verifiable and
   commit-sized; nothing proceeds on a red gate.
5. **One concept changes in one place.** Duplicated content is consolidated to
   a partial _before_ its wording is touched, so a claim cannot diverge between
   copies mid-pass.
6. **No paraphrasing of normative or wire-contract text.** Contract field
   names, JSON, and MUST/SHALL clauses are transformed only by the explicit
   rules in Section 2 (snake_case, RFC 2119 normalisation) — never reworded.
7. **Read the whole page before and diff after.** Every page is read in full
   pre-edit; the post-edit diff is reviewed against the relevant Section 5
   item before moving on.

---

## 1. Editorial principles (apply everywhere)

1. **Start with what something _is_.** Lead with the positive statement, then
   optionally sharpen it with a contrasting "not…" as an example or inline
   list. Never open a page, section, or definition with a negation.
2. **"this document" → "this section"** on multi-part pages; on standalone
   pages use the artefact's own noun ("this guide", "this catalogue"). Never
   leave a bare "this document".
3. **One concept, one name.** Use the canonical term (Section 2) on first use
   and link it to the glossary; do not introduce synonyms mid-docset.
4. **Reference register is declarative.** No "as you can see", "see below", "we
   list" narration in reference or contract pages.
5. **No emoji** anywhere — not for status, scores, or decoration. Use AsciiDoc
   admonitions, table roles, or labelled swatches.

---

## 2. Resolved terminology and conventions (✅ decided)

These decisions are final and binding for the whole revision.

| Concern | Decision |
|---|---|
| Identifier field name | **`cluster_id`** — the LinkML model name, mirrored in the contract. Do not use `clusterId`, `canonical_entity_id`, or invented variants. |
| Identifier in prose | **"canonical identifier"** and **"cluster identifier"** are both acceptable, chosen by context (canonical = the stable consumer-facing promise; cluster = the ERE-side construct). |
| Provisional vs draft | **"provisional"**. "Draft" / "Draft Identifier" is obsolete — purge it, including from the glossary preferred term. |
| Curation action terms | "Assign", "Select Alternative", "Use this cluster instead" are all acceptable in their UI context; no forced unification. |
| JSON / wire field casing | **snake_case** everywhere — every example, prose mention, and LinkML/generated artefact. Fix all camelCase occurrences and invalid JSON (trailing commas). |
| RFC 2119 keywords | Use **only in the ERS–ERE Contract** (`ERS-ERE-Contract/`). One boilerplate paragraph, uppercase MUST/SHALL/SHOULD. Elsewhere use plain descriptive prose ("the ERE must…" stays lowercase and non-normative). |
| Anchors | Use `[#anchor]`. Replace every legacy `[[anchor]]`. |
| Same-component xrefs | Drop the redundant `ROOT:` family prefix. |
| External repo links | Drive through document attributes (Section 8), not raw URLs. |
| Images | Every `image::` needs alt text; asset filenames are hyphenated slugs (no spaces/parentheses); figure placement is **image-before-the-table/section it illustrates**, consistently. |

---

## 3. Shared-content strategy (✅ decided — proposed home)

Several blocks are duplicated across pages and will drift. Extract them to a
**partials family** and `include::` them:

```
docs/modules/ROOT/partials/
  shared/system-overview.adoc      ← the 3-component description
  shared/role-routing.adoc         ← the "by user type" entry-point table
  shared/next-steps.adoc           ← the recurring "where to go next" links
  glossary/intro-purpose-scope.adoc
  glossary/glossary-1.adoc
  glossary/glossary-2.adoc
```

Rules:

- Canonical home for the **system overview** and **role-routing table** is
  `ERSys/index.adoc` (Overview); `index.adoc` (Home) and `getting-started.adoc`
  `include::` the partial or link to the Overview — they do not restate it.
- The **canonical-identifier derivation rule** has exactly one normative home
  (Section 7, contract); every other mention is a one-line `xref`, never a
  restatement.
- Glossary subpages move under `partials/glossary/` so the Glossary index can
  `include::` them on one page (Section 6).

Include syntax (leveloffset keeps heading depth correct under the page title):

```asciidoc
include::partial$shared/system-overview.adoc[leveloffset=+1]
```

---

## 4. Single-source-of-truth for error codes / pagination (⏸ deferred)

The API Integration Guide hand-maintains error/pagination tables that already
disagree with the generated specs (missing `APPLICATION_ERROR`,
`SERVICE_UNAVAILABLE`; the ERS bulk `continuation_cursor` pagination is
undocumented). **Deferred by decision** — not in this pass. Tracked here so it
is not lost; revisit when the spec-generation pipeline is in scope.

---

## 5. Page-by-page changes

### 5.1 Home — `index.adoc`

- ▶ Two competing intros (meta line "This documentation covers…" and
  `== Introduction`). Cut the meta line; open with the procurement problem.
- ▶ The system-overview prose duplicates `ERSys/index.adoc`. Replace with a
  2–3 sentence orientation + the shared partial / a link to Overview
  (Section 3). A landing page routes; it does not re-explain.
- ▶ Heading style is inconsistent — most sections are plain titles, three are
  clickable `xref` headings. Make all section headings plain; keep links in
  the tables and intros.
- ▶ Surface **Getting Started** as a prominent call-to-action near the top; it
  is currently buried as a below-the-fold table row.

### 5.2 ERSys — Overview

- ▶ Rewrite the `:description:` attribute to lead with capability (it currently
  bakes in "what it does / does not do").
- ▶ Split `== What ERSys Does NOT Do`: keep a short positive **Scope &
  Boundaries** list (state the boundary, then the exclusion as an example);
  promote the ERS/ERE authority content into a positive `== Authority Model`
  section. State the authority rule once (it currently repeats 3×).
- ▶ Add the requested **mermaid overview diagram**: user on top; below, left to
  right — main REST API, ERS, message queue, ERE; above ERS — curation REST
  API, then curation app. Additionally reuse architecture `L1.png` if it
  reads well here.
- ▶ Define `originator` and `entity mention` on first use (xref glossary).
- ▶ RDF: present as "the initial representation format; the system is designed
  to be extended to other formats as needed" — not as the only format.
- ▶ Remove "or ontology" from "Does not maintain an authoritative entity
  registry or ontology."
- ▶ De-hedge "Different ERE implementations can be used, each potentially
  applying…" → "Each ERE may apply different algorithms or support different
  entity types."
- ▶ Make the "Where to Start" role table the canonical one (Section 3); slim
  the Home table to match.
- ▶ Expand or drop the opaque ADR codes ("ADR-B1N, B2N, C1N").

### 5.3 ERSys — Getting Started

- ▶ Add an explicit **prerequisites** list before any repo link: Docker,
  Docker Compose, Make, git (and approximate disk/RAM). State plainly that a
  running full stack is a prerequisite for this section _and_ for Examples.
- ▶ Express "run the full stack" as the **goal**, then minimal steps: clone
  the three repos, set environment variables, `make up`; defer detail to each
  README. Add a verification step (e.g. `curl …/health` → 200) so the reader
  knows when they have succeeded.
- ▶ Fix the biggest Diátaxis violation in the docset: Workflow 1 _describes_
  the API instead of giving a copy-pasteable `curl` with a concrete body.
  Rewrite as a runnable how-to.
- ▶ Polling step needs a concrete expectation ("typically within N seconds; if
  still provisional after the time budget, see …"), not "poll until
  `CANONICAL`".
- ▶ Workflow 1 (API how-to) and Workflow 2 (UI tutorial) are different
  registers under one heading. Make Workflow 2 terse numbered steps, or move
  its narrative to the Curation User Guide and keep a 4-step skeleton.
- ▶ Delete filler ("This workflow demonstrates the single set of steps…").
- ▶ Add cross-links to **Examples**, **Configuration Reference**, and the
  **API Integration Guide**.

### 5.4 ERSys — Examples

- ▶ Add an `IMPORTANT` admonition at the top: assumes a running full stack;
  xref Getting Started.
- ▶ Define the endpoint base URL once via an attribute (Section 8) and reuse;
  it currently differs from Getting Started (`http://localhost:8001/…` vs
  `/api/v1/…`).
- ▶ The Error Response section is reference prose duplicating the Integration
  Guide — keep example bodies only.
- ▶ Fix the glossary xref target (points at `glossary-2.adoc`, diverging from
  the index target used elsewhere — and once the glossary is consolidated,
  Section 6, this becomes a single `xref` to the consolidated page).
- ▶ Define "mention triad" on first use (or xref glossary).
- ▶ Either deliver the accept/reject Curation examples the intro promises, or
  soften the intro to match the single `assign` example.
- ▶ Apply snake_case to every field (request currently uses `identifiedBy`).

### 5.5 ERS — Capabilities

- ▶ Reuse architecture `L1.png` near the top; the "pluggable ERE" /
  "message-queue decoupling" prose is a diagram.
- ▶ Stop duplicating endpoint paths from the generated API reference —
  describe the capability, link out.
- ▶ Remove marketing fluff ("absorbs bursts, enables independent scaling…")
  from reference material.
- ▶ Expand `ERE` on first use (xref glossary/architecture).
- ▶ Add explicit `[#…]` anchors to any section that is an xref target.

### 5.6 ERS — Configuration Reference

- ▶ Make it an actual reference: variable names, defaults, units, an example
  `.env`. Today it is three off-site GitHub links. `include::` or generate the
  variable table.
- ▶ Replace raw GitHub URLs (pinned to `develop`) with attribute-driven xrefs
  (Section 8).
- ▶ Open with the configuration model itself, not page meta-narration.

### 5.7 API docs

- ▶ **Integration Guide**: Authentication opens with what does _not_ need auth
  — lead with the positive rule. Quantify token lifetimes (or state they are
  deployment-configured and xref Configuration). Make endpoint auth coverage
  exhaustive (ERS has 6 endpoints; 3 are named). Replace `[[error-reference]]`
  with `[#error-reference]`. (Error/pagination reconciliation is ⏸ Section 4.)
- ⏸ **Generated `ers/index.adoc` / `curation/index.adoc`** — do **not**
  hand-edit. Generator/template fixes (HTML-entity bleed `&#x60;`/`&#39;`,
  duplicate H3 model titles, cross-file anchor collisions, leaked FastAPI
  internals and Python module paths, untyped curation `GET /health`, missing
  role column) are recorded for the spec-generation work, not this pass.

### 5.8 ERE + ERS–ERE Contract

- ▶ **Rename `suppliment.adoc` → `supplement.adoc`**; update the 3 xrefs +
  `nav.adoc`; add an explicit `[#configuration]` anchor (the dev-guide
  deep-link `…#configuration` currently resolves to nothing — Antora
  generates `_configuration`).
- ▶ **Resolve the dual "sole normative specification".** The
  canonical-identifier derivation rule lives once, in the contract; pick the
  body page (`introduction.adoc`) as its home and reduce `index.adoc` (and all
  other mentions) to a one-line `xref`. The index page becomes a pure TOC.
- ▶ Add the RFC 2119 boilerplate paragraph once (contract only, per Section 2)
  and normalise `shall`/`MUST`/`should` to uppercase keywords across the
  contract pages.
- ▶ **interface.adoc**: strip narrative register ("we list", "as you can see",
  "see below"); replace the literal Google-Docs anchor
  `'#heading=h.zc69jntu6wnj…'` with a real `xref`; fix invalid JSON (trailing
  commas) and apply snake_case to all examples + prose; correct the response
  channel ("entity resolution channel" → `ere_responses`); explain the
  request/response identifier asymmetry; move speculative ML prose out of the
  normative text; add a per-message field table (name / type / required /
  description).
- ▶ **supplement.adoc** (post-rename): retitle to match content (it is data
  model + traceability matrix + examples + configuration, not "The ERE Data
  Model") or split into focused pages. Fix typos ("resoultion", "previous
  model" → "section"); tidy the matrix cells; align external link refs
  (`1.0.0-rc.1` vs `develop`) via the Section 8 attribute.
- ▶ **ere-dev-guide.adoc**: it declares itself non-normative then restates
  contract MUSTs and a Conformance Checklist. Per Section 2, RFC 2119 lives
  only in the contract — here, soften to descriptive prose and reference the
  contract rather than re-deriving it. Split the mixed registers: keep the
  how-to (lifecycle, integration steps); move reference tables/YAML/checklist
  to reference pages and link them. Standalone page → "this guide".
- ▶ **ere-reference-impl.adoc**: cleanest page. Reconcile two real
  contradictions: (a) the SHA256(triad) cluster-id rule cannot hold for
  multi-member clusters as stated — clarify which member's triad seeds the id
  (flag upstream to the contract too); (b) the reference default
  `confidence_threshold` 0.20 vs the supplement's "keep near zero / avoid"
  recommendation. Lead with what it _is_ before "not production-ready".

### 5.9 User Guide (audience: non-technical curators)

- ▶ **overview**: move Authentication to the top (it is the first thing a
  curator does) and add a `login.png` screenshot. Split the login-failure
  guidance into distinct causes (wrong credentials vs unverified account) with
  the actual on-screen messages. Recast the engine-centric workflow prose into
  a curator-centric "start here" reading order. Define "simple statistics" or
  cut it.
- ▶ **decisions** (the model page — keep its structure): convert "Reviewing a
  Decision" from a prose wall to numbered steps with the diff-colour table as
  a reference sub-block; reframe diff colours away from the git mental model
  ("only in cluster / only in mention / different in each"). Fix "four
  toggles" then three named. Hoist the duplicated irreversibility WARNING and
  the "recommendation forwarded to engine" NOTE to one each. Document the
  empty / error / concurrent-edit states.
- ▶ **history**: add numbered task flows for its own stated goals (verify past
  feedback, investigate discrepancies); replace the lazy "similar layout to
  the Decisions page" with a real `xref` or a standalone description; reinforce
  the read-only nature at Action Detail.
- ▶ **admin** (best-structured — keep as template): add a Verified-vs-Active
  comparison block; rename "deactivate (delete) icon" to "deactivate icon"
  (it contradicts the non-destructive reassurance); document the
  password-change confirm field and error states; promote last-admin
  protection from NOTE to WARNING; restate the "must be a superuser"
  precondition per task.
- ▶ Add a shared **Troubleshooting** section (or per-page error subsections)
  covering login failure, unverified account, empty queue, concurrent edit,
  last-admin — routine states for this audience, not edge cases.

### 5.10 Glossary (Annexe A)

- ✅ **Keep the table format** (author decision). Consolidate: the index
  `include::`s the three subpages (moved under `partials/glossary/`,
  Section 3) so all definitions render on one page, each as a subsection — no
  extra clicks. Moving the files out of `pages/` also removes the duplicate
  standalone pages. The table layout itself is retained as-is.
- ▶ Fix the render bug: `glossary-1.adoc` has `[cols="2,4"]` on a 4-column
  table; `glossary-2.adoc` has no `cols` spec and a different layout. Adopt
  one spec — `[cols="2,3,4,2",options="header"]` — and apply it identically to
  both tables.
- ▶ Add a `[#term-…]` anchor on the row of each preferred term (block anchor
  immediately before the row) so use-case and architecture pages can `xref`
  definitions, mechanically enforcing "normative terminology". Format stays a
  table.
- ▶ Apply the Section 2 terminology decisions: preferred term is
  **"Provisional Identifier"** (retire "Draft Identifier"); remove the
  circular self-reference where "Mention Identifier" lists its own name as an
  alternative term.
- ▶ Add the missing normatively-used terms: **"Request Registry"** — define it
  as a synonym of **"System of Records"** (✅ author-confirmed they are the
  same; make one the preferred term and list the other as an alternative
  term); plus "client timeout budget", "ERS–ERE execution window", "delta".
- ▶ `intro-purpose-scope.adoc`: replace `+`-hard-break paragraphs with
  blank-line paragraphs; trim the essayistic conceptual framing and link to
  the architecture conceptual-model page instead; fix the
  "start-with-the-negative" openings; state the normativity claim once.

### 5.11 Use Cases (Annexe B)

- ▶ Publish one canonical Cockburn skeleton in `introduction.adoc` (fixed
  section list, fixed order, fixed heading levels, glossary-tied actor
  vocabulary) and conform all 10 files to it. Today section sets, ordering,
  and heading levels vary file to file, and standalone pages render without a
  `=` doctitle.
- ▶ Give every UC page a single `=` doctitle whose text matches the index/nav
  link text exactly.
- ▶ Deduplicate `ucw1`/`ucb11` (~80% identical): White states the contract
  tersely; Blue adds only the realisation and `xref`s White.
- ▶ Align actor names to glossary preferred terms ("Originator", "Curator");
  add or map the undefined ones ("Authorised User", "Operational Reviewer",
  "Admin").
- ✅ **No remodelling** (author decision): a system may legitimately be the
  primary actor here because one large use case is split into parts. Leave
  `ucb12`/`ucw3` actor assignment as-is; only normalise the template/format
  around them.
- ▶ `introduction.adoc`: "this document" / "How to read this document" → "this
  catalogue"; reorder to lead with what the catalogue _is_; name the Cockburn
  White/Blue altitude metaphor; `xref` (or remove) the hand-waved
  "authoritative artefact hierarchy".
- ▶ Add a `[#…]` anchor per use case so the glossary and architecture pages
  can link them.

---

## 6. Navigation & structure (`nav.adoc`)

- ✅ **Do not expand** the 10 use cases into the left nav (author decision).
  Index-as-hub stays. (A right-hand/in-page nav may be considered later — out
  of scope for this pass.)
- ⏸ **ADRs — out of scope.** No actionable ADR change in this pass; the
  earlier nav suggestion is withdrawn (author: unclear / not a concern, and it
  is architecture-adjacent). Left here only as a parked note.
- ▶ Add a `:description:` attribute to the contract pages (index /
  introduction / interface / supplement) for consistency and SEO.

---

## 7. AsciiDoc / Antora conventions (apply during every edit)

These are the formatting best practices to enforce while making the changes
above:

- **Paragraphs**: blank line between paragraphs. Reserve a trailing `+` for
  genuine intra-paragraph hard breaks only — never as a paragraph separator
  (current abuse in `intro-purpose-scope.adoc` and contract pages).
- **Anchors**: `[#id]` block-anchor syntax; lowercase, hyphenated, stable ids
  (`[#term-canonical-identifier]`). Never the legacy `[[id]]`.
- **Cross-references**: `xref:path/file.adoc#anchor[Link text]`; omit the
  `ROOT:` prefix within this component; always supply explicit link text.
- **Tables**: always declare `[cols=...,options="header"]` with a ratio per
  column; never let column count and ratio count disagree.
- **Admonitions**: use `NOTE`/`TIP`/`IMPORTANT`/`WARNING` blocks for callouts,
  preconditions, and irreversibility warnings — not bold inline prose, not
  emoji.
- **Images**: `image::path[Alt text, width]`; hyphenated slug filenames; place
  the figure before the table/section it illustrates; consistent width.
- **Attributes**: define reusable values once in the page header or
  `antora.yml`:
  - `:ers-repo:` / `:ere-repo:` — repository base URLs
  - `:default-branch:` / `:spec-ref:` — the ref external links pin to
  - `:ers-api-base:` — the example API base URL
- **Includes**: shared content lives under `partials/`; include with
  `include::partial$…[leveloffset=+N]` so heading depth stays correct.
- **One `=` doctitle per page**; section headings descend by exactly one level
  (`=` → `==` → `===`). No page may start at `==`.
- **Normative labelling** (contract only): one mechanism — a consistent
  heading suffix `(Normative)` / `(Informative)` _or_ admonition blocks, not a
  mix of inline, bracketed, and heading variants.

---

## 8. Author decisions (✅ all resolved)

1. **Glossary format** — keep the table format as-is (consolidate via
   `include::`, retain table layout).
2. **"Request Registry" = "System of Records"** — same entity; one glossary
   term with the other as an alternative term.
3. **Use-case nav** — do not expand into the left nav; index-as-hub stays.
4. **ADRs** — out of scope for this pass; no action.
5. **`ucb12`/`ucw3` system-as-primary-actor** — intentional (large UC split
   into parts); no remodelling.

---

## 9. Architecture, ADRs & Use-Case content (scope extension — 2026-05-15)

**Scope change:** the author re-scoped this pass to also cover
`ERSArchitecture/`, `AnnexeC-ADRs/`, and a content-level (not format) review
of `AnnexeB-UseCases/`. Section 0 drift-control and Section 1/2/7 conventions
apply unchanged. Findings below; ✅/▶/⏸/❓ as before.

### 9.1 Cross-cutting (architecture set)

- ▶ **camelCase wire-field epidemic.** Every architecture spine, the
  conceptual model, system-context, deployment, and dependency-inventory carry
  `clusterId`, `sourceId`, `requestId`, `entityType`, `continuationCursor`,
  `confidenceScore`, `lastNotificationDate`, `lastUpdateDate`, etc. Apply the
  Section 2 snake_case sweep (`cluster_id`, `source_id`, …). Mechanical, but
  hundreds of tokens — do as a dedicated sweep with grep gate.
- ❓→▶ **Four-way contract-field divergence (SEMANTIC, not cosmetic).** The
  same two ERS→ERE optional fields appear as `recommendedPlacement` /
  `recommendedExclusions` (Spine A, D), `preferredPlacement` /
  `rejectionConstraints` (Spine B diagram), and `proposedClusterId` /
  `excludedClusterId` (Dependency Inventory); plus `sourceId` vs `originId`
  for the delta key. These must be **reconciled against the ERS–ERE contract**,
  not paraphrased. Needs author/contract confirmation of the canonical names
  before editing. Same class: ADR action-type vocabulary disagreements
  (`resolveConsideringRecommendation` vs `reResolveConsideringRecommendation`,
  `reResolveWithExclusions` vs `reResolveConsideringExclusions`).
- ▶ **Fragment-vs-standalone confusion.** `behaviour-spines.adoc`,
  `deployment-architecture.adoc` (`== 11`), `dependecy-inventory.adoc`
  (`== 10`), conceptual-model (`== 9`), system-context (`== 6`) start at `==`
  with hard-coded section numbers, yet are linked standalone from `index.adoc`
  and `nav.adoc` → render with no `=` doctitle. Decide per page: give it a
  real `=` doctitle and drop the hard-coded number, or make it include-only
  and remove it from nav/index.
- ▶ **Rename `dependecy-inventory.adoc` → `dependency-inventory.adoc`**;
  update `nav.adoc:16` and `ERSArchitecture/index.adoc:36`. No `include::`s it;
  `git mv` + 2 xref edits + build check.
- ▶ `xref:ROOT:` prefix in `ERSArchitecture/index.adoc` and
  `AnnexeC-ADRs/index.adoc` (13 links) → strip per Section 2.
- ▶ **Diagram hygiene.** Spines correctly use `sequenceDiagram` (keep), but
  width/align is set only on Spine A — standardise `[mermaid, align=center,
  width=100%]`; mixed `<br>`/`<br/>`; dead commented-out `%% note … \n` blocks
  shipped in source — render as real `Note over` or delete. Images
  (`L1.png`, `L2 - Application Cooperation Overview.png`, `Technology
  deployment.png`) have spaces in filenames, no alt text, no width, and
  `image::ROOT:` prefix → hyphenated slugs + alt text + drop `ROOT:` (note:
  `ROOT:` on `image::` is the resource-component prefix, not the redundant
  xref family prefix — verify resolution after change; the L2 contract image
  in `ERS-ERE-Contract/introduction.adoc` was deliberately left for this
  reason and should be revisited here).
- ▶ **`+` hard-break abuse** pervasive across every architecture and ADR page
  — convert to blank-line paragraphs (Section 7).
- ▶ **Register bleed / narration.** `spine-0-e2e.adoc` is the worst: "Think of
  it as a map…", "That is not a bug.", curly-quoted "perfectly". Architecture
  is explanation/reference — declarative, no figure-narration ("This diagram
  presents…"), no rhetorical reassurance.
- ▶ **Duplicated invariants.** "Completed client responses are not
  retroactively changed", "no Canonical Entity Registry exists in ERS", the
  idempotency/at-least-once paragraph, and the delta rule
  `last_notification_date < last_update_date` are each restated 3–5× across
  spines, conceptual-model, system-context, decisions. Extract to a partial
  with one home + xref (Section 0.5 / Section 3 pattern).
- ▶ **UC citation format drift across architecture.** `UCB11`, `UC-B-1.1`,
  `UC1.3`, `UC-W1` all used. Worse — **hard identifier contradiction**:
  `core-capabilities.adoc` labels "UC-W3 = refreshBulk" while Annexe B defines
  UC-W3 = *Integrate ERE Reclustering Results* and refreshBulk = UC-B1.3. This
  misroutes any reader following a UC link. Pick one citation vocabulary
  (Annexe B doctitles), make architecture references real `xref`s to the
  `[#uc-…]` anchors already added, and reconcile the W3 contradiction. ❓ which
  numbering is correct — needs author ruling (likely Annexe B is canonical).
- ▶ Phantom "Spine E": `spine-0-e2e.adoc` says "spines (A–E)" but only A–D
  exist. Fix the range or supply E.
- ▶ Conceptual model (`9.2`) deliberately renames contract fields
  (`originId`/`lastNotificationDate` → `sourceId`/`lastSnapshot`) — a
  self-inflicted drift; reconcile to the contract names, do not invent a
  third vocabulary.

### 9.2 Per-page architecture highlights

- **index.adoc**: `xref:ROOT:` ×3; otherwise a thin TOC — make headings/anchors
  consistent, add `options="header"`.
- **introduction / scope / business-context**: heavy negation-led openings and
  triple-restated authority/no-registry model — apply Section 1, dedupe
  against ERSys Overview and decisions.
- **actors**: align actor names to glossary preferred terms (same defect as
  Use Cases); cross-link the glossary anchors.
- **decisions.adoc**: see 9.3 — it is the architecture-side baseline; must
  `xref` the ADRs rather than re-assert them; embeds bold inside `===`
  headings (renders literally) and `+` abuse.
- **core-capabilities.adoc**: the only inbound link to the ADR annex (one
  malformed sentence); fix and formalise; the UC-W3 numbering contradiction
  lives here.
- **conceptual-model / system-context**: bold-inline pseudo-headings instead
  of `===` (not anchorable); figure-narration; `ers:` prefix notation used
  nowhere else (define or drop).
- **deployment-architecture**: cleanest page — use as the structural template;
  still needs the image + camelCase fixes.
- **dependecy-inventory**: rename (above); typo "canonica Id"; tables lack
  `[cols=…,options="header"]`; §10.2 re-narrates the tables — trim.

### 9.3 ADR set (`AnnexeC-ADRs/`)

- ❓ **DECISION NEEDED — the nav orphan.** All 15 ADR files are unreachable
  from `nav.adoc`; `decisions.adoc` promises "Annexe C" 3× with no link. This
  was previously parked (Section 6/8.4) but the author flagged the missing
  link, so it is now in scope. Recommended structure (needs author OK on
  placement): keep `decisions.adoc` as the architecture **baseline** (5
  principles + 7 invariants); it is NOT a duplicate of the ADRs — it is the
  compressed summary of them. Add an Annexe C nav block (index-as-hub, like
  Annexe A/B — do not enumerate 13 ADRs in the left nav), and wire
  bidirectional links: `decisions.adoc`'s three bare "Annexe C" mentions →
  `xref:AnnexeC-ADRs/index.adoc`; ADR `introduction.adoc` → back-xref to
  `xref:ERSArchitecture/decisions.adoc`. Open question: nest Annexe C under
  Architecture (next to Decisions, more discoverable) or as a top-level
  Annexe beside the Glossary?
- ▶ **No `Status` field in any of the 13 ADRs.** Add `Status: Accepted`
  (admonition or labelled field under the doctitle) — the most conspicuous
  ADR omission.
- ▶ **No `=` doctitle** on the 13 ADRs or `introduction.adoc` (all start at
  `==`); every inner section is one level too deep. Add doctitles, re-level.
- ▶ **ID/title mismatch.** `index.adoc` advertises "ADR-A1…G2"; files title
  themselves "ADR-A1N…" (unexplained trailing `N`). Pick one (recommend
  dropping the cryptic `N`; if it means "Normative" use the Section 7
  `(Normative)` suffix) and apply identically in index, doctitle, and every
  cross-ADR reference.
- ▶ Inter-ADR references are bare prose codes ("defined in ADR-C2N") → real
  `xref`s with consistent codes + `[#adr-…]` anchors per ADR.
- ▶ `index.adoc`: `xref:ROOT:` ×13, `[cols="2,4"]` missing `options="header"`.
- ▶ `introduction.adoc`: lead-with-negative; `+` abuse; **malformed bold list**
  `* A-Series - Identity: *Defines…` (unmatched `*` across all 7 series
  bullets — renders broken); `clusterId` drift.
- ▶ Decision-section formatting inconsistent (ordered lists vs bold-numbered
  pseudo-headings vs `.`-with-loose-paragraphs across files) — standardise.
- ▶ **`adrc2.adoc` build warning** (`list item index: expected 1, got 5`,
  ~line 58): items 1–4 are bold pseudo-headings `*1. …*` (number inside the
  bold → not a list); item 5 `5. *Error Handling*` has the number outside →
  parsed as a single-item ordered list starting at 5. **Fix:** convert all
  five to a proper auto-numbered `.` ordered list with bold run-in titles and
  nested `..` sub-items (matches adra1/adrd1/adre1). Auto-numbering removes
  the hard-coded index entirely. Same malformed-bold pattern recurs in
  `introduction.adoc`, `adrg1`, `adrg2` — fix together.
- ▶ Typos: `adra3` "nont reused"; `adrc2` "esolve"; "discreetly/discretely"
  (means "autonomously") in `adrc2`/`adre1`; curly quotes in `adrb1`/`adrf1`.
- ▶ `adrf1` Decision sub-items are loose paragraphs under `.` items (need `+`
  continuation or nested list) — note this is the *legitimate* use of `+`,
  distinct from the paragraph-separator abuse.

### 9.4 Use-Case content (post-format-normalisation)

Structural normalisation already shipped; these are **content** defects:

- ❓ **W3 ↔ B1.2 relationship is undefined and the catalogue contradicts the
  architecture.** UC-W3 (reclustering, Primary Actor ERE) and UC-B1.2 (ERE
  outcome integration, Primary Actor ERSys) describe overlapping behaviour
  with opposite actor choices and no stated parent/child link; the spines
  assert W3↔B1.3 parentage while the catalogue treats B1.3 as refining no
  White UC. Author must rule the intended White/Blue hierarchy; then state it.
- ▶ **White↔Blue dedup not actually achieved.** `ucb11` (and `ucb21`/`ucb22`)
  open with "the shared contract … is not restated here" then restate ~60% of
  the White UC's Success/Minimal Guarantees and scenarios near-verbatim.
  Either reduce Blue to genuine deltas + `xref` White, or drop the false
  promise. The engine-authority boilerplate copy-pasted across W1/B1.1/B1.2/
  W2/B2.1/B2.2 already shows drift ("canonical entity lineage" vs "canonical
  lineage") → extract a shared partial (Section 0.5).
- ▶ **Correlation-tuple name drift inside the catalogue**: "origin
  identifier / request identifier / entity type", `(originId, requestId,
  entityType)`, `(sourceId, requestId, entityType)` across W1/B1.1/B1.3.
  Apply the Section 2 snake_case canonical set (`source_id`, `request_id`,
  `entity_type`); reconcile `originId` vs `sourceId` with 9.1.
- ▶ `ucb13` introduces `canonicalId` as a returned wire field — forbidden
  invented variant; use `cluster_id` / "cluster identifier".
- ▶ **Delta-semantics inconsistency (content):** `ucb22` Extension 3a says an
  ERE confirmation of the same cluster produces *no* delta; `ucw2`/`ucb12`/
  `ucb13` assert "all Cluster Assignment changes update delta tracking" and
  never state "confirmation ≠ change". Reconcile across W2/B1.2/B1.3/B2.2 —
  it directly governs the `last_update_date` rule. ❓ confirm the intended
  rule.
- ▶ `ucw2` Primary Actor is "Curator" but the body says "User" throughout —
  the White parent was not actor-aligned (its Blue children were). Fix.
- ▶ Missing Trigger / Main Success Scenario in `ucw1`, `ucw2`, `ucw3`,
  `ucw4`, `ucw5`: guarantees with no flow they qualify. Add minimal scenarios
  (or xref the Blue child that holds them) so postconditions are grounded.
- ▶ `ucw1` Success Guarantee conflates at-response vs eventual-consistency
  state for the provisional path — split the guarantee.
- ▶ Idempotency-conflict rule originates in `ucb11` (Blue) but is absent from
  `ucw1` (White contract) — promote the rule to the White UC.
- ❓ **`ucw5` TODO + actor naming.** `// TODO:` "Admin" undefined in glossary;
  index says "Administrator", page says "Admin"/"Admins". Add the term to the
  glossary (preferred — it is a normative Primary Actor) and reconcile
  index/doctitle/actor to one spelling. (Ties to Section 5.10 missing-terms.)
- ▶ Decide the convention for inline author-provenance `//` notes
  (`ucb21:9`): keep consistently (then add the equivalent to `ucw2`) or strip
  all. Currently applied unevenly.
- ▶ Realise the traceability payoff: architecture spines cite UCs as bare
  prose in a non-matching format (`UC-B-1.1` vs `UC-B1.1`); convert to real
  `xref`s to the `[#uc-…]` anchors so the anchors stop being dead weight.

### 9.5 Decisions (✅ all resolved 2026-05-15)

1. **Optional ERS→ERE field names** = **`proposed_cluster_ids`** /
   **`excluded_cluster_ids`** — the canonical names in
   `ERS-ERE-Contract/interface.adoc`. Every architecture spine / dependency-
   inventory / UC mention is reconciled to these, and those pages **refer to
   the ERS–ERE contract** rather than restating field semantics. The
   divergent invented names (`recommendedPlacement`, `preferredPlacement`,
   `rejectionConstraints`, `recommendedExclusions`, `proposedClusterId`,
   `excludedClusterId`) are replaced.
2. **UC numbering — architecture/spines are the source of truth.** Canonical
   White set: **UC-W1** Resolve Entity Mention · **UC-W2** Recommend
   Resolution Update (Curation) · **UC-W3** Synchronise Resolution Updates
   (refreshBulk; this *includes* reflecting engine reclustering outcomes —
   refreshBulk is the reconciliation mechanism) · **UC-W4** Consult Resolution
   Statistics. Annexe B's "UC-W3 = Integrate ERE Reclustering Results" is the
   **outdated framing** → realign UC-W3 to the synchronise/refreshBulk
   reconciliation capability; `ucb13` (bulk lookup / refreshBulk) is the Blue
   realisation of UC-W3; `ucb12` (integrate ERE outcomes) stays as the
   engine-outcome integration realisation under the async path. Align titles,
   index, and the spine UC citations; introduce **no new guarantees** — this
   is relabel/reorganise/xref only. `ucw5` (Manage Curator Access) has no
   architecture White equivalent and stays as an Annexe-B-only UC.
3. **ADR nav** = add the ADR index as the **last item, nested in the
   Architecture subsection** (last `***` after Deployment Architecture),
   index-as-hub (do not enumerate 13 ADRs). Wire bidirectional links
   (`decisions.adoc` ↔ ADR `index.adoc`).
4. **Keep the `N` suffix** on ADR ids. Reconcile by making
   `AnnexeC-ADRs/index.adoc` use the `ADR-A1N…ADR-G2N` form to match the file
   doctitles (do not strip `N` from the files).
5. **Delta-on-confirmation rule — no semantic decision.** Do **not** invent or
   change the rule. Only align wording between the UCs and the spine to the
   currently-asserted behaviour; leave any genuine ambiguity as-is (no
   fabrication, per Section 0.6).
6. **"Admin" actor** — keep "Admin", make it consistent across `ucw5`,
   `index.adoc`, doctitle, and body; remove the `// TODO:`. **Do not** add it
   to the glossary.

