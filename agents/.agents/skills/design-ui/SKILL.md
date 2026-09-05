---
name: design-ui
description: Design and implement web visuals and interactions, whether creating an original design or working within an existing design system. Skip purely functional changes.
---

# Design UI

Ground visual decisions in the product's purpose, audience, content, brand, accessibility requirements, technical constraints, and repository conventions.

## Work within the right design context

- For an existing product, treat its tokens, primitives, components, layouts, and interaction patterns as the design baseline unless the user requests a redesign. Reuse and compose them first; extend them at established seams rather than introducing parallel conventions.
- For original designs, start from an established component system suited to the stack, preferably shadcn/ui with Tailwind CSS and Base UI. Adapt its visual language to the domain and aesthetic established by the user and conversation.
- Determine whether a framework is the product's design authority or an implementation substrate. Preserve its contracts and use its intended composition, theming, accessibility, and extension mechanisms accordingly.
- With open-code systems such as shadcn, inspect the project configuration, installed components, and repository patterns. Change shared tokens or primitives only when the result should apply system-wide; otherwise compose components or introduce variants at the appropriate layer.

## Shape the interface around the work

- Match information architecture and density to the workflow: dashboards for monitoring, CRUD screens for record management, marketing layouts for persuasion.
- Use clear affordances, visual hierarchy, and consistent interaction patterns.
- Avoid decorative taglines, redundant subtitles, and wrapping every section in a card. Use visual containers only for meaningful grouping.

## Implement and verify

- Preserve semantic structure, accessibility, responsive behavior, and interaction states.
- Verify representative viewports and relevant interactions, including loading, empty, error, focus, and reduced-motion states when applicable.
