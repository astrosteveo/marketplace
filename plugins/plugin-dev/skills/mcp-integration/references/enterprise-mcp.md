# Enterprise MCP Configuration

Guide for plugin developers building MCP integrations that work in enterprise environments.

## Managed MCP Configuration

Organizations can deploy managed MCP configurations centrally:

**File:** `managed-mcp.json` (deployed by IT/admin)

```json
{
  "mcpServers": {
    "company-api": {
      "type": "http",
      "url": "https://internal-api.company.com/mcp",
      "headers": {
        "Authorization": "Bearer ${COMPANY_TOKEN}"
      }
    }
  }
}
```

Managed configurations cannot be overridden by users or plugins.

## Allow/Deny Lists

### Allowed MCP Servers

```json
{
  "allowedMcpServers": ["company-api", "approved-tool"]
}
```

When `allowedMcpServers` is set, only listed servers can connect. All others are blocked.

### Denied MCP Servers

```json
{
  "deniedMcpServers": ["untrusted-server", "personal-tool"]
}
```

When `deniedMcpServers` is set, listed servers are blocked. All others are allowed.

## Plugin Developer Guidance

### Enterprise Compatibility

1. **Use stable, well-known server names**: Choose server names that IT teams can easily add to allow lists
2. **Document server names**: Clearly list the MCP server names your plugin registers
3. **Support env var configuration**: Allow all URLs and credentials to be configured via environment variables
4. **Handle blocked servers gracefully**: Check if servers are available before depending on them
5. **Provide offline fallbacks**: When possible, offer functionality that works without MCP servers

### Configuration Patterns

**Environment-driven configuration:**
```json
{
  "company-server": {
    "type": "http",
    "url": "${MCP_SERVER_URL}",
    "headers": {
      "Authorization": "Bearer ${MCP_AUTH_TOKEN}"
    }
  }
}
```

IT teams can set environment variables centrally, allowing plugins to work across different enterprise configurations.

### MCP Approval Settings

Enterprise admins can pre-approve or deny MCP server tools:

```json
{
  "mcpToolApproval": {
    "company-api": "auto-approve",
    "external-tool": "always-ask"
  }
}
```

**For plugin developers:** Document which tools your server exposes and their risk level so IT teams can make informed approval decisions.

## Best Practices for Enterprise Plugins

1. **Security first**: Use HTTPS only, support certificate pinning
2. **Audit trail**: Design tools to be auditable (clear inputs/outputs)
3. **Least privilege**: Request minimal permissions
4. **Configuration documentation**: Provide enterprise setup guides
5. **Graceful degradation**: Work partially when some features are restricted
6. **Version compatibility**: Support managed environment updates
