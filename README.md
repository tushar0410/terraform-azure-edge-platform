# Terraform Azure Edge Platform

Production-oriented Terraform foundation for an Azure edge delivery platform. The target platform will publish static content globally through Azure Front Door, protect its origins, and provide a secure operational baseline with Azure RBAC, managed identity, and centralized monitoring.

This repository is intentionally at its first-commit stage: it contains repository conventions and architecture documentation only. It does not create Azure resources, contain Terraform modules, or configure a remote backend yet.

## Architecture

The proposed platform uses Azure Front Door Premium as the global edge service, Azure Storage as the static origin, Private Link/private endpoints for production-origin protection, Log Analytics and Azure Monitor for observability, and Azure RBAC with GitHub Actions OIDC for delivery authentication.

The full rationale, traffic path, security posture, module boundaries, and deployment sequencing are in [docs/architecture.md](docs/architecture.md).

## Repository layout

```text
.
|-- .github/workflows/  # Future GitHub Actions workflows
|-- bootstrap/          # Isolated Terraform state bootstrap (not implemented)
|-- diagrams/           # Source diagrams and rendered architecture assets
|-- docs/               # Architecture decisions and operational documentation
|-- environments/       # Future dev, stage, and prod composition roots
|-- modules/            # Future reusable Terraform modules
|-- scripts/            # Safe, repeatable engineering utilities
|-- backend.tf          # Remote-state configuration template only
`-- versions.tf         # Terraform and provider version constraints
```

## Design decisions

- **Environment composition is separated from modules.** This enables the same implementation to be promoted through `dev`, `stage`, and `prod` without copying infrastructure code.
- **Remote state is bootstrapped separately.** State contains sensitive operational metadata and must not share the content-origin storage account. The backend template remains intentionally unconfigured until bootstrap ownership, naming, and RBAC are approved.
- **Provider versions are pinned.** Exact provider constraints improve reproducibility; the dependency lock file will be committed when the first initialized Terraform root is introduced.
- **No resources are defined in the repository root.** Terraform roots will live in environment and bootstrap directories. The root-level version policy is a repository contract, not a deployment root.
- **CI/CD is deferred until executable roots exist.** Workflows will first enforce formatting and validation, then add plan and approved apply once remote state and OIDC identities are in place.

## Prerequisites

- Terraform 1.9 or later
- An Azure subscription and tenant, once deployment phases begin
- Azure CLI for local authentication, or GitHub Actions OIDC for CI

## Current status

| Phase | Status |
| --- | --- |
| 0 - Architecture | Complete |
| 1 - Repository structure | Complete |
| 2 - Foundation | Not started |
| 3 - Networking | Not started |
| 4 - Storage origins | Not started |
| 5 - Edge layer | Not started |
| 6 - Observability | Not started |
| 7 - CI/CD | Not started |
| 8 - Operational documentation | In progress |

## Next milestone

After repository conventions are reviewed, the next change will introduce the Resource Group module with its inputs, outputs, README, and validation checks. No other Azure service will be added in that milestone.

## License

This project is licensed under the [MIT License](LICENSE).
