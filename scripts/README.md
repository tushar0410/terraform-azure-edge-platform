# Scripts

This directory is reserved for safe, repeatable engineering utilities such as validation wrappers, bootstrap helpers, and local development checks.

Scripts must be idempotent where practical, avoid embedding secrets, document required permissions, and fail safely. No imperative Azure provisioning scripts are included; Terraform will remain the infrastructure source of truth.
