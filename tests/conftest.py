# Copyright 2023 Canonical Ltd.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License version 3, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranties of MERCHANTABILITY,
# SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
import types

import pytest


@pytest.fixture
def project_main_module() -> types.ModuleType:
    """Fixture that returns the project's principal package (imported)."""
    try:
        # This should be the project's main package; downstream projects must update this.
        import debcraft

        main_module = debcraft
    except ImportError:
        pytest.fail(
            "Failed to import the project's main module: check if it needs updating",
        )
    return main_module
