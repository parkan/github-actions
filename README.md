# GitHub Actions Collection

Reusable GitHub Actions for container-based CI/CD workflows, with first-class support for Podman and devcontainers.

## Available Actions

### [setup-podman-docker](./setup-podman-docker)
Replace Docker with Podman and configure rootless container operations with full Docker CLI compatibility.

### [devcontainer-test](./devcontainer-test)
Build and run tests in devcontainer environments with support for both Docker and Podman backends.

## Quick Start

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      # Setup Podman as Docker replacement
      - uses: parkan/github-actions/setup-podman-docker@v1
        with:
          disable-docker: true
          
      # Run tests in devcontainer
      - uses: parkan/github-actions/devcontainer-test@v1
        with:
          test-command: 'go test ./...'
```

## Testing

These actions include comprehensive test suites. To run tests:

```bash
# Run all tests
act -W .github/workflows/test-actions.yml

# Run specific test job
act -j test-podman-setup

# Validate action files
./scripts/validate-actions.sh
```

## Local Development

For local testing with `act`, see [scripts/test-local-act.sh](./scripts/test-local-act.sh).

## Examples

See the [examples](./examples) directory for complete workflow examples.

## License

MIT - See [LICENSE](./LICENSE) for details.
