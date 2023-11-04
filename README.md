# Demoapp frontend
This project was forked from: [arjungautam1/fullstack-frontend](https://github.com/arjungautam1/fullstack-frontend) and will be used for demonstration of DevOps CI/CD automation

See [repository configuration](docs/repository-configuration/README.md)

## Features
1. Provides consistent development environment across users using [Visual Studio Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers). See [configuration](.devcontainer/devcontainer.json)

2. Uses [git pre-commit hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to prevent Workflow failures caused by trivial errors like linter errors. This [pre-commit hook](.githooks/pre-commit) is shared across users through [Visual Studio Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) using [postCreateCommand.sh](.devcontainer/postCreateCommand.sh) which sets hooks path to `.githooks`

3. Uses [Docker Compose](https://docs.docker.com/compose/) to enable local deployment of the `application` (demoapp-frontend) including all `dependencies` (mysql). See [compose.yaml](deploy/docker-compose/compose.yaml)

4. Provides [pull request checklist](.github/pull_request_template.md). See [sample pull request](https://github.com/paul-gilber/demoapp-frontend/pull/14)

5. Supports multi-platform container image builds using [Docker buildx bake](https://docs.docker.com/build/bake/). See [docker-bake.hcl](docker-bake.hcl)

6. Uses [Container Structure Tests](https://github.com/GoogleContainerTools/container-structure-test) for running metadata, command and file existence tests to ensure consistency of image builds. See [container-structure-test.yaml](container-structure-test.yaml)

7. Uses [GitHub Actions workflows](https://docs.github.com/en/actions/using-workflows/about-workflows) for automating builds, scans, tests, publishing of [GitHub Packages](https://github.com/features/packages), automatic pull request labeling, and release drafting (and versioning)

8. Supports `build once, deploy many` by defining object(s) during runtime using [env.sh](demoapp-frontend/env.sh) which overrides [.env](demoapp-frontend/.env) using runtime environment variables

## GitHub Actions workflows
The following workflows are included in this project:

1. [Build](.github/workflows/build.yml)
- Runs unit test
- Builds application container image and pushes it to [Docker Hub](https://hub.docker.com/)
- Tests application container image with [Container Structure Tests](https://github.com/GoogleContainerTools/container-structure-test)
- Scans application container image with [Aqua Security Trivy](https://trivy.dev/#:~:text=Trivy%20is%20the%20most%20popular,Apache%2D2.0%20License)

2. [Coverage reports with CodeCov](.github/workflows/code-scan-codecov.yml)

[Codecov](https://about.codecov.io/) is the all-in-one code coverage reporting solution for any test suite — giving developers actionable insights to deploy reliable code with confidence. Trusted by over 29,000 organizations.

3. [Code Analysis with CodeQL](.github/workflows/code-scan-codecov.yml)

[CodeQL](https://codeql.github.com/docs/codeql-overview/about-codeql/) is the analysis engine used by developers to automate security checks, and by security researchers to perform variant analysis.

4. [Code Analysis with SonarCloud](.github/workflows/code-scan-sonarcloud.yml)

[SonarCloud](https://docs.sonarcloud.io/) is a cloud-based code analysis service designed to detect coding issues.

5. [Pull Request Labeler](.github/workflows/labeler.yml)

Automatically label new pull requests based on the paths of files being changed.

6. [Release Drafter](.github/workflows/release-drafter.yml)

Drafts your next release notes as pull requests are merged into `main`.
Release drafter recommends release version based on [release-drafter.yml](.github/release-drafter.yml#L22)
See [sample releases](https://github.com/paul-gilber/demoapp-frontend/releases).

7. [Publish Container Image to GitHub Packages](.github/workflows/release.yml)
```
To create a release:
1. Create pre-release from draft. A corresponding tag is created by this step e.g. `v1.0.0`. Workflow is triggered when a tag starting with `v` is created.
2. Workflow builds and publishes release image to GitHub packages
3. Set pre-release as latest version
```

## Dependencies
1. [demoapp-backend](https://github.com/paul-gilber/demoapp-backend)
2. MySQL database instance

## Visual Studio Dev Container with Podman Desktop
1. Install [Podman Desktop](https://podman-desktop.io/docs/installation)
2. Install [Podman CLI](https://podman.io/docs#installing-podman)
3. Install [Podman Compose](https://github.com/containers/podman-compose#installation)
4. Update [Visual Studio Code User Settings](https://code.visualstudio.com/docs/getstarted/settings#_settingsjson)
```yaml
# settings.json
{
  "dev.containers.dockerComposePath": "podman-compose",    # Add this
  "dev.containers.dockerPath": "podman"    # Add this
}
```

## Build Application from Visual Studio Code Dev Container
This project uses [Visual Studio Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) which provides consistent Development environment across user(s) or team(s).

Visual Studio Code Dev Containers extension looks up [devcontainer.json](.devcontainer/devcontainer.json) file which defines the Container environment specification.

### Build Application Container Image with Multi-stage builds
[Multi-stage](https://docs.docker.com/build/building/multi-stage/) builds are useful to anyone who has struggled to optimize Dockerfiles while keeping them easy to read and maintain.
```sh
docker build -f Containerfile -t demoapp-frontend .
```

## Run Application from Visual Studio Code Dev Container
### Run Application using Docker Compose
[Compose](https://docs.docker.com/compose/) is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.

By default, Compose looks up configuration from [compose.yaml](compose.yaml).
To ensure successful run of the Application, `spring.datasource.url` from [application.properties](src/main/resources/application.properties) must match with [compose.yaml](compose.yaml)
```sh
# src/main/resources/application.properties
spring.datasource.url=jdbc:mysql://mysql:3306/demoapp
# Database credentials must not be hardcoded and should be provided using Environment variables
# Externalized Spring Configuration: https://docs.spring.io/spring-boot/docs/1.5.6.RELEASE/reference/html/boot-features-external-config.html
spring.datasource.username=  # Environment variable: SPRING_DATASOURCE_USERNAME
spring.datasource.password=  # Environment variable: SPRING_DATASOURCE_PASSWORD
```
```yaml
# showing diff from demoapp-backend compose.yaml: https://github.com/paul-gilber/demoapp-backend/blob/main/deploy/docker-compose/compose.yaml
networks:
  backend:    # defines `backend` network which connects all services
  frontend:    # defines `frontend` network which connects all services except mysql
services:
  # Nginx is used as a reverse proxy to enable connectivity from host machine to docker compose services
  nginx:
    depends_on:
      demoapp-frontend:
        condition: service_healthy    # healthy status is indicated by `healthcheck` keyword
    # builds nginx image from `demoapp-frontend/nginx` directory
    build:
      context: ../../nginx
      dockerfile: Containerfile
    ports:
      - "8080:80"    # Forwards container port 80 to host port 8080. URL: http://localhost:8080/
    networks:
      - backend    # Connect to `backend` network
      - frontend    # Connect to `frontend` network
  demoapp-frontend:
    depends_on:
      demoapp-backend:
        condition: service_healthy    # Ensure `demoapp-backend` health before starting `demoapp-frontend` container
    environment:
      REACT_APP_DEMOAPP_BACKEND_URL: "${DEMOAPP_BACKEND_URL}"    # Override default demoapp-backend url
    healthcheck:
      test: curl --fail http://localhost:8080/    # command for testing health
    networks:
      - backend    # Connect to `backend` network
      - frontend    # Connect to `frontend` network
```
```sh
# Note: by default, compose.yaml was configured to use an existing application image. Run build before docker compose or update compose.yaml and enable `build` field

docker compose --project-directory deploy/docker-compose up
docker compose --project-directory deploy/docker-compose up --build # rebuild application image, only applicable if `build` field is enabled
docker compose --project-directory deploy/docker-compose down --volumes # remove containers, networks and volumes created by docker compose
```

## Testing Application Container Image with Container Structure Tests
[Container Structure Tests](https://github.com/GoogleContainerTools/container-structure-test) provide a powerful framework to validate the structure of a container image. These tests can be used to check the output of commands in an image, as well as verify metadata and contents of the filesystem

Run below command to run [test](container-structure-test.yaml) for `demoapp-frontend`
```sh
container-structure-test test --image demoapp-frontend:latest --config container-structure-test.yaml
```
