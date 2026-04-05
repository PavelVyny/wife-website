---
phase: 4
slug: extract-reusable-masterclass-section-components-and-rebuild-kartini-vinok-pages
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-04-05
---

# Phase 4 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Astro build (static site — no test framework) |
| **Config file** | astro.config.mjs |
| **Quick run command** | `npm run build` |
| **Full suite command** | `npm run build && echo "BUILD OK"` |
| **Estimated runtime** | ~3 seconds |

---

## Sampling Rate

- **After every task commit:** Run `npm run build`
- **After every plan wave:** Run `npm run build` + visual check on dev server
- **Before `/gsd:verify-work`:** Full build must pass, all 3 pages render identically
- **Max feedback latency:** 5 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 04-01-01 | 01 | 1 | CSS consolidation | build | `npm run build` | ✅ | ⬜ pending |
| 04-02-01 | 02 | 1 | Component extraction | build | `npm run build` | ✅ | ⬜ pending |
| 04-03-01 | 03 | 2 | Page rebuild | build + visual | `npm run build` | ✅ | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements — Astro build validates all pages compile.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Visual parity across 3 pages | Pixel-perfect layout | CSS visual comparison cannot be automated | Compare florarium vs kartini vs vinok at 375px, 768px, 1024px |
| Animation behavior | Identical animations | Runtime JS/CSS animations | Check decor-anim, hero-decor-slide, reveal on all pages |
| Responsive breakpoints | Layout shifts at breakpoints | Viewport-dependent rendering | Resize from 375→1440px on all 3 pages |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 5s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
