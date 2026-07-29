# Bootstrap

Terraform remote state is a dependency of all deployable environments, so its minimal infrastructure is isolated here from workload infrastructure.

The future bootstrap implementation will establish the dedicated state resource group, state storage account, Azure AD-based access, and least-privilege RBAC. It is intentionally absent from the first commit until subscription layout and state ownership are confirmed.
