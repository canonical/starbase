# This file is part of starcraft.
#
# Copyright 2026 Canonical Ltd.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranties of MERCHANTABILITY,
# SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
"""Basic tests for Starbase version attributes."""

import re

import pytest
import starcraft


@pytest.fixture
def get_major_minor_version():
    """Fixture function that duplicates version trimming in docs/conf.py."""

    def _trim(version):
        expression = re.compile(r"\d+\.\d+")

        return expression.match(version).group()

    return _trim


def test_version():
    """Test that the version attribute is generating."""
    assert starcraft.__version__ is not None


@pytest.mark.parametrize(
    "version,major_minor",  # NOQA: PT006
    [
        ("9.0.0", "9.0"),  # Tagged
        ("9.0.0-23-gc2a9d6349", "9.0"),  # Tagged + new commits
        ("0.0.post836+g494e37055.d20260612", "0.0"),  # Untagged
    ],
)
def test_version_tagged(version, major_minor, get_major_minor_version):
    """Test the version-to-major-minor function."""
    assert get_major_minor_version(version) == major_minor
