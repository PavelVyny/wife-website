---
phase: "03"
plan: "02"
subsystem: masterclass-pages
tags: [masterclass, pages, instructor, florarium, stabilized-art]
dependency_graph:
  requires: [03-01]
  provides: [florarium-page, stabilized-art-page, instructor-image-fix]
  affects: [InstructorSection, stvorennya-florariumu, kartini-zi-stabilizovanih-roslin]
tech_stack:
  added: []
  patterns: [masterclass-layout-composition, hero-two-column, value-props-reuse]
key_files:
  created:
    - .planning/phases/03-masterclass-pages/03-02-PLAN.md
  modified:
    - src/components/InstructorSection.astro
decisions:
  - Used /images/about/daria-photo.webp as instructor photo (no /images/instructor/ directory exists)
  - Masterclass pages (florarium + stabilized art) were pre-built in 03-03 commits; this plan documents the InstructorSection fix
metrics:
  duration: "~2 minutes"
  completed: "2026-03-18"
  tasks: 4
  files: 2
---

# Phase 03 Plan 02: Masterclass Detail Pages Summary

**One-liner:** Fixed InstructorSection broken image path and verified both masterclass pages build cleanly to 3 pages.

## What Was Built

This plan's primary work was fixing a broken image reference in the InstructorSection component. The masterclass pages themselves were already in place from earlier commits (03-03).

### Task 1: InstructorSection image path fix (commit: 8a46750)

- `InstructorSection.astro` referenced `/images/instructor/daria.webp` — a directory that does not exist in the project
- Fixed to use `/images/about/daria-photo.webp` which is the correct path to Daria's portrait photo
- This was a Rule 1 auto-fix (bug: broken image reference)

### Task 2: Florarium masterclass page (pre-existing, commit: 8b19e4f)

`src/pages/stvorennya-florariumu.astro`:
- Hero section: 2-column desktop layout (text + product image in card)
- ValueProps: 3 cards (video lesson, materials list, instructor support)
- "Що ви навчитесь" (What you'll learn): 6-item 2-col grid with checkmarks
- InstructorSection (Daria's bio)
- PricingCta: 850 грн (original 1200 грн), WayForPay link

### Task 3: Stabilized plants page (pre-existing, commit: 7cee5f2)

`src/pages/kartini-zi-stabilizovanih-roslin.astro`:
- Same structure as florarium page
- Stabilized art product image with rotation effect
- 6 learning outcomes for stabilized art technique
- PricingCta: 950 грн (original 1400 грн)

### Task 4: Build verification

- `pnpm build` completed in 1.50s
- 3 pages built: index, /stvorennya-florariumu, /kartini-zi-stabilizovanih-roslin
- 0 TypeScript errors, 0 warnings

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Broken instructor image path in InstructorSection**
- **Found during:** Task 1 audit
- **Issue:** `src="/images/instructor/daria.webp"` — directory `/images/instructor/` does not exist
- **Fix:** Changed to `/images/about/daria-photo.webp`
- **Files modified:** `src/components/InstructorSection.astro`
- **Commit:** 8a46750

### Scope Note

Tasks 2 and 3 (masterclass pages) were already committed before this plan ran (commits 8b19e4f and 7cee5f2 from phase 03-03 session). This plan added the plan file for traceability and ran the build verification. The InstructorSection fix (Task 1) was the substantive new work.

## Verification

- Build passes: `pnpm build` — 3 pages built in 1.50s, no errors
- All 4 tasks complete (Task 1 committed fresh; Tasks 2-3 pre-existing; Task 4 verified)

## Self-Check

- [x] `src/components/InstructorSection.astro` — image path updated to /images/about/daria-photo.webp
- [x] `src/pages/stvorennya-florariumu.astro` — exists (pre-built)
- [x] `src/pages/kartini-zi-stabilizovanih-roslin.astro` — exists (pre-built)
- [x] `pnpm build` passes with 3 pages
- [x] Commit 8a46750 exists (InstructorSection fix)
- [x] Commit 8b19e4f exists (florarium page)
- [x] Commit 7cee5f2 exists (stabilized art page)
