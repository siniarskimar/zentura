from pathlib import Path

def find_root_dir(scriptdir):
    root = scriptdir

    while root != scriptdir.root:
        if Path(root, ".git").exists():
            break
        root = root.parent

    if root == scriptdir.root:
        return None

    return root
 
