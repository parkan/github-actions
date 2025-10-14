# GitHub Actions Collection

Reusable GitHub Actions for container-based CI/CD workflows, with first-class support for Podman and devcontainers.

## Available Actions

### [setup-podman-docker](./setup-podman-docker)
Replace Docker with Podman and configure rootless container operations with full Docker CLI compatibility.

### [devcontainer-build](./devcontainer-build)
Build and start a devcontainer environment. Outputs container ID for use with devcontainer-exec.

### [devcontainer-exec](./devcontainer-exec)
Execute a command in a running devcontainer. Run multiple separate checks (tests, linting, formatting) as individual CI steps with granular pass/fail status.

### [devcontainer-cleanup](./devcontainer-cleanup)
Stop and remove a devcontainer. Use with `if: always()` to ensure cleanup happens even if tests fail.

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

      # Setup Podman (optional - can also use Docker)
      - uses: parkan/github-actions/setup-podman-docker@v1
        with:
          disable-docker: true

      # Build devcontainer once
      - name: Build devcontainer
        id: build
        uses: parkan/github-actions/devcontainer-build@v1

      # Run multiple checks - each shows as separate pass/fail
      - name: Run tests
        uses: parkan/github-actions/devcontainer-exec@v1
        with:
          container-id: ${{ steps.build.outputs.container-id }}
          command: 'go test -v ./...'

      - name: Run linter
        uses: parkan/github-actions/devcontainer-exec@v1
        with:
          container-id: ${{ steps.build.outputs.container-id }}
          command: 'go vet ./...'

      - name: Check formatting
        uses: parkan/github-actions/devcontainer-exec@v1
        with:
          container-id: ${{ steps.build.outputs.container-id }}
          command: 'test -z "$(gofmt -l .)"'

      # Cleanup
      - name: Cleanup
        if: always()
        uses: parkan/github-actions/devcontainer-cleanup@v1
        with:
          container-id: ${{ steps.build.outputs.container-id }}
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
