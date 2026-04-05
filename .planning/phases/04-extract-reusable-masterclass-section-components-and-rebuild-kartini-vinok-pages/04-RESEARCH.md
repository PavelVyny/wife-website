# Phase 4: Extract Reusable Masterclass Section Components and Rebuild Kartini/Vinok Pages - Research

**Researched:** 2026-04-05
**Domain:** Astro component extraction, shared props design, CSS animation portability
**Confidence:** HIGH (all findings come from direct code inspection of the live repo)

## Summary

All three masterclass pages (florarium, kartini, vinok) already exist and are built. The florarium page (`stvorennya-florariumu.astro`) is the fully-polished reference. The kartini and vinok pages are also substantially complete — they have all their sections, all their images, all their content, and their own `<style is:global>` animation blocks.

The actual situation is **more nuanced** than "extract and rebuild." Kartini and vinok pages are NOT broken templates — they are working pages that diverged from florarium in layout structure and CSS class naming. The real work is:

1. Identifying which sections are truly worth extracting as shared Astro components (vs. sections where per-page differences make extraction complexity exceed the benefit)
2. Ensuring all three pages' CSS animations and keyframe definitions are unified (currently each page has its own `<style is:global>` block with overlapping but slightly different animation class names)
3. Verifying that kartini and vinok pages have all sections present and matching florarium's section order — some sections appear to be in different order or missing (e.g., florarium puts Curriculum after ValueProps, while kartini/vinok have Curriculum after ValueProps but FAQ handling differs)

**Primary recommendation:** Extract 4–5 high-value shared components (TargetAudienceSection, EducationalBlock, WhatsIncludedSection, LearningOutcomes, CurriculumSection) and consolidate all animation CSS into MasterclassLayout. The Hero section is too page-specific (different animation class names, different decor elements, different Daria photos) to be worth extracting — it should stay inline on each page.

## Project Constraints (from CLAUDE.md)

- Stack: Astro 6 + Tailwind CSS 4 + TypeScript, static site
- Mobile-first with Tailwind breakpoints: md:768px, lg:1024px
- Max container: `max-w-[1280px] mx-auto`
- Design colors: dark green `#003B1C`, lime `#7cab06`/`#7fac00`, pink `#E63380`/`#F3237D`, cream `#FEFDF9`
- Font: Tenor Sans (`font-heading`) for headings/buttons
- Every `<img>` MUST have explicit `width` and `height` attributes (prevents CLS)
- Do NOT add new IntersectionObservers — Layout.astro already handles `.reveal` globally
- Hero section elements must NOT use `.reveal` — use for below-fold content only
- `loading="eager"` on hero images (above fold)
- WayForPay URLs are VERIFIED — do not change
- Build must pass after every change: `cd wife-website && npm run build`
- Anti-pattern: Do NOT duplicate FaqAccordion JS logic — use existing component
- Anti-pattern: Do NOT hardcode WayForPay URLs in multiple places

## Standard Stack

### Core (already in use — do not change)
| Library | Version | Purpose |
|---------|---------|---------|
| Astro | 6.x | Static site framework, component model |
| Tailwind CSS | 4.x | Utility-first styling |
| TypeScript | latest | Props typing via interfaces |

### Astro Component Pattern
Props are typed with `interface Props` in the frontmatter `---` block. Use `Astro.props` destructuring. Slot content via `<slot />` for flexible inner content.

**Component file location:** `src/components/` (all existing components live here)

## Architecture Patterns

### Current Component Inventory

**Already shared (working, do not touch):**
- `MasterclassLayout.astro` — page wrapper (Navigation + Footer + Layout)
- `FaqAccordion.astro` — accordion, props: `faqs: Array<{q, a[]}>`
- `InstructorSection.astro` — hardcoded, no props
- `ValueProps.astro` — props: `cards: Array<{title, description, image}>`
- `PricingCta.astro` — props: `price, originalPrice?, ctaText, purchaseUrl, course, productImg1?, productImg2?, bannerImg?`
- `SectionHeader.astro` — green banner badge
- `BotanicalElement.astro` — decorative positioned element

**Currently inline on every page (candidates for extraction):**
See analysis below.

### Section-by-Section Extraction Analysis

#### 1. Hero Section — DO NOT EXTRACT as component

**Reason:** Each page has fundamentally different animation class names (`hero-decor-slide` vs `hero-decor-slide-k`), different decor image sets (florarium: cookie/succulent/plant-pot; kartini: moss-ball/bark; vinok: green-moss/cotton/branch), different Daria photos, different hero backgrounds, different title structures, and florarium's hero uses a 2-column desktop layout with absolutely positioned Daria image while kartini/vinok use a stacked layout. The variation surface is too large. Keep hero inline.

**What the planner should do:** Ensure kartini and vinok heroes have the CSS animation keyframes consolidated into MasterclassLayout (see CSS section below).

#### 2. TargetAudienceSection — EXTRACT

**Why:** All 3 pages share identical structure — title image, subtitle paragraph, 2×2 card grid with image+title+description. Only data differs (subtitle text, card descriptions, card images).

**Florarium vs kartini/vinok difference:** Florarium cards have no border (`bg-white rounded-[20px]`), kartini/vinok cards have `border border-[#E0E0E0]`. Florarium uses `lg:flex-row` while kartini/vinok use `md:flex-row`. This means the component needs a prop or the border/breakpoint difference must be standardized.

**Recommended approach:** Standardize to kartini/vinok style (with border, `md:flex-row`) when extracting, OR add a `variant` prop. Check if florarium design requires no border.

**Props interface:**
```typescript
interface Props {
  titleImage: string;           // src for title banner image
  titleImageAlt: string;
  subtitle: string;
  cards: Array<{
    image: string;
    imageAlt: string;
    title: string;
    description: string;
  }>;
  decorLeftImage?: string;      // optional desktop-only decor, herb-cluster on kartini/vinok
  decorRightImage?: string;     // decor-right-plant on all pages
}
```

#### 3. EducationalBlock ("Що таке...") — DO NOT EXTRACT as shared component

**Reason:** Florarium's version has a hexagonal hotspot image with 6 interactive hotspot buttons, a quote-bubble image, a unique benefit list (3 items), a desktop 2-col layout with heading duplicated mobile/desktop, and a floating memoji. Kartini and vinok versions have a different product image with 5 hotspots, a benefit list (5 items), and a quote banner image (full-width) at the bottom. The structures are different enough that a component would need too many conditional slots/props. Better to keep inline but verify content completeness.

**What the planner should do:** Verify kartini and vinok educational blocks are complete. Florarium's block also includes a `daria-memoji` floating element that kartini/vinok lack — decide if that's intentional.

#### 4. WhatsIncludedSection — PARTIAL EXTRACT possible

**Why:** All 3 pages share: animated lightbulb SVG, title image (`whats-included-title.webp`), checklist of items, two overlapping product images with `included-slide-left`/`included-slide-right` animations. The structure is identical.

**Differences:** Florarium has a "Бонус" badge with a curved arrow doodle pointing to the 3rd list item (pink bullet). Kartini/vinok have no bonus badge and use plain green bullets throughout. Florarium's title image is at `/images/masterclass/whats-included-title.webp`, while kartini/vinok each have their own `whats-included-title.webp`. Wait — checking: both kartini and vinok reference `/images/masterclass/whats-included-title.webp` for the same shared title. Kartini uses `/images/masterclass-kartini/whats-included-title.webp`, vinok uses `/images/masterclass-vinok/whats-included-title.webp`.

**Props interface:**
```typescript
interface Props {
  titleImage: string;
  titleImageAlt: string;
  items: string[];
  bonusItem?: string;           // if provided, renders with pink bullet + bonus badge
  productImg1: string;
  productImg1Alt: string;
  productImg2: string;
  productImg2Alt: string;
}
```

#### 5. CurriculumSection — EXTRACT with care

**Why:** All 3 pages share the zigzag timeline layout, numbered circle badges, `highlight-path` SVG underlines on lesson titles, and mobile image/desktop image toggle pattern. The structural HTML pattern repeats.

**Key differences:**
- Florarium: 4 lessons, alternating zigzag left/right (odd=image-left, even=image-right), uses `curriculum-timeline` CSS class, uses a central vertical line concept with `lg:absolute lg:left-1/2` positioned number circles
- Kartini/vinok: 3 lessons, all lessons image-LEFT (no zigzag alternation), uses `curriculum-timeline-k` CSS class, number circles are NOT absolutely positioned
- Kartini: lessons have a single paragraph description
- Vinok: lessons have sub-bullet lists inside each lesson

This is significant structural divergence. A single component would need a `variant` or `layout` prop (`zigzag` vs `stacked`).

**Recommended approach:** Extract as a component that accepts a `layout` prop (`'zigzag' | 'stacked'`) and `lessons` array. The lesson item structure needs to accommodate both a `description` string and optional `bullets` array.

**Props interface:**
```typescript
interface LessonItem {
  title: string;        // first highlighted word(s)
  titleRest: string;    // rest of title after line break
  description?: string;
  bullets?: string[];
  image: string;
  imageAlt: string;
}
interface Props {
  titleImage: string;
  titleImageAlt: string;
  lessons: LessonItem[];
  layout?: 'zigzag' | 'stacked';  // default 'stacked'
  decorImage?: string;             // optional fern decor (florarium only)
}
```

#### 6. LearningOutcomes — EXTRACT

**Why:** All 3 pages have identical structure — title image (mobile above, desktop in right column), bullet list left, two overlapping images right with `included-slide-left`/`included-slide-right`, optional decorative element overlaid on images.

**Florarium specifics:** Title image shown mobile above + desktop inside right column (two img tags, one `lg:hidden`, one `hidden lg:flex`). Bg is `#f8f8f8`. Images use `results-img-1.webp` / `results-img-2.webp`.

**Kartini specifics:** Title image above only (no desktop re-render). Has `results-decor.webp` overlay. Layout shows list LEFT + images RIGHT (same as florarium but list is first in DOM).

**Vinok specifics:** Title image above only. Has `results-decor.webp` overlay. Layout same as kartini.

**Props interface:**
```typescript
interface Props {
  titleImage: string;
  titleImageAlt?: string;
  items: string[];
  img1: string;
  img1Alt: string;
  img2: string;
  img2Alt: string;
  decorImg?: string;    // optional overlay decoration
  decorStyle?: string;  // inline style for decor positioning
}
```

#### 7. CTA Before FAQ — EXTRACT as tiny component or inline snippet

All 3 pages have a "Придбати зараз" CTA button before FAQ section. Florarium has it, kartini does NOT (kartini goes straight from curriculum to FAQ with no CTA button), vinok does NOT. This is not worth extracting — just add the CTA to kartini/vinok if it's required by design.

#### 8. FAQ Section Wrapper — DO NOT EXTRACT

The FAQ section wrapper (section tag with decorative images + FaqAccordion) differs enough per page (florarium has `decor-pot-plant` + `decor-leaf-1` desktop decorations; kartini has none; vinok has none; florarium uses shared faq-title.webp, vinok has its own `/images/masterclass-vinok/faq-title.webp`). The inner `FaqAccordion` is already a component. The wrapper is not worth extracting.

### Animation CSS Consolidation — CRITICAL FINDING

This is the most important architectural finding. Currently:

**Florarium (`stvorennya-florariumu.astro`):** Has `<style is:global>` with animation classes: `hero-decor-slide`, `hero-daria-slide`, `hero-text-fade`, `hero-zigzag-path`, `curriculum-timeline`, `included-slide-left`, `included-slide-right`, `bulb-glow`, `bulb-ray`, `decor-anim`, `decor-sway`, `hotspot-btn`, `hotspot-tooltip`, `florarium-highlight`, `highlight-path`

**Kartini (`kartini-zi-stabilizovanih-roslin.astro`):** Has its own `<style is:global>` with: `hero-decor-slide-k`, `hero-daria-slide-k`, `hero-text-fade-k`, `kartiniPinkPulse`, `kartini-cta-btn`, `curriculum-timeline-k`, `included-slide-left`, `included-slide-right`, `bulb-glow`, `bulb-ray`, `decor-anim`, `decor-sway`, `hotspot-btn`, `hotspot-tooltip`, `highlight-path`

**Vinok (`vinok-zi-stabilizovanih-roslin.astro`):** Has its own `<style is:global>` with: `stabilized-bob`, `decor-anim`, `decor-sway`, `decor-anim-mirror`, `curriculum-img`, `gallery-img`, `gallery-item`, `gallery-overlay`, `hero-decor-slide-k`, `hero-daria-slide-k`, `hero-text-fade-k`, `kartiniPinkPulse`, `kartini-cta-btn`, `included-slide-left`, `included-slide-right`, `bulb-glow`, `bulb-ray`, `hotspot-btn`, `hotspot-tooltip`, `highlight-path`

**The problem:** `included-slide-left`, `included-slide-right`, `decor-anim`, `decor-sway`, `bulb-glow`, `bulb-ray`, `hotspot-btn`, `hotspot-tooltip`, `highlight-path` are duplicated across all 3 pages. The layout file (`Layout.astro`) already handles `.reveal` globally.

**Solution:** Move all shared animation CSS (the classes used on all 3 pages) into `MasterclassLayout.astro` as a `<style is:global>` block. Page-specific classes (`hero-decor-slide` for florarium, `hero-decor-slide-k` for kartini/vinok, `curriculum-timeline` for florarium, `curriculum-timeline-k` for kartini/vinok) stay inline on their respective pages.

### Section Order Discrepancy — CRITICAL FINDING

Florarium section order:
1. Hero
2. TargetAudience
3. EducationalBlock ("Що таке флораріум")
4. WhatsIncluded
5. PricingCta
6. LearningOutcomes
7. InstructorSection
8. ValueProps
9. CurriculumSection
10. CTA-before-FAQ
11. FAQ

Kartini section order:
1. Hero
2. TargetAudience
3. EducationalBlock ("Що таке стабілізовані рослини")
4. WhatsIncluded
5. PricingCta
6. LearningOutcomes
7. InstructorSection
8. ValueProps
9. CurriculumSection
10. FAQ (no CTA before FAQ)

Vinok section order: Same as kartini (identical order)

**Key difference:** Florarium has CurriculumSection AFTER ValueProps. Kartini and vinok also have CurriculumSection after ValueProps. The orders match. The only difference is florarium has a CTA button before FAQ, kartini and vinok do not.

**CLAUDE.md Section Order (canonical):**
1. Hero, 2. Target Audience, 3. Educational Block, 4. What's Included, 5. Curriculum, 6. Gallery (MISSING on all pages), 7. Learning Outcomes, 8. Value Props, 9. Instructor, 10. Pricing, 11. FAQ

The CLAUDE.md order differs from actual implementation order. The actual pages put Pricing BEFORE Learning Outcomes and put Curriculum AFTER Value Props/Instructor. The planner must decide: follow CLAUDE.md canonical order or preserve existing page order? Given that all 3 pages use the same non-canonical order, preserve it.

**Gallery sections are MISSING on all 3 pages.** CLAUDE.md flags this as a Known Gap. Phase 4 objective does not explicitly require adding gallery sections — clarify in plan.

### PricingCta Component — Type Mismatch Found

`PricingCta.astro` has `course: 'florarium' | 'paintings'` in its Props interface, but `vinok-zi-stabilizovanih-roslin.astro` passes `course="wreath"`. This will cause a TypeScript error on build if strict type checking is on. The interface needs to be updated to `'florarium' | 'paintings' | 'wreath'`.

**Verify:** `npm run build` may already pass (Astro may not strictly enforce this) but it is a code quality issue that should be fixed.

## Don't Hand-Roll

| Problem | Use Instead |
|---------|-------------|
| Scroll reveal animations | Existing `.reveal` class — Layout.astro IntersectionObserver handles it globally |
| Accordion behavior | Existing `FaqAccordion.astro` |
| Page wrapper with nav/footer | Existing `MasterclassLayout.astro` |
| Custom scroll position tracking | href="#pricing" anchor links |

## Common Pitfalls

### Pitfall 1: Breaking animation on component extraction
**What goes wrong:** When a section with `is:global` CSS is moved into a component, the CSS scoping behavior changes. In Astro, `<style>` in components is scoped by default. `<style is:global>` in components applies globally.
**How to avoid:** Keep animation classes in the MasterclassLayout `<style is:global>` block, not inside extracted components. Components themselves should only use the class names — not define them.

### Pitfall 2: Forgetting img width/height on new components
**What goes wrong:** CLS (Cumulative Layout Shift) — browser doesn't know image dimensions before load.
**Prevention:** Every `<img>` tag in a component MUST have explicit `width` and `height` attributes. This is a CLAUDE.md hard requirement.

### Pitfall 3: Hero section using .reveal class
**What goes wrong:** Hero content won't animate in — it appears only after IntersectionObserver triggers, but hero is above fold.
**Prevention:** Hero elements use `hero-text-fade` / `hero-decor-slide` keyframes only. Below-fold sections use `.reveal`.

### Pitfall 4: Astro component props TypeScript errors blocking build
**What goes wrong:** Passing a prop value not in the interface union type causes TypeScript error, build fails.
**Prevention:** Update `PricingCta.astro` course prop union type to include `'wreath'`. Run `npm run build` after every change.

### Pitfall 5: Duplicate CSS causing specificity fights
**What goes wrong:** Same animation class defined in two `<style is:global>` blocks (e.g., `decor-anim` in both kartini and vinok page files AND in MasterclassLayout) causes unpredictable behavior.
**Prevention:** Remove per-page `<style is:global>` definitions of shared classes as they are added to MasterclassLayout. Do not leave duplicates.

### Pitfall 6: curriculum-timeline vs curriculum-timeline-k
**What goes wrong:** Florarium uses `.curriculum-timeline` for its CSS (center line styling), kartini/vinok use `.curriculum-timeline-k`. If CurriculumSection component uses the same class name for both, layout will be wrong.
**Prevention:** The CurriculumSection component should conditionally apply different timeline class based on `layout` prop, OR use inline styles instead of class-based timeline lines.

## Code Examples

### Astro Component Props Pattern (verified from existing components)
```typescript
// src/components/TargetAudienceSection.astro
---
interface Props {
  titleImage: string;
  titleImageAlt: string;
  subtitle: string;
  cards: Array<{
    image: string;
    imageAlt: string;
    title: string;
    description: string;
  }>;
  decorLeftImage?: string;
  decorRightImage?: string;
}
const { titleImage, titleImageAlt, subtitle, cards, decorLeftImage, decorRightImage } = Astro.props;
---
```

### Moving CSS to MasterclassLayout Pattern
```astro
// src/layouts/MasterclassLayout.astro — add before </Layout>
<style is:global>
  /* Shared masterclass animations */
  .included-slide-left { ... }
  .included-slide-right { ... }
  .decor-anim { animation: decorFloat var(--dur, 7s) ease-in-out var(--del, 0s) infinite; }
  .decor-sway { animation: decorSway var(--dur, 7s) ease-in-out var(--del, 0s) infinite; }
  .bulb-glow { ... }
  .bulb-ray { ... }
  .hotspot-btn { ... }
  .hotspot-tooltip { ... }
  .highlight-path { ... }
  @keyframes decorFloat { ... }
  @keyframes decorSway { ... }
  /* etc. */
</style>
```

### Image naming conventions (all verified to exist)
- Florarium: `/images/masterclass/` — audience, curriculum-lesson-N, results-img, included
- Kartini: `/images/masterclass-kartini/` — audience, curriculum-N, results-img, included-img
- Vinok: `/images/masterclass-vinok/` — audience, curriculum-N, results-interior, included-img
- Shared: `/images/masterclass/for-who-title.webp`, `/images/masterclass/whats-included-title.webp`, `/images/masterclass/curriculum-title.webp`, `/images/masterclass/faq-title.webp`, `/images/masterclass/results-title.webp`

Note: kartini uses its own `/images/masterclass-kartini/results-title.webp`. Vinok uses its own `/images/masterclass-vinok/results-title.webp`. Only florarium uses `/images/masterclass/results-title.webp`.

## Environment Availability

Step 2.6: This phase is code/config-only changes (component extraction + CSS consolidation). No external tools or services required beyond the existing dev environment.

| Dependency | Available | Notes |
|------------|-----------|-------|
| Node.js / npm | Yes | Existing project |
| Astro build | Yes | `cd wife-website && npm run build` |
| All images | Yes | All referenced images verified present in public/ directories |

## Validation Architecture

No automated test framework detected in this project. Validation is manual:

- Per-task verification: `cd wife-website && npm run build` — must produce zero TypeScript/build errors
- Visual verification: `npm run dev` + compare at localhost:4321 at 375px, 768px, 1024px, 1440px widths
- Chrome DevTools MCP can be used for side-by-side comparison with floralabeducation.com.ua originals

## Open Questions

1. **Gallery sections** — CLAUDE.md Known Gaps lists missing gallery sections on all pages. Phase 4 goal does not mention gallery. Should the plan include adding gallery sections to kartini and vinok, or defer to a Phase 5?
   - Recommendation: Defer. Phase 4 is component extraction, not new content.

2. **Florarium section order vs CLAUDE.md canonical order** — The actual florarium page has a different section order than CLAUDE.md specifies. Should we reorder florarium as part of this phase, or leave it?
   - Recommendation: Leave florarium as-is. It is the reference ("source of truth") and has been verified pixel-perfect. Do not reorganize it.

3. **CTA before FAQ** — Florarium has this, kartini/vinok do not. Is this intentional?
   - Recommendation: Add to kartini and vinok for consistency, or confirm with client.

4. **EducationalBlock variant** — Florarium's block is significantly different (hexagonal illustration + hotspot interactions) from kartini/vinok (product photo + hotspots + quote banner). Should these remain separate inline blocks or be wrapped in any shared structure?
   - Recommendation: Keep inline. The structural difference is too large for a shared component to be worthwhile.

5. **PricingCta TypeScript union type** — `course="wreath"` is passed but interface only allows `'florarium' | 'paintings'`. Does the build currently fail?
   - Recommendation: Fix immediately as part of Wave 0 / first task.

## Sources

### Primary (HIGH confidence)
- Direct inspection of `src/pages/stvorennya-florariumu.astro` (lines 1–800)
- Direct inspection of `src/pages/kartini-zi-stabilizovanih-roslin.astro` (lines 1–650)
- Direct inspection of `src/pages/vinok-zi-stabilizovanih-roslin.astro` (lines 1–679)
- Direct inspection of `src/components/PricingCta.astro`
- Direct inspection of `src/layouts/MasterclassLayout.astro`
- Directory listing: `public/images/masterclass/`, `public/images/masterclass-kartini/`, `public/images/masterclass-vinok/`
- `CLAUDE.md` project constraints

## Metadata

**Confidence breakdown:**
- Section extraction analysis: HIGH — based on direct code comparison
- Animation CSS inventory: HIGH — read actual style blocks
- Image availability: HIGH — directory listed
- PricingCta type bug: HIGH — confirmed interface vs usage mismatch

**Research date:** 2026-04-05
**Valid until:** Stable — all findings from static file inspection, no external dependencies
