# Repository Agent Guidance

## Fork Maintenance

- Before completing any task that adds, changes, or removes intentional fork
  behavior, or that merges upstream, invoke `$fork-doc`. If the skill is
  unavailable, follow the maintenance contract in `FORK.md` manually.
- Reuse decisions in `FORK.md` while current code and upstream history still
  support them. Reconsider a decision only when new evidence adds,
  contradicts, invalidates, or leaves it unresolved.
- Keep public behavior, regression tests, `FORK.md`, `CHANGELOG.md`, and the
  English, Simplified Chinese, and Brazilian Portuguese README documentation
  synchronized in the same commit.
- Version every fork release as `<upstream-version>-fork.<N>`. Reset to
  `fork.1` when the merged upstream version changes, and increment `N` for
  later releases based on the same upstream version.
- Do not install Git hooks or invoke AI workflows from hooks as part of fork
  documentation maintenance.
