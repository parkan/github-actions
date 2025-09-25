# Setup Podman as Docker

This action replaces Docker with Podman and configures it for rootless operation with Docker CLI compatibility.

## Features

- ✅ Seamless Docker replacement
- ✅ Rootless container operations  
- ✅ Docker CLI compatibility via podman-docker
- ✅ Automatic socket configuration
- ✅ Storage caching support
- ✅ Comprehensive verification

## Usage

```yaml
- name: Setup Podman as Docker
  uses: parkan/github-actions/setup-podman-docker@v1
  with:
    disable-docker: true        # Disable existing Docker (default: true)
    cache-storage: true         # Cache Podman storage (default: true)
    socket-path: ''            # Custom socket path (default: auto)
```

## Outputs

| Output | Description |
|--------|-------------|
| `socket-path` | Path to Podman socket |
| `docker-host` | DOCKER_HOST environment value |
| `podman-version` | Installed Podman version |

## Examples

### Basic Usage
```yaml
- uses: parkan/github-actions/setup-podman-docker@v1
```

### With Custom Socket Path
```yaml
- uses: parkan/github-actions/setup-podman-docker@v1
  with:
    socket-path: /tmp/podman.sock
```

### Without Docker Removal
```yaml
- uses: parkan/github-actions/setup-podman-docker@v1
  with:
    disable-docker: false
```

## Troubleshooting

### Socket not created
- Check logs in `$RUNNER_TEMP/podman-logs/service.log`
- Ensure XDG_RUNTIME_DIR is set
- Verify subuid/subgid mappings

### Permission denied errors
- Verify rootless configuration with `podman info`
- Check user namespace mappings
- Ensure proper ownership of runtime directory
