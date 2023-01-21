**************
starcraft-base
**************

A base repository for Starcraft projects.

Description
-----------
This project is designed to act as the basis for any future starcraft projects as well as a testbed for any tooling changes we want to make before merging them into other projects.

Structure
---------
TODO

How to migrate existing projects
--------------------------------
TODO

How to create a new project
---------------------------
I will eventually turn this into a template repository from which you can fork. The important steps to remember even after that are:

1. Ensure the ``LICENSE`` file represents the current best practices from the Canonical legal team for the specific project you intend to release.
2. Rename any files or directories and ensure references are updated.
3. Write a new README!

Outstanding questions for the team
----------------------------------
These are questions I'd like answered before I complete my PR, so the goal is to end up with an empty list here.

0. Does anyone want anything else added/changed here? I tried to keep this only to what we currently do or appear to be moving towards, but I may have missed things (or we may be moving away from something and I got the directionality wrong). If there's something uncontroversial to add, I'm happy to do so.

1. I see the Contributor Covenant v1.4 on most (though not all) of our projects, so I mirrored that. The questions are:
    a. Should I mention the Ubuntu code of conduct too, or does it not apply here?
    b. Is v1.4 the correct version? (There's a 2.0 and a 2.1 now, but we're not using "or later" clauses on copyrights, so I don't know if there's a policy about it and haven't been able to find one so far.)

2. I remember hearing somewhere in my onboarding that Canonical had standardised on rST. Should I convert the contributor covenant over? Does our team do something different?

3. We don't use it anywhere as far as I can tell, but what are people's opinions on setting up pre-commit_ for running black and ruff? (I wouldn't want to force it to re-run tests or other slow processes, but I've made pre-commit hooks for myself to run black and ruff in autofix mode.) I haven't included it, but if it's unanimously popular I will. If anyone doesn't want it though, I'm going to leave it out for the moment, but I'll be happy to share my hooks with anyone who wants.

4. One thing I did add that we don't seem to use is an EditorConfig_ file.
   It shouldn't get in anyone's way, but it will mean that many text editors will automatically (or `with a plugin <https://github.com/editorconfig/editorconfig-vim#readme>`_) conform to our code format even if the user's default settings otherwise don't.

5. I've included black, ruff, pyright, codespell and shellcheck. Not included are mypy, pylint, isort and docstyle. Mypy seems redundant with pyright, and ruff implements the checks from pylint, isort and docstyle. I don't object to adding them - I just didn't think it's necessary.

.. _EditorConfig: https://editorconfig.org/
.. _pre-commit: https://pre-commit.com/
