#!/usr/bin/env python
from enum import Enum, member
from pathlib import Path
import os
import shutil
import subprocess


class Installer(Enum):
    @member
    @staticmethod
    def default(src: Path, dst: Path) -> None:
        _ = shutil.copyfile(src, dst, follow_symlinks=False)
        shutil.copystat(src, dst, follow_symlinks=False)

    @member
    @staticmethod
    def fennel(src: Path, dst: Path) -> None:
        with dst.open(mode="x") as output:
            subprocess.run(
                ["fennel", "--globals", "vim,_G", "--correlate", "--compile", src],
                stdout=output,
            ).check_returncode()
        shutil.copystat(src, dst, follow_symlinks=False)

    @member
    @staticmethod
    def directory(src: Path, dst: Path) -> None:
        mode = src.lstat().st_mode
        dst.mkdir(mode, exist_ok=True)

    def __call__(self, src: Path, dst: Path) -> None:
        return self.value(src, dst)


def run(src: Path, dst: Path) -> None:
    stack = [src]
    while stack:
        source: Path = stack.pop()
        path = source.relative_to(src)
        print(path)

        target = dst
        for parent in path.parts:
            target /= parent if str(parent) != "fnl" else "lua"

        install: Installer
        if source.is_dir():
            stack += source.iterdir()
            install = Installer.directory
        elif target.suffix == ".fnl":
            target = target.with_suffix(".lua")
            install = Installer.fennel
        else:
            install = Installer.default

        install(source, target)


def main():
    root = Path(__file__).parent
    os.chdir(root)

    run(root / "src", root / "out")


if __name__ == "__main__":
    main()
