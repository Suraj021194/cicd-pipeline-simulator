# CI/CD Pipeline Simulator

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