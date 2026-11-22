# platform-deployments

GitOps for application services: per-environment ECS task definitions and the image digests that run where.

| Stack | Service |
|---|---|
| `dev/ap-southeast-2/commerce-api` | `commerce-api` operations simulator on `mdb-dev`, pinned by image digest |

## Making a change

Merging to `main` deploys. Nobody applies from a laptop.

1. Create a branch and edit the stack.
2. Open a PR. CI runs static checks and a read-only `plan` per stack.
3. Merge with rebase. CI applies on `main` through the `dev` environment.

To bump an image, copy the "Image pushed" line from a CI run of the application repo and paste the digest into the stack's `locals.tf`.

## Adding a stack

Create `<env>/<region>/<app>/` with a `backend.tf` that sets only `key` (`platform-deployments/<env>/<region>/<app>/terraform.tfstate`). The rest of the backend comes from `backend.hcl`. Add the stack to the workflow and its plan check to `platform-github`.
