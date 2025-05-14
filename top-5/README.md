# Top 5 Security Practices

This directory provides rules verifying one implementation of the top 5 items to address when considering GitHub repository security:

- Set up branch protection

  This rule uses [repository rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) to enforce protections on the main branch on and released tags matching the `v0.0.0` format. The enforced rules are:
  * Prevent branch and tag deletion
  * Prevent updates to release tags
  * Require PRs for updates

  Repository rulesets are available for public repos and for organizations on a [Team](https://docs.github.com/en/get-started/learning-about-github/githubs-plans) or higher plan.

  <!-- TODO: Add the ability to enforce certain checks passing, based on past history -->

- <a name="pinning">Prevent external CI changes

  This rule uses [GitHub Actions pinning](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#using-third-party-actions) to prevent CI changes due to changes in external repositories. In combination with [SCA updates](#sca), this rule aims to ensure that you have the opportunity to review any changes to your CI and build system before they take effect.

  Note that this rule **does not** prevent external actions from changing behavior based on the code at the pinned commit (which may call further services), it only prevents updates to the code based on commits to the action, like in [the `tj-actions` attack](https://www.stepsecurity.io/blog/harden-runner-detection-tj-actions-changed-files-action-is-compromised).

- Run static application code scans (SAST)

  Static Application Security Testing is a technique which examines code for vulnerable patterns.  For example, this may consist of linter rules or specialized tools which detect language-specific problems, such as using `%s` strings in Python SQL statements (allowing SQL injection), or ignoring error returns in Golang code.  Depending on the detected language(s), this rule will check to see if a GitHub Action to perform security scanning has been enabled in the repo.  If not, it will recommend a tool.  At the moment, we recommend using [`semgrep`](https://semgrep.dev/), but recognize a number of other tools.

  <!-- TODO: examples from different languages -->

- <a name="sca">Update Dependencies

  Outdated dependencies can introduce two problems:
  1. Security vulnerabilities from the underlying library
  1. Noise in security scanners even if the underlying security vulnerability is not reachable
  Additionally, dependencies which are deeply out of date may be either beyond the upstream support window or require a substantial amount of effort to upgrade to the latest version.  If a security vulnerability is found in these outdated versions, the effort required to fix it may be much higher than if the project stays on recent versions.

  This rule will [set up the GitHub dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuring-dependabot-version-updates) to provide automated pull requests that keep dependencies up to date if no configuration is found.  The rule also recognizes [`renovate`](https://docs.renovatebot.com/) configuration if you prefer that tool.  Both tools can be configured to work with [supply chain pinning](#pinning) to send PRs to update pinned resources.

- Limit CI permissions

  By default, [GitHub workflows generally default to a wide set of permissions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication#permissions-for-the-github_token).  This rule requires that all actions explicitly declare the permissions they intend to use, reducing the surface area for an attacker attempting to compromise a repository via GitHub Actions.
  