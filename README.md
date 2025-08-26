# 7gram Dashboard

This project hosts the 7gram dashboard (frontend + supporting services) while consuming the shared nginx infrastructure as a git submodule for reverse proxy, TLS, and deployment automation.

## Repo Layout

```text
7gram/
  README.md
  nginx/                # (optional) overlay configs specific to 7gram
  docker/               # compose files / Docker assets for dashboard services
  scripts/              # helper scripts for local dev & CI/CD
  shared_nginx/         # git submodule -> ../../shared/nginx (central infra)
```

## Adding the shared nginx submodule

Run:

```bash
git submodule add ../../shared/nginx shared_nginx
# Or if referencing remote origin
# git submodule add git@github.com:<org-or-user>/nginx.git shared_nginx
```

Then commit `.gitmodules` plus the submodule entry.

To update later:

```bash
git submodule update --remote --merge shared_nginx
```

## Development

1. Ensure submodule initialized:

   ```bash
   git submodule update --init --recursive
   ```

2. Copy or override any environment values (see `shared_nginx/.env`).
3. Start local stack (example):

   ```bash
   scripts/dev-up.sh
   ```

## Overriding Nginx Config

Place custom server blocks or snippets inside `nginx/`. A simple include pattern is supported by adding lines into `shared_nginx/config/nginx/conf.d/` that reference files in `../../../../dashboards/7gram/nginx/` if you keep relative paths stable, or by copying a base template during build (see `docker/Dockerfile.nginx-overlay` for an example you can create).

## Scripts

- `scripts/dev-up.sh` : launches dashboard + nginx reverse proxy.
- `scripts/dev-down.sh` : stops stack.

## CI/CD Notes

Use the submodule hash pinning strategy: pipelines should run `git submodule sync --recursive && git submodule update --init --recursive` to ensure deterministic infra version.

## License

Refer to parent project licensing.
