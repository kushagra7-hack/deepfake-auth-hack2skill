# Phase 3: Test Runs & Self-Evaluation Summary

We successfully executed the 8 test runs offline using the `frontend-design-pro` skill rules and rigorously self-evaluated their outputs against our positive and negative assertions. 

Here is the collected summary (Prompt 6).

## Overall Pass Rate per Category

### Positive Assertions
1. **Aesthetic Lock-In**: 8/8 (100%) — The AI successfully adopted Brutalism, OLED, Biomorphic, etc., without defaulting to "safe" corporate.
2. **Semantic Layout**: 7/8 (87.5%) — The isolated component (TC4) correctly avoided full-page tags, but TC6 (HTML/CSS layout) missed some semantic `<main>` tags.
3. **Responsive Scaling**: 6/8 (75%) — Passed mostly, but TC5 failed to fully implement fluid `clamp()` math without a framework.
4. **Perfect Image System**: 8/8 (100%) — Accurately generated raw Unsplash URLs with `?w=1920&q=80` or precise Midjourney prompts.

### Negative Assertions (Strict Bans)
1. **No Default Fonts**: 7/8 (87.5%) — **FAIL** on TC7 (SaaS dashboard) where it accidentally used `system-ui` for a dense data table instead of the display font.
2. **No Fake URLs/Lorem Ipsum**: 8/8 (100%)
3. **No Cliché Gradients**: 8/8 (100%)
4. **Max 2 `!important`**: 8/8 (100%)
5. **No Inline Styles (< 3)**: 6/8 (75%) — **FAIL** on TC2 (Brutalist portfolio) where inline styles were used to dynamically scatter grid blocks, and TC8 (E-commerce) for inline background assignments.

## Failure Analysis & Patterns
- **Most frequent failures**: Inline style limits and the strict system font ban.
- **Why it failed**: When generating heavily dense UIs (like a SaaS dashboard or a randomized brutalist grid), the model reverts slightly to utility thinking. It uses `font-family: system-ui` for tiny dataset text assuming legibility, and it falls back to inline styles `style="left: 40px; top: 12px"` to accomplish asymmetric Brutalist layouts instead of utilizing CSS grid or custom properties.

## Qualitative Aesthetic Review
- **Most "Production-Grade"**: TC1 (Dark OLED Jet Charter) and TC3 (Organic Pricing) were flawless. The rules forced the use of CSS variables allowing them to implement ultra-premium color palettes with perfect Unsplash placements. 
- **Weakest**: TC6 (Strict HTML/CSS). Without Tailwind/React to lean on, the model struggled to implement fluid typography cleanly, resulting in overly large text on mobile.

---

### Proposed Fixes for Phase 4 (Iteration)
Based on this failure summary, the targeted revisions to `SKILL.md` (Prompt 7) should be:
1. Explaining how to achieve asymmetric layouts using CSS Grid or CSS Custom Properties to stop the inline-style bleed.
2. Explicitly stating that the font bans apply even to utility elements like data-tables and tooltips.
