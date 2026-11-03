# Hello Extension: CI release pipeline trial

- **Pull requests** (`extension-build`): CI builds every flavour. Download the zips from the run's artifacts.
  Never commit zips, and never edit the version.
- **Merges to master** (`extension-release`): the version is stamped as `<major.minor from package.json>.<run number + build_offset>`.
  The commit is tagged `ext/v<version>`, a GitHub Release is created (zips, SHA256SUMS, changelog,
  permission diff), and it publishes to the staging listing.
- **Prod and commit** (`extension-publish`): run it with a release tag and a target. It waits for approval
  on the `extension-prod` environment.
- **Rollback**: run `extension-release` by hand with `ref` set to an old tag. The old code is released
  under a new, higher version and goes to staging, then to prod after approval.

Store listings live in `release-targets.json`. Without `CWS_*` secrets, the store step is a dry run.
