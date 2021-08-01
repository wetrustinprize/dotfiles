#!/usr/bin/ python3

from pathlib import Path

from os import listdir, unlink
from os.path import abspath, exists, isdir, islink, basename, dirname

def get_to(f: str) -> str:
    is_dotfile = "dotfiles/" in f

    bname = ("." if is_dotfile else "") + basename(f)
    dname = str(dirname(f)).replace("configs", ".config").replace("dotfiles", "")
    fname = dname + ("/" if dname != "" else "") + bname

    home_path = str(Path.home())

    final_path = home_path + "/" + fname
    return final_path

to_link = [{
    "from": abspath(path),
    "to": get_to(path),
    "dir": isdir(path)
} for path in ["dotfiles/" + f for f in listdir("dotfiles/")] + ["configs/" + f for f in listdir("configs/")]]

for link in to_link:
    if islink(link["to"]):
        print("File already exists in link path, removing.")
        unlink(link["to"])

    p = Path(link["to"])
    p.symlink_to(link["from"], link["dir"])