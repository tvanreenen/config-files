---
name: design-ui
description: Design and implement intentional, production-quality web interfaces. Use for visual or interaction work on web components, pages, and applications, whether greenfield, redesigned, or within an existing design system; skip purely functional changes.
---

# Design UI

Ground visual decisions in the product's purpose, audience, content, brand, accessibility requirements, technical constraints, and repository conventions.

## Work within the right design context

- For an existing product, treat its tokens, primitives, components, layouts, and interaction patterns as the design baseline unless the user requests a redesign. Reuse and compose them first; extend them at established seams rather than introducing parallel conventions.
- For greenfield work or an explicit redesign, establish a coherent visual direction through hierarchy, typography, color, spacing, composition, imagery, and motion. Prefer intentional, context-specific choices over generic generated aesthetics or novelty for its own sake.
- Determine whether a framework is the product's design authority or an implementation substrate. Preserve its contracts and use its intended composition, theming, accessibility, and extension mechanisms accordingly.
- With open-code systems such as shadcn, inspect the project configuration, installed components, and repository patterns. Change shared tokens or primitives only when the result should apply system-wide; otherwise compose components or introduce variants at the appropriate layer.

## Implement and verify

- Preserve semantic structure, accessibility, responsive behavior, and interaction states.
- Match visual and implementation complexity to the product need.
- Verify representative viewports and relevant interactions, including loading, empty, error, focus, and reduced-motion states when applicable.
