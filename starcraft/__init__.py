# This file is part of starcraft.
#
# Copyright 2023 Canonical Ltd.
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
"""Starcraft package demo."""
from typing import List, Optional, Any

try:
    from ._version import __version__
except ImportError:
    try:
        from importlib.metadata import version, PackageNotFoundError
        __version__ = version("starcraft")
    except PackageNotFoundError:
        __version__ = "dev"

__all__ = [
    "__version__",
]
