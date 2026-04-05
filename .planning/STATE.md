# GSD State

## Current Position
- Phase: 04-extract-reusable-masterclass-section-components-and-rebuild-kartini-vinok-pages
- Plan: 04 (next, if any)
- Status: phase-04-plan-03-complete

## Progress
[###############.....] 75% (3/4 plans in phase 04 complete)

## Decisions
- Used max-w-[1280px] as the consistent max-width across all components
- Mobile-first responsive approach with Tailwind breakpoints
- Split FaqAccordion into mobile/desktop rendering trees (lg:hidden / hidden lg:grid) to avoid CSS columns breaking accordion height transitions
- Removed overflow-hidden from courses section to prevent animation clipping
- Used separate WayForPay URLs per masterclass (placeholder URLs, client to update with real payment links)
- Hero uses 2-col lg grid with product image on right, matching main page card aesthetic
- Prices are placeholder values (850/950 grn) — client to confirm actual pricing
- InstructorSection uses /images/about/daria-photo.webp (no /images/instructor/ directory exists)
- All shared animation CSS consolidated into MasterclassLayout <style is:global> — single source, no duplication per page
- Components extracted verbatim from florarium page as source of truth — kartini/vinok will use same layout via props
- DecorElement visibility prop maps to responsive visibility classes (mobile-only, tablet-down, desktop-only, all)
- Both pages follow identical structure: imports, data arrays, component calls, page-specific CSS only
- Florarium keeps curriculum-timeline and florarium-float as page-specific CSS; kartini keeps curriculum-timeline-k

## Performance Metrics
| Phase | Plan | Duration | Tasks | Files |
|-------|------|----------|-------|-------|
| 02    | 01   | ~30m     | 3     | 3     |
| 02    | 02   | ~6m      | 4     | 5     |
| 03    | 02   | ~2m      | 4     | 2     |
| 03    | 03   | ~2m      | 3     | 2     |
| 04    | 01   | ~3m      | 3     | 5     |
| 04    | 03   | ~6m      | 2     | 2     |

## Last Session
- Stopped at: Completed 04-03-PLAN.md — florarium + kartini pages rebuilt with shared components
- Date: 2026-04-05
