# CI/CD Pipeline Simulator 
# We have also added jenkins

A Bash script that simulates a CI/CD pipeline with Build, Test, and Deploy stages — including colored output, timing, and logging for each stage. Also wired into a real, automated GitHub Actions workflow.

## Features
- Runs three stages in sequence: Build → Test → Deploy
- Each stage is timed and logged with pass/fail status
- Colored console output (green for pass, red for fail)
- Build stage validates required app files exist
- Test stage runs simulated checks and reports pass/fail counts
- Configurable target environment via `--env`
- Configurable specific stage via `--stage`
- Fails fast: a failing stage stops the pipeline and skips remaining stages, both locally and in CI
- Resolves its own script directory dynamically, so it runs correctly on any machine (including CI runners)

## Usage
```bash
./pipeline.sh --env production
./pipeline.sh --stage build
./pipeline.sh --help
```

## Arguments
- `--stage` : run a specific stage only (build, test, or deploy)
- `--env` : set the target environment (default: development)
- `--help` : show usage instructions

## Sample App
The `myapp/` folder contains a minimal fake application used to demonstrate the pipeline:
- `app.py` — main application file
- `test_app.py` — test file
- `requirements.txt` — dependency list

## Continuous Integration
Every push to `main` automatically triggers `.github/workflows/ci.yaml`, which checks 
out the repo and runs all three stages (`build`, `test`, `deploy`) on a GitHub-hosted 
runner. A failing stage correctly fails the workflow and blocks later stages — this 
is driven by the script's real exit code, not just its printed output.

## Jenkins
The same pipeline also runs under Jenkins through the `Jenkinsfile` at the repo root. It has three stages (Build, Test, Deploy), and each calls `./pipeline.sh --stage <name>`.

Run Jenkins locally in Docker:
```bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

Create a Pipeline job with these settings:
- Definition: Pipeline script from SCM
- SCM: Git, with this repository's URL
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`
- Optional: enable Poll SCM (for example `H/5 * * * *`) to build automatically on new commits

Notes:
- `pipeline.sh` must have `#!/bin/bash` on **line 1**. Jenkins' `sh` step uses `/bin/sh`, so a misplaced shebang breaks bash-only syntax such as `==` inside `[ ]`.
- GitHub webhooks cannot reach a Jenkins on `localhost`, so Poll SCM is used for local setups.
