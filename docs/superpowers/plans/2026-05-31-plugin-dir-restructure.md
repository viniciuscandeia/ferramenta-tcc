# Plugin Directory Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align ferramenta-tcc plugin directory with official Claude Code plugin conventions and implement D12 (core/ engine separation).

**Architecture:** Three changes — (1) rename `hooks/*.sh` → `scripts/` so hook scripts are separate from config, (2) create `core/` to collect engine files (`orchestrator.md`, `constitution.md`, `marcos/`, `workflows/`, `catalogos-seed/`, `templates/`), (3) create `references/` for external standards (`normas/`). All internal path references updated to match.

**Tech Stack:** Markdown prompt files, shell scripts, JSON manifests.

---

## File Map

### New directories
- `scripts/` — hook scripts (was `hooks/*.sh`)
- `core/` — engine logic (D12)
- `references/` — external reference material

### Files MOVED (→ new path)
| From | To |
|---|---|
| `hooks/gate_guard.sh` | `scripts/gate_guard.sh` |
| `hooks/blacklist_guard.sh` | `scripts/blacklist_guard.sh` |
| `hooks/inject_state.sh` | `scripts/inject_state.sh` |
| `hooks/load_state.sh` | `scripts/load_state.sh` |
| `hooks/lib/blacklist.txt` | `scripts/lib/blacklist.txt` |
| `orchestrator.md` | `core/orchestrator.md` |
| `constitution.md` | `core/constitution.md` |
| `marcos/` (whole dir) | `core/marcos/` |
| `workflows/` (whole dir) | `core/workflows/` |
| `catalogos-seed/` (whole dir) | `core/catalogos-seed/` |
| `templates/` (whole dir) | `core/templates/` |
| `normas/` (whole dir) | `references/normas/` |

### Files MODIFIED (path string updates)
| File | What changes |
|---|---|
| `.claude-plugin/plugin.json` | `hooks/*.sh` → `scripts/*.sh` (4 paths) |
| `scripts/blacklist_guard.sh` | `hooks/lib/blacklist.txt` → `scripts/lib/blacklist.txt` |
| `scripts/gate_guard.sh` | `hooks/lib/blacklist.txt` → `scripts/lib/blacklist.txt`; `marcos/` → `core/marcos/` in messages |
| `agents/checker.md` | `workflows/` → `core/workflows/` |
| `agents/collector.md` | `workflows/` → `core/workflows/`; `catalogos-seed/` → `core/catalogos-seed/` |
| `agents/stakeholder-identifier.md` | `workflows/` → `core/workflows/` |
| `agents/documenter.md` | `workflows/` → `core/workflows/`; `constitution.md` → `core/constitution.md` |
| `agents/modeler.md` | `workflows/` → `core/workflows/` |
| `core/orchestrator.md` | `marcos/` → `core/marcos/`; `catalogos-seed/` → `core/catalogos-seed/` |
| `core/constitution.md` | `catalogos-seed/` → `core/catalogos-seed/` |
| `core/marcos/m1.md` | `workflows/` → `core/workflows/`; `orchestrator.md` → `core/orchestrator.md` |
| `core/marcos/m2.md` | `workflows/` → `core/workflows/`; `constitution.md` → `core/constitution.md` |
| `core/marcos/m3.md` | `workflows/` → `core/workflows/`; `constitution.md` → `core/constitution.md` |
| `core/workflows/m2-requisitos.md` | `catalogos-seed/` → `core/catalogos-seed/` |
| `core/workflows/m1-visao.md` | `templates/` → `core/templates/` |
| `skills/iniciar-projeto/SKILL.md` | `orchestrator.md` → `core/orchestrator.md`; `marcos/` → `core/marcos/` |
| `skills/necessidade-visao/SKILL.md` | `templates/` → `core/templates/` |
| `skills/traducao-gate/SKILL.md` | `templates/` → `core/templates/` |
| `skills/recomendacao-implicitos/SKILL.md` | `catalogos-seed/` → `core/catalogos-seed/` |
| `skills/recomendacao-dominio/SKILL.md` | `catalogos-seed/` → `core/catalogos-seed/` |
| `skills/rastreabilidade-matriz/SKILL.md` | `catalogos-seed/` → `core/catalogos-seed/` (in description) |
| `skills/analyze-cross-artifact/SKILL.md` | `catalogos-seed/` → `core/catalogos-seed/` (in description) |
| `skills/validacao-checklist-ireb/SKILL.md` | `catalogos-seed/` → `core/catalogos-seed/` (in description) |

---

## Task 1: Create new directories + move scripts

**Files:** `scripts/`, `.claude-plugin/plugin.json`

- [ ] Create `scripts/` and `scripts/lib/` dirs; move all hook scripts
- [ ] Move `hooks/lib/blacklist.txt` → `scripts/lib/`
- [ ] Delete empty `hooks/` dir
- [ ] Update `.claude-plugin/plugin.json`: 4 paths `hooks/` → `scripts/`
- [ ] Update `scripts/blacklist_guard.sh`: `hooks/lib/blacklist.txt` → `scripts/lib/blacklist.txt`
- [ ] Update `scripts/gate_guard.sh`: same + message text

## Task 2: Create core/ and move engine files

**Files:** `core/` (new), all listed above

- [ ] `mkdir -p core/`
- [ ] Move `orchestrator.md` → `core/`
- [ ] Move `constitution.md` → `core/`
- [ ] Move `marcos/` → `core/marcos/`
- [ ] Move `workflows/` → `core/workflows/`
- [ ] Move `catalogos-seed/` → `core/catalogos-seed/`
- [ ] Move `templates/` → `core/templates/`

## Task 3: Create references/ and move normas/

- [ ] `mkdir -p references/`
- [ ] Move `normas/` → `references/normas/`

## Task 4: Update all path references

- [ ] agents/*.md: `workflows/` → `core/workflows/`, `constitution.md` → `core/constitution.md`, `catalogos-seed/` → `core/catalogos-seed/`
- [ ] core/orchestrator.md: `marcos/` → `core/marcos/`, `catalogos-seed/` → `core/catalogos-seed/`
- [ ] core/constitution.md: `catalogos-seed/` → `core/catalogos-seed/`
- [ ] core/marcos/*.md: `workflows/` → `core/workflows/`, `constitution.md` → `core/constitution.md`, `orchestrator.md` → `core/orchestrator.md`
- [ ] core/workflows/*.md: `catalogos-seed/` → `core/catalogos-seed/`, `templates/` → `core/templates/`
- [ ] skills: see file map above

## Task 5: Verify final structure

- [ ] `find . -maxdepth 2 -not -path './.git/*' | sort` — confirm expected layout
- [ ] No dangling `hooks/`, `marcos/`, `workflows/`, `catalogos-seed/`, `templates/`, `normas/` at root
- [ ] `grep -r "hooks/gate_guard\|hooks/blacklist\|hooks/inject\|hooks/load" .` → zero hits (except git history)
- [ ] Smoke check: `cat core/orchestrator.md | grep "core/marcos"` → should show updated paths
