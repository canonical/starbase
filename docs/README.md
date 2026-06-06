# Documentation subproject

The documentation build configuration is stored as its own subproject, a copy of the
[Sphinx Stack](https://github.com/canonical/sphinx-stack). Updating and
managing this subproject happens separately from the main app.

The [Sphinx Stack documentation](https://documentation.ubuntu.com/sphinx-stack)
describes the officially-supported features and provides guidance for customizing the docs.

## Update the docs subproject

The goal is to override the build configuration of the Sphinx Stack as little as
possible, so when changes come we don't have to recreate them. The process isn't automatic.

First, diff the Starbase history between now and the last time the subproject was updated in this repository. In Starbase, here's one way to check which docs-related files were changed:

```
git --no-pager diff <commit> --name-only -- docs/ .readthedocs.yaml common.mk Makefile
```

It's typically reliable to replace `<commit>` with a commit SHA dated to right before the subproject was last updated.

Then, diff or copy those files from Starbase to this subproject.

Go into the Sphinx Stack changelog to see what settings and values need updating.

In `pyproject.toml`, remove everything in the `docs-sphinx-stack` group. Then, sync the docs dependencies to the parent project:

```bash
make clean
make docs-setup
uv add -r docs/requirements.txt --group docs-sphinx-stack
```

For safety, test the three main doc commands:

```bash
make docs
make docs-auto
make docs-lint
```

Check that the new and updated features listed in the Sphinx Stack changelog work.
