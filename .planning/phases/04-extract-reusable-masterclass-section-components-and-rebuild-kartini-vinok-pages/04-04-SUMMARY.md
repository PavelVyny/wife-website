---
phase: 04-extract-reusable-masterclass-section-components-and-rebuild-kartini-vinok-pages
plan: 04
subsystem: ui
tags: [astro, components, deduplication, vinok]
dependency_graph:
  requires: [04-01, 04-02]
  provides: [vinok-page-componentized]
  affects: [src/pages/vinok-zi-stabilizovanih-roslin.astro]
tech_stack:
  added: []
  patterns: [shared-component-composition]
key_files:
  modified:
    - src/pages/vinok-zi-stabilizovanih-roslin.astro
decisions:
  - Used stacked layout for CurriculumSection with bullets arrays (vinok has 3 lessons with bullet lists, not descriptions)
  - Kept curriculum-timeline-k as page-specific CSS since timeline bottom offset differs per page
  - Mapped existing hero decor elements to DecorElement interface with tablet-down visibility
  - bleedElement used for the bottom moss ball that bleeds below hero section
metrics:
  duration: ~5m
  completed: 2026-04-05
---

# Phase 04 Plan 04: Rebuild Vinok Page with Shared Components Summary

Rebuilt vinok page from 958 inline lines to 334 lines using all shared section components extracted in Plans 01 and 02.

## What Was Done

### Task 1: Rebuild vinok page to use all shared components

Rewrote `src/pages/vinok-zi-stabilizovanih-roslin.astro` to use every shared component:

- **MasterclassHero** -- hero section with 5 decor elements + bleed moss ball
- **TargetAudienceSection** -- 4 audience cards with vinok-specific descriptions
- **EducationalBlock** -- 5 hotspots on wreath product image + 5 benefits
- **WhatsIncludedSection** -- 6 included items + 2 product images
- **PricingCta** -- 450 grn / 1500 grn, course="wreath"
- **LearningOutcomes** -- 5 outcome items + 2 interior images + decor
- **InstructorSection** -- shared, no props
- **ValueProps** -- 3 value cards (shared content)
- **CurriculumSection** -- stacked layout, 3 lessons with bullet arrays
- **FaqSection** -- 10 FAQ items

All content arrays populated with verbatim Ukrainian text from the original page.

## Deviations from Plan

None -- plan executed exactly as written.

## Verification

- `npm run build` passes with zero errors
- All 4 pages (index, florarium, kartini, vinok) build successfully
- All shared component imports verified (MasterclassHero, EducationalBlock, FaqSection, etc.)
- Zero `hotspot-btn` references in page (moved to component)
- Zero `decor-anim` references in page (moved to shared CSS)
- `course="wreath"` present
- `bullets` arrays present in curriculum lessons
- Line count: 334 (down from 958, 65% reduction)

## Commits

| Task | Commit | Description |
|------|--------|-------------|
| 1 | cb399bf | feat(04-04): rebuild vinok page using all shared components |

## Known Stubs

None -- all data arrays use real content from the existing vinok page.
