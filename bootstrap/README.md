# Custcodian Infrastructure as Code Profile

# GitHub Actions Minder Profile - Auto-Remediation

This profile configures GitHub Actions to automatically apply Minder rules
within the selected repository to the default Minder project. This profile
takes advantage of the following Minder features:

* **Remediation** - to automatically create (or re-create) a PR defining
  specific GitHub Actions workflows.  This can be used to restart the
  onboarding flow if the Actions are deleted, as Minder will attempt to
  re-create the files.

* **Selectors** - By default, the bootstrap profile selects repositories
  named `.github` across all organizations.  If you are using one Minder
  project across multiple organizations, you may want to use an `==`
  selector with the specific organization name you use for profiles.

* **Github Actions Authorization** - The generated actions use the
  [Minder GitHub Action](https://github.com/mindersec/minder-action) to
  apply the policies under the `./minder` directory to the current project.

This workflow also includes a few additional features designed to support teams
who want to customize or manage additional rules:

* The [Custcodian rule sync action](https://github.com/custcodian/sync-catalog)
  uses a diff between the previous and current files to synchronize new
  rule catalog changes _without_ overwriting local modifications.  Of course,
  it also does this in a PR, so you can review it.  😊

* [This bootstrap rule](./) is part of the synchronized set of profiles, which
  allows easy adoption and updates of future improvements.  Dependency drift
  can be a major problem, so we don't want your anti-drift system to have a
  staleness problem!

```mermaid
flowchart LR
    Rules["Minder Rules"]
    Repo["Repository"]
    Minder["Minder Project"]
    
    Rules -->|PR| Repo
    Repo -->|apply| Minder
    Repo -->|catalog-sync(PR)| Repo
```

This approach ensures that infrastructure, security policies, and compliance
rules are treated as code, version-controlled, and automatically enforced at
scale across your registered supply chain infrastructure.