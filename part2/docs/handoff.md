# Repository Handoff Checklist

1. Inspect existing repo tree, README, and CP01–CP05/canonical files; do not overwrite them.
2. Merge this package's README as a Part 2 section into the existing root README.
3. Add docs and read-only SQL in appropriate directories; preserve existing naming conventions.
4. Reconcile exact CP06–CP09 CREATE statements and agent specification with the live Snowflake definitions or previously saved scripts. Do not fabricate deployable definitions.
5. Keep credentials, account URLs, tokens, and personally identifying logs out of commits.
6. `git diff --check`; review `git status -sb`; stage only approved files.
7. Commit and push after explicit review. Do not assume GitHub is updated by this ZIP package.

**Production hardening backlog:** incremental KG synchronization; key-level parity checks; agent RBAC and least privilege; audit and observability; test fixtures for 48-hour boundary, ambiguous and future events; root-cause provenance policy; cost/performance review.
