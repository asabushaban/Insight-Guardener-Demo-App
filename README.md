# Guardener demo repo

A small repo for the Guardener and Insights walkthrough. It has upstream container images in the four places Guardener looks: a Dockerfile, a Compose file, Kubernetes manifests and Helm values. It maps to the "Before you demo" slide.

## What is in it

| File | Upstream image |
|---|---|
| `Dockerfile` | `python:3.12` |
| `docker-compose.yml` | `redis:7`, `postgres:16` |
| `k8s/web.yaml` | `nginx:1.27` |
| `k8s/cache.yaml` | `redis:7` |
| `helm/demo-chart/values.yaml` | `nginx:1.27` |
| `scripts/make_guardrail_branch.sh` | `memcached:1.6` |
| `.chainguard/images.yaml.example` | n/a |

## Prerequisites (from the slide)

- [ ] You are a GitHub organization owner (installing the app and authorizing the link both need it).
- [ ] You have a Chainguard organization (group) and the latest `chainctl`, authenticated.
- [ ] Add these images to your group catalog **with matching tags**: `python:3.12`, `nginx:1.27`, `redis:7`, `memcached:1.6`. **Do not add `postgres:16`** if you want to show "Not migrated".
- [ ] Push this repo to a GitHub repository in the organization you will link.
- [ ] The second branch (new upstream image) is created later by `scripts/make_guardrail_branch.sh`.
- [ ] Wait 24 hours after installing the app for the first scan to complete. Do this in advance.

## Setup

```bash
cd guardener-demo
git init && git add . && git commit -m "Initial demo repo"
git branch -M main
git remote add origin git@github.com:<github-org>/guardener-demo.git
git push -u origin main
```

Do NOT rename `.chainguard/images.yaml.example` yet. Committing `images.yaml` is what starts migration, so it is step 4.

## Demo flow

1. **Install** the Guardener GitHub App on the GitHub organization (it does nothing until you enable a capability).
2. **Link** your Chainguard organization:
   ```bash
   chainctl guardener github link --github-org <github-org-login> --group <chainguard-group-name>
   chainctl guardener github status --group <chainguard-group-name>
   ```
3. **Discover** what the repo uses (verify flags in the docs before running live):
   ```bash
   chainctl images discover
   ```
4. **Enable migration:** copy `.chainguard/images.yaml.example` to `.chainguard/images.yaml` and commit it to `main`. The push starts the first migration.
5. **Review the migration pull request.** It comes from a branch under `guardener/images/`. Point out what changed, what is listed as "Not migrated" (`postgres:16`), and that CI should run before merge. Do not push to that branch without the `skip:guardener/images` label or an assignee, because Guardener force-pushes it. You can trigger a migration by hand with `chainctl guardener github migrate create <owner>/<repo>`.
6. **Guardrail:** merge the migration PR, then run `./scripts/make_guardrail_branch.sh` and open a PR from `demo/add-memcached`. Show the non-blocking review comment with a one-click suggestion.
7. **Insights dashboard:** the UI is not live yet. Use the launch blog screenshots, and say clearly that it is coming.

## Talking points to expect

- **Clean swap:** `python:3.12` should become the Chainguard Python image without breaking the build, because the `CMD` is in exec form and nothing in the Dockerfile needs a shell.
- **Not migrated:** `postgres:16` shows as "Not migrated" until it is added and entitled in the catalog.
- **Run CI before merging:** Guardener swaps references. It does not run builds or change application code.
- **Entrypoints:** many Chainguard images set a different entrypoint, so check the command if a swap is not enough.

## Resetting for another run

Close or delete the `guardener/images/...` and `demo/add-memcached` branches, restore the original image references on `main`, and rename `images.yaml` back to `images.yaml.example` (or delete it).

## Check before you present

- Commands and flags come from the Guardener public docs, which can change. Confirm them first.
- Confirm each image and tag exists in your group catalog.
- Guardener is Early Access and GitHub only. The Insights dashboard UI is not live yet.
