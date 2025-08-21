## Repo maintenance guide

This directory hosts documentation and templates for maintainers contributing packages to the uspm repository.

### What goes in here
- templates: canonical examples for `install.sh`, `remove.sh`, and `package.toml`.
- Maintainer guidance: how to structure your package, open a PR, and pass review.

### Read the templates first
- Start with `repo_maintain/templates/install.sh` and `repo_maintain/templates/remove.sh`.
- Do not change how `.sh` files are handled by the core tooling. Follow the template structure and comments. Keep `set -euo pipefail` style, validate inputs, avoid `sudo` and writes outside `$HOME`.
- Describe your package via `repo_maintain/templates/package.toml`. The schema is intentionally minimal:

```
version = "0.0.0"             # optional hint; search may auto-resolve from source tags
source = "https://example.com/repo"  # upstream homepage or VCS URL
description = "Short summary"
license = "MIT"               # SPDX identifier preferred
maintainer = "Your Name <you@example.com>"  # required
```

Notes:
- Version may be inferred by search tooling when the source is a VCS with tags. Still keep it updated for clarity.
- Keep description short; long docs live in the upstream repo.

### Directory layout for a new package

```
repo/
└── <package-name>/
    ├── install.sh
    ├── remove.sh
    └── package.toml
```

Place your package under `repo/<package-name>` with the three files above.

### PR-based contribution flow (example with wpaperd)

1) Fork and clone
```
gh repo fork dacctal/uspm --clone --origin origin
cd uspm
git remote add upstream https://github.com/dacctal/uspm.git
git fetch upstream
```

2) Create a feature branch
```
git checkout -b feat/wpaperd-initial
```

3) Create the package folder and files
```
mkdir -p repo/wpaperd
```

Add your three files:
- `repo/wpaperd/install.sh` — follow the template structure from `repo_maintain/templates/install.sh`.
- `repo/wpaperd/remove.sh` — follow the template structure from `repo_maintain/templates/remove.sh`.
- `repo/wpaperd/package.toml` — use the template in `repo_maintain/templates/package.toml` and fill fields.

4) Quick local checks
```
shellcheck repo/wpaperd/install.sh repo/wpaperd/remove.sh || true
```

Dry-run install into a throwaway prefix:
```
export USPM_ROOT="$(mktemp -d)"
export USPM_BIN="$(mktemp -d)"

bash repo/wpaperd/install.sh
test -e "$USPM_BIN/wpaperd" && echo "Binary linked OK" || true

bash repo/wpaperd/remove.sh
[ ! -e "$USPM_BIN/wpaperd" ] && echo "Removed OK" || true

rm -rf "$USPM_ROOT" "$USPM_BIN"
unset USPM_ROOT USPM_BIN
```

5) Commit and push
```
git add repo/wpaperd
git commit -m "repo(wpaperd): add wpaperd <version>"
git push -u origin feat/wpaperd-initial
```

6) Open the Pull Request
```
gh pr create \
  --title "Add: wpaperd (<summary>)" \
  --body "Adds a curated uspm package for wpaperd.\n\n- No sudo; user-level install\n- Clean uninstall via manifest\n- Installs into ~/.local/opt/uspm/<name>/<version> and symlinks ~/.local/bin/<name>"
```

### Maintainer review checklist
- No `sudo`, no writes outside `$HOME`.
- Clean uninstall via `remove.sh` (uses a manifest and safe symlink removal if applicable).
- Script style: fail fast; quote paths; avoid destructive commands.
- Metadata present in `package.toml` (`version`, `source`, `description`, `license`, `maintainer`).
- Builds in a clean environment (container/CI) with required dependencies.

### Style and safety rules
- Never escalate privileges; keep installs per-user in `~/.local` style locations.
- Prefer reproducible, pinned sources (e.g., Git tags).
- Record what you install so removal is precise.
- Keep scripts minimal and readable. Avoid cleverness.

### Questions
Open an issue or mention maintainers in your PR if you need schema changes or additional template fields. Avoid adding custom keys without prior discussion.


