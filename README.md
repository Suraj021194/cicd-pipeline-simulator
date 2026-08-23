# CI/CD Pipeline Simulator

A Bash script that simulates a CI/CD pipeline with Build, Test, and Deploy stages — including colored output, timing, and logging for each stage.

## Features
- Runs three stages in sequence: Build → Test → Deploy
- Each stage is timed and logged with pass/fail status
- Colored console output (green for pass, red for fail)
- Build stage validates required app files exist
- Test stage runs simulated checks and reports pass/fail counts
- Configurable target environment via `--env`
- Configurable specific stage via `--stage`

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