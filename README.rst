********
starbase
********

The base repository for Starcraft projects.

Description
-----------
This template code is the basis for all future starcraft projects, and acts as
the testbed for any major tooling changes that we want to make before
propagating them across all projects.

Structure
---------
TODO

Migrate existing projects
--------------------------------
#. Modify top-level files in your project to match what's in Starbase as closely
   as possible.
   #. ``Makefile`` - Ensure you use ``uv`` and at least have the same targets.
   #. ``pyproject.toml`` - Move things into here from your ``setup.py``,
      ``setup.cfg``, and ``requirements.*.txt``.
   #. ``README.md`` - If your readme is .rst, convert with pandoc:
      ``pandoc -o README.rst README.md``
      Don't worry about making the contents match, Starbase's is very specific.
#. Make your codebase pass with ``ruff``.  Commit after each step:
   #. ``ruff check --fix``
   #. ``ruff check --fix --unsafe-fixes``
   #. ``ruff check --add-noqa``
   #. ``ruff format``
#. Run all the linters: ``make lint``
   #. ``mypy`` will probably give you problems, it checks the same things as
      ``ruff``'s ``ANNXXX`` checks, but ``ruff``'s ``noqa`` directives mean
      nothing to mypy.  You'll need to fix these by hand, mostly by adding type
      annotations to function definitions.
   #. ``pyright`` will probably give you problems.
         ...

Create a new project
---------------------------
[TODO: Make this a template repository.]

#. `Use this template`_ to create your repository.
#. Ensure the ``LICENSE`` file represents the current best practices from the
   Canonical legal team for the specific project you intend to release. We use
   LGPL v3 for libraries, and GPL v3 for apps.
#. Rename any files or directories and ensure references are updated.
#. Replace any instances of the word ``Starcraft`` with the product's name.
#. Place contact information in a code of conduct.
#. Rewrite the README.
#. If a Diataxis quadrant (tutorials, how-tos, references, explanations)
   doesn't yet have content, remove its landing page from the TOC and delete
   its card in ``docs/index.rst``. You can re-index it when at least one
   document has been produced for it.
#. Register the product's documentation on our custom domain on `Read the
   Docs for Business`_.

.. _EditorConfig: https://editorconfig.org/
.. _pre-commit: https://pre-commit.com/
.. _Read the Docs for Business: https://library.canonical.com/documentation/publish-on-read-the-docs
.. _use this template: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template
