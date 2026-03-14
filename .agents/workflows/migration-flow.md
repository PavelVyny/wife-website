---
description: Workflow for migrating a single page from WordPress to Astro.
---

# Workflow: Page Migration

1. **Information Gathering**
    - Open the original WordPress page.
    - Copy the `Title`, `Meta Description`, and identify the `<h1>`.
    - Download all images used on the page.

2. **Component Mapping**
    - Decide if parts of the page should be extracted into reusable components (e.g., `Hero`, `CTA`, `Feedback`).
    - Create these components in `src/components/` if they don't exist.

3. **Content Transfer**
    - Copy text content carefully.
    - Replace WordPress shortcodes/plugins with Tailwind-styled equivalents.
    - Insert links to external payment services.

4. **Optimization**
    - Convert all images to WebP and place them in `src/assets/`.
    - Use the `astro:assets` image component for proper optimization.

5. **Verification**
    - Run `pnpm dev` and check the page locally.
    - Verify all links work.
    - Check Lighthouse score for this specific page.
