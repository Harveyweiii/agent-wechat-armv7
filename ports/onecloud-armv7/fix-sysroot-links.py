#!/usr/bin/env python3
"""Make Debian armhf development-library links resolvable outside a chroot."""

import os
import sys
from pathlib import Path


sysroot = Path(sys.argv[1]).resolve()
library_dir = sysroot / "usr/lib/arm-linux-gnueabihf"
for link in library_dir.iterdir():
    if not link.is_symlink():
        continue
    target = os.readlink(link)
    if not target.startswith("/"):
        continue
    new_target = os.path.relpath(sysroot / target.lstrip("/"), link.parent)
    link.unlink()
    link.symlink_to(new_target)
    print(f"{link.name}: {target} -> {new_target}")
