# Project Memory — Entity Resolution Docs

## Project Overview

- Documentation and specification repository for Entity Resolution project.
- Uses Antora (AsciiDoc) for technical documentation.
- Serves as planning hub for AI-assisted development.
- Branch model: `develop` is the main branch.

## AI Coding Setup

- Five agents: epic-planner (opus), gherkin-writer (sonnet), implementer (sonnet), code-reviewer (opus), documenter (haiku).
- Skills at project level: stream-coding, clarity-gate, gitnexus (6 sub-skills).
- Methodology: stream-coding (documentation-first), Cosmic Python (layered architecture).
- Memory: dual approach — auto-memory (this file) + epic/task memory under epics/.
- Docs: `docs/ai-coding/` contains runbook, setup guide, DoD quality gates, and review.

## Active Epics

(None yet — update this section as epics are created.)

## Codebase Patterns

- Agent files live in `.claude/agents/` with YAML frontmatter + markdown system prompt.
- Skills live in `.claude/skills/<name>/SKILL.md`.
- CLAUDE.md is the master entry point; kept under 200 lines.
- GitNexus rules are inline in CLAUDE.md (within `<!-- gitnexus:start/end -->` markers).

## Key Decisions

- 2026-03-11: Established AI-assisted coding setup with 5 agents, stream-coding methodology.
- 2026-03-11: Stream-coding Phases 1-2 owned by epic-planner, Phases 3-4 by implementer.
- 2026-03-11: Clarity Gate — full 13-item for specs, lightweight 5-item for documentation.
- 2026-03-11: Skills copied to project level for portability across repos.
- 2026-03-11: DoD quality gates document created with 34-item coverage matrix (93/100 score).
