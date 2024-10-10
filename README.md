# Git stacked

A simple tool to facilitate [stacking workflows](https://www.stacking.dev/) in git.

## Design goals

- Works alongside the git CLI, does not try to replace it
- All functionality is accomplished using standard git commands (like `--update-refs`)
- No state stored outside of git
- Core dependencies only include bash and git
- Core functionality works with any git service provider

## Sample usage

TODO: update with v2 changes

```
> qstack create logging frontend
Switched to a new branch 'user/logging/frontend/TIP'

> qstack branch backend
Renamed branch 'user/logging/frontend/TIP' -> 'user/logging/frontend'
Switched to a new branch 'user/logging/backend/TIP'

> qstack push
Pushing branch: user/logging/backend/TIP -> user/logging/backend
...

Pushing branch: user/logging/frontend -> user/logging/frontend
...

> qstack rebase
...

> qstack create helm prometheus
Switched to a new branch 'user/helm/prometheus/TIP'

> qstack list
helm
logging

> qstack switch logging
Switched to branch 'user/logging/backend/TIP'

> qstack list-branches
user/logging/backed/TIP
user/logging/frontend
```

## Setup

Clone this repo somewhere, e.g. `~/dev/qstack`

In your `~/.zshrc` or `~/.bashrc`:
```
# Optional:
# export GS_BASE_BRANCH="..."
# export GS_BRANCH_PREFIX="..."

source ~/dev/qstack/qstack.sh
``` 

## Recommended `~/.gitconfig` settings

These settings are not required to use `qstack`, but will be helpful for git operations you do outside of the `qstack` commands.

```
[push]
    autoSetupRemote = true
    default = upstream

[rebase]
    updateRefs = true
```

`qstack` makes significant use of renaming local branches, so `default = upstream` avoids errors when you try to re-push after renaming a local branch.

`updateRefs = true` means that rebasing will automatically update refs, without having to specify `--update-refs`.

## Naming

Inspired by one of my favourite League of Legends champions, Nasus :)

## Comparison with other tools

Good overview of the available tools: https://stacking.dev. Find one that speaks to you!

https://github.com/spacedentist/spr
- API is based on phabricator (one commit per PR)
- only works with Github
- requires Github personal access token

https://graphite.dev/
- paid SaaS
