# Workflows

This directory will contain GitHub Actions workflows for Terraform formatting, validation, security scanning, plan generation, and approval-gated apply.

No workflow is included in the first commit because there are no deployable Terraform roots. Adding a workflow before a backend, identity, and environment contract exists would create a misleading pipeline.
