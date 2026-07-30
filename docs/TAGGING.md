# Tagging Strategy

All AWS resources created by this repository must carry the following tags via the provider's `default_tags` block plus any module-specific additions.

## Mandatory Tags

| Tag Key | Example Value | Purpose |
|---------|---------------|---------|
| `Project` | `mcp-ai-architecture` | Identifies the project or application. |
| `Environment` | `prod` | Identifies the environment (dev, staging, prod). |
| `ManagedBy` | `terraform` | Identifies the deployment tool. |
| `Owner` | `platform-team` | Team responsible for the resource. |
| `CostCenter` | `cc-12345` | Cost allocation for finance. |

## Recommended Tags

| Tag Key | Example Value | Purpose |
|---------|---------------|---------|
| `DataClassification` | `internal` / `confidential` | Data classification level. |
| `Backup` | `true` | Whether the resource should be backed up. |
| `AutoShutdown` | `false` | Whether non-prod resources can be shut down. |

## Enforcement

- Tags are defined in `locals.tf` and applied globally via `default_tags`.
- Missing or non-compliant tags may be blocked by policy checks.
