---
phase: "02"
plan: "02"
subsystem: main-page
tags: [responsive, desktop, about, stats, faq, spacing]
dependency_graph:
  requires: [02-01]
  provides: [about-desktop, stats-desktop, faq-2col-desktop, consistent-page-spacing]
  affects: [index.astro, AboutSection, StatsSection, FaqAccordion, FaqSection]
tech_stack:
  added: []
  patterns: [css-grid-2col, mobile-hidden-lg-shown, responsive-typography-scale]
key_files:
  created: []
  modified:
    - src/components/AboutSection.astro
    - src/components/StatsSection.astro
    - src/components/FaqAccordion.astro
    - src/components/FaqSection.astro
    - src/pages/index.astro
decisions:
  - Split FaqAccordion into mobile (flex-col) and desktop (2-col grid) rendering trees for clean layout
  - Used lg:hidden / hidden lg:grid pattern to avoid CSS columns (which breaks accordion height transitions)
  - Removed overflow-hidden from courses section to prevent animation clipping
metrics:
  duration: "~6 minutes"
  completed: "2026-03-17"
  tasks: 4
  files: 5
---

# Phase 02 Plan 02: About, Stats, FAQ, and Footer Desktop Responsiveness Summary

**One-liner:** Desktop polish for remaining main page sections — lg typography scaling, FAQ 2-column grid, consistent section spacing.

## What Was Built

Four targeted responsive improvements to the main page sections that were untouched by plan 02-01.

### Task 1: AboutSection desktop layout (commit: 6482f85)

- Removed double padding on bio text column (outer div had `px-[24px]` and inner div also had `px-[24px]` — inner was removed)
- Increased column gap to `lg:gap-16` for better visual separation at large screens
- Added `lg:` typography scale: heading grows to `text-[28px]`, body text to `text-[18px] leading-[28px]`
- Added `lg:pt-[36px]` on bio column for better vertical alignment with photo
- Improved background plant image sizing at lg: `background-size: min(45%, 720px)` at 1024px+

### Task 2: StatsSection desktop polish (commit: eff7cd8)

- Added `md:pb-[32px] lg:pb-[40px]` section bottom padding for breathing room
- Increased grid gap to `lg:gap-[24px]` at large screens
- Stat number font scales: `md:text-[44px]` → `lg:text-[52px]` → `xl:text-[56px]`
- Label text scales: `lg:text-[21px]` → `xl:text-[23px]`

### Task 3: FaqAccordion 2-column desktop layout (commit: d58bb64)

Added a 2-column layout for the FAQ accordion at `lg+` breakpoints:
- Mobile single-column view preserved with `lg:hidden` wrapper
- Desktop 2-column grid with `hidden lg:grid lg:grid-cols-2 gap-x-[24px] items-start`
- Items 1-5 (first half) in left column, items 6-10 (second half) in right column — top-to-bottom reading order per column
- JS accordion "close all others" scoped per `.faq-accordion` container so desktop and mobile trees don't interfere

### Task 4: Page-level spacing fixes (commit: 7f165a9)

- Removed `overflow-hidden` from courses section — it was clipping card slide-in animations from left
- Added `pb-[20px] md:pb-[30px] lg:pb-[40px]` to courses section (previously had no bottom padding)
- Added `md:pb-[40px] lg:pb-[56px]` to FaqSection for better vertical rhythm before footer

## Deviations from Plan

None — plan executed exactly as written.

## Verification

- Build passes: `pnpm build` — 1 page built, no errors, no TypeScript warnings
- All 4 tasks committed individually with descriptive messages

## Self-Check

- [x] `src/components/AboutSection.astro` modified
- [x] `src/components/StatsSection.astro` modified
- [x] `src/components/FaqAccordion.astro` modified
- [x] `src/components/FaqSection.astro` modified
- [x] `src/pages/index.astro` modified
- [x] Build passes without errors
