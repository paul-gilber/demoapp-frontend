# Repository Configuration

This section guides you on how this repository was setup

## Managing the automatic deletion of branches
You can have head branches automatically deleted after pull requests are merged in your repository.

See [steps](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches)

## Configuring Dependabot security updates
You can use [Dependabot security updates](https://docs.github.com/en/code-security/dependabot/dependabot-security-updates/about-dependabot-security-updates) or manual pull requests to easily update vulnerable dependencies.

See [steps](https://docs.github.com/en/code-security/dependabot/dependabot-security-updates/configuring-dependabot-security-updates)

See [configuration](../../.github/dependabot.yml)

## Code Analysis/Scanning
### Integrating repository with SonarCloud
[SonarCloud](https://docs.sonarcloud.io/) is a cloud-based code analysis service designed to detect coding issues in 26 different programming languages. By integrating directly with your CI pipeline or one of our supported DevOps platforms, your code is checked against an extensive set of rules that cover many attributes of code, such as maintainability, reliability, and security issues on each merge/pull request.

See [steps](https://docs.sonarcloud.io/getting-started/github/)

See [workflow](../../.github/workflows/code-scan-sonarcloud.yml)

See [scan results](https://sonarcloud.io/projects)

### Integrating repository with CodeCov
[Codecov](https://about.codecov.io/) is the all-in-one code coverage reporting solution for any test suite — giving developers actionable insights to deploy reliable code with confidence. Trusted by over 29,000 organizations.

[GitHub Integration](https://about.codecov.io/tool/github/)

### Configuring repository for GitHub CodeQL
[CodeQL](https://codeql.github.com/docs/codeql-overview/about-codeql/) is the analysis engine used by developers to automate security checks, and by security researchers to perform variant analysis.

In CodeQL, code is treated like data. Security vulnerabilities, bugs, and other errors are modeled as queries that can be executed against databases extracted from code. You can run the standard CodeQL queries, written by GitHub researchers and community contributors, or write your own to use in custom analyses. Queries that find potential bugs highlight the result directly in the source file.

See [steps](https://docs.github.com/en/code-security/code-scanning/enabling-code-scanning/configuring-default-setup-for-code-scanning#configuring-default-setup-for-a-repository)

See [scan results](https://github.com/paul-gilber/demoapp-frontend/security/code-scanning/tools/CodeQL/status/)
