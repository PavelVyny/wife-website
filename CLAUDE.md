# Floralab Education — Masterclass Pages Pixel-Perfect Rewrite

## Environment Pre-checks

Before starting any task that requires Chrome DevTools MCP, first run:
```bash
rm -f ~/.config/google-chrome/SingletonLock ~/.config/google-chrome/SingletonCookie ~/.config/google-chrome/SingletonSocket
pkill -f chrome || true
```
Kill any orphaned Chrome processes. If bash is broken due to Cygwin DLL issues, restart the terminal before proceeding.

### Fallback Strategy

When bash or Chrome DevTools MCP tools fail, do NOT spend more than 2 minutes troubleshooting. Instead:
1. Report the blocker to the user
2. Ask if they can restart the terminal/browser
3. Proceed with whatever tools ARE working (e.g., WebFetch, direct file edits without visual verification)

## Pixel-Perfect Rewrite Workflow

For pixel-perfect rewrites: always capture reference screenshots FIRST, then make code changes, then capture comparison screenshots. Save reference screenshots to a known directory so they persist across sessions.

## Project
Astro 6 + Tailwind CSS 4 + TypeScript static site for floral education business.
Source of truth for design: https://floralabeducation.com.ua/

## Goal
Rewrite two masterclass pages to EXACTLY match the original WordPress site visually — pixel-perfect on desktop (1440px), tablet (768px), and mobile (375px).

## Original Pages (design reference)
- Florarium: https://floralabeducation.com.ua/stvorennya-florariumu/
- Paintings: https://floralabeducation.com.ua/kartini-zi-stabilizovanih-roslin/

## Astro Pages (what you're editing)
- `wife-website/src/pages/stvorennya-florariumu.astro`
- `wife-website/src/pages/kartini-zi-stabilizovanih-roslin.astro`

## Key Paths
- Pages: `wife-website/src/pages/`
- Components: `wife-website/src/components/`
- Layouts: `wife-website/src/layouts/`
- Optimized images (Astro Image): `wife-website/src/assets/masterclass/`
- Static images: `wife-website/public/images/masterclass/`
- Decorative elements: `wife-website/public/images/masterclass/decor-*.webp`

## Design System
- Dark green: #003B1C (`bg-brand-dark`)
- Lime: #7cab06 (use this in components, NOT #8EC641 from config)
- Pink CTA: #E63380 (`bg-brand-pink`)
- Cream: #FEFDF9 (`bg-brand-cream`)
- Heading font: Tenor Sans (`font-heading`)
- Body: system sans
- Breakpoints: mobile-first → md:768px → lg:1024px
- Max container: 1280px (`max-w-[1280px] mx-auto`)

## Known Gaps to Fix (from Phase 3 Verification)
These are verified problems in the current code that MUST be fixed:

1. **Gallery sections MISSING on both pages** — Neither page has a gallery section. Original WP site has gallery of finished work on both pages. Create gallery sections with images downloaded from original site.
2. **Hero images wrong** — Both pages use `dariaPhoto` (Daria's portrait) instead of the actual hero imagery from the original site. The original has large floral/plant background images.
3. **Curriculum uses same image for ALL lessons** — Florarium page uses `florariumProduct` for all 4 lessons. Paintings page alternates between only 2 images. Original has UNIQUE images per lesson.
4. **Overall layout is too generic** — Current pages look like a template. Original has rich botanical decorations, specific backgrounds, and distinctive section styling.

## Existing Components (reuse these)
- `MasterclassLayout.astro` — page wrapper with Navigation + Footer. Props: `title, description, currentPath, purchaseUrl, purchaseLabel`
- `FaqAccordion.astro` — accordion component. Props: `faqs: Array<{q: string; a: string[]}>`
- `InstructorSection.astro` — Daria's bio, hardcoded (no props)
- `ValueProps.astro` — 3-card grid. Props: `cards: Array<{title, description, icon?}>`
- `PricingCta.astro` — pricing section. Props: `price, originalPrice?, ctaText, purchaseUrl, course`
- `SectionHeader.astro` — green banner/badge. Props: `mainTitle, accentTitle`
- `BotanicalElement.astro` — decorative positioned element. Props: `src, top?, bottom?, left?, right?, size?, animationType?, delay?, opacity?`

## Anti-Patterns to AVOID
- Do NOT duplicate FaqAccordion JS logic — use the existing component
- Do NOT add new IntersectionObservers — Layout.astro already handles `.reveal` globally
- Do NOT hardcode WayForPay URLs in multiple places — define once as `PURCHASE_URL` at top of page
- Hero section elements should NOT use `.reveal` (above fold) — use for below-fold content only
- Do NOT forget `loading="eager"` on hero images (above fold)
- Every `<img>` MUST have explicit `width` and `height` attributes (prevents CLS)
- FAQ data: single answers still need array syntax: `a: ["single answer"]`

## WayForPay URLs (VERIFIED — do not change)
- Florarium: `https://secure.wayforpay.com/payment/sb10851d18b99`
- Paintings: `https://secure.wayforpay.com/payment/s9517959b27ff`
- Both open in SAME tab (no target="_blank")

## Content Data (extracted from original site)

### Florarium Page
- Hero title: "Створення флораріуму"
- 4 audience cards: Новачки, Шанувальники декору, Ті хто шукає натхнення, Любителі подарунків
- Educational block: "Флораріум — це унікальна мініатюрна багаторічна композиція з живих рослин"
- 4 curriculum lessons: 1) Підготовка та закупівля матеріалів, 2) Створення флораріуму, 3) Догляд за флораріумом, 4) Композиція в бетонному кашпо (бонус)
- Price: 0 грн (promotional) / 1500 грн (original crossed out)

### Paintings Page
- Hero title: "Картини зі стабілізованих рослин"
- 4 audience cards: same personas, different descriptions
- Educational block: "Стабілізовані рослини — це натуральні рослини, які пройшли спеціальну обробку"
- 3 curriculum parts: 1) Підготовка та теоретичний блок, 2) Огляд матеріалів та побудова композиції, 3) Створення та догляд
- Price: 0 грн (promotional) / 1500 грн (original crossed out)

## Available Images in Repo
### src/assets/masterclass/ (optimized by Astro)
- florarium-product.webp
- stabilized-art-product.webp
- stabilized-art-product-2.webp
- section-header-banner.webp

### public/images/masterclass/ (static)
- decor-branch-1.webp, decor-fern-1/2.webp, decor-flower-1/2.webp
- decor-leaf-1/2/3.webp, decor-moss-1.webp, decor-moss-ball/blur.webp
- decor-plant-1.webp, decor-pot-1/2.webp, decor-small-leaf/moss.webp
- decor-wreath-1/2.webp, wreath-product-1/2.webp
- florarium-product.webp, stabilized-art-product-1/2.webp

## Workflow for EVERY story
1. Navigate to the original WP page using Chrome DevTools MCP (`navigate_page`)
2. Take a screenshot of the specific section you're working on (`take_screenshot`)
3. Inspect the section: note exact colors, font sizes, spacing, layout, images, backgrounds
4. If needed, use `evaluate_script` to extract computed CSS values from the original
5. Implement the section in Astro to match the original EXACTLY
6. Run `cd wife-website && npm run build` to verify no errors
7. If dev server is running on localhost:4321, navigate there and take a screenshot to compare
8. Commit when the section matches

## Image Download Workflow
When you need an image from the original site:
1. Use `evaluate_script` to find image URLs: `document.querySelectorAll('img').forEach(i => console.log(i.src))`
2. Or use `take_screenshot` with `uid` to capture specific elements
3. Save downloaded images to `wife-website/public/images/masterclass/` as WebP
4. For gallery images, create subdirectories: `wife-website/public/images/stvorennya-florariumu/` and `wife-website/public/images/kartini-zi-stabilizovanih-roslin/`

## Build & Verify
```bash
cd wife-website && npm run build
```
Build must pass after every change. If build fails, fix before moving on.

Always verify builds compile before committing. Run `cd wife-website && npm run build` and confirm zero errors before any git commit.

## Dev Server
```bash
cd wife-website && npm run dev
```
Runs on http://localhost:4321

## Chrome DevTools MCP Available Tools
- `navigate_page` — go to URL
- `take_screenshot` — screenshot page or element (use `fullPage: true` for full page)
- `take_snapshot` — get page DOM/content structure
- `evaluate_script` — run JS to extract CSS values, image URLs, etc.
- `emulate` — change device emulation
- `resize_page` — resize viewport for responsive testing

## Responsive Testing Workflow
After implementing a section:
1. `resize_page` to 1440px width → screenshot → compare with original at same width
2. `resize_page` to 768px width → screenshot → compare
3. `resize_page` to 375px width → screenshot → compare

## Section Order (both pages follow this template)
1. Hero (title, subtitle, CTA, background imagery)
2. Target Audience ("Для кого цей майстер-клас" — green banner + cards)
3. Educational Block ("Що таке флораріум/стабілізовані рослини?")
4. What's Included ("Що входить у майстер-клас")
5. Curriculum ("Програма майстер-класу" — numbered lessons with unique images)
6. Gallery (finished work examples — CURRENTLY MISSING, must create)
7. Learning Outcomes ("Результати які ви отримаєте")
8. Value Props (3 cards — shared component)
9. Instructor (Daria's bio — shared component)
10. Pricing (price + Buy Now CTA — shared component)
11. FAQ (accordion — shared component with page-specific data)
