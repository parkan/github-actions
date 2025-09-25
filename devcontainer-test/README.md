# Devcontainer Test Runner

Run tests inside a devcontainer environment with support for both Docker and Podman backends.

## Features

- ✅ Automatic devcontainer build and setup
- ✅ Docker and Podman support
- ✅ Build caching
- ✅ Pre/post build hooks
- ✅ Comprehensive error handling
- ✅ Test result reporting

## Usage

```yaml
- name: Run Devcontainer Tests
  uses: parkan/github-actions/devcontainer-test@v1
  with:
    workspace-folder: .
    test-command: 'npm test'
    container-runtime: auto    # auto, docker, or podman
    build-cache: true
```

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `workspace-folder` | Path to workspace | `.` |
| `test-command` | Command to run in container | required |
| `container-runtime` | Runtime to use | `docker` |
| `build-cache` | Enable build caching | `true` |
| `container-id-label` | Container label | `ci=devcontainer` |
| `pre-build-command` | Pre-build hook | `''` |
| `post-build-command` | Post-build hook | `''` |
| `fail-on-error` | Fail action on test error | `true` |

## Outputs

| Output | Description |
|--------|-------------|
| `container-id` | Container ID |
| `test-exit-code` | Test command exit code |
| `build-time` | Build duration in seconds |

## Examples

### Go Project
```yaml
- uses: parkan/github-actions/devcontainer-test@v1
  with:
    test-command: 'go test -v ./...'
```

### Node.js Project  
```yaml
- uses: parkan/github-actions/devcontainer-test@v1
  with:
    test-command: 'npm ci && npm test'
    post-build-command: 'npm run build'
```

### Python Project
```yaml
- uses: parkan/github-actions/devcontainer-test@v1
  with:
    test-command: 'python -m pytest'
    pre-build-command: 'pip install -r requirements-dev.txt'
```
