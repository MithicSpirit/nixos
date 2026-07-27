#!/usr/bin/env python
import os
import shutil
import subprocess  # noqa: S404
import sys
from enum import Enum, member
from pathlib import Path

IGNORE = frozenset({"flsproject.fnl"})


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
            try:
                _ = subprocess.run(
                    [  # noqa: S607
                        "fennel",
                        "--globals",
                        "vim,_G",
                        # "--correlate",
                        "--compile",
                        src,
                    ],
                    stdout=output,
                    check=True,
                )
            except subprocess.CalledProcessError as e:
                print(f"Compilation failed: {src}", file=sys.stderr)
                sys.exit(e.returncode)
        shutil.copystat(src, dst, follow_symlinks=False)

    @member
    @staticmethod
    def directory(src: Path, dst: Path) -> None:
        mode = src.lstat().st_mode
        dst.mkdir(mode, exist_ok=True)

    @member
    @staticmethod
    def ignore(src: Path, dst: Path) -> None:
        _ = src, dst

    def __call__(self, src: Path, dst: Path) -> None:
        return self.value(src, dst)


def run(src: Path, dst: Path) -> None:
    stack = [src]
    while stack:
        source = stack.pop()
        path = source.relative_to(src)

        target = Path()
        for parent in path.parts:
            target /= parent if str(parent) != "fnl" else "lua"

        install: Installer
        if str(path) in IGNORE:
            install = Installer.ignore
        elif source.is_dir():
            stack += source.iterdir()
            install = Installer.directory
        elif target.suffix == ".fnl":
            target = target.with_suffix(".lua")
            install = Installer.fennel
        else:
            install = Installer.default

        print(f"{path} -> {target} ({install.name})")

        install(source, dst / target)


def main() -> None:
    root = Path(__file__).parent
    os.chdir(root)

    run(root / "src", root / "out")


if __name__ == "__main__":
    main()
