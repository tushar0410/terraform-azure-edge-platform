# Environments

This directory will hold the Terraform composition roots for `dev`, `stage`, and `prod`. Each environment will have independent backend state, values, RBAC scope, and deployment approval controls.

Environment roots compose reusable modules but do not duplicate module implementation. This creates a predictable promotion path from development through production.
