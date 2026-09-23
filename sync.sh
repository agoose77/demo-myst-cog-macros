#!/usr/bin/env bash
set -eu
shopt -s globstar

script=$(cat <<- 'EOF'
import cog
import pathlib
import yaml

directory = pathlib.Path(cog.inFile).parent
while not (directory / "myst.yml").exists():
    last_directory, directory = directory, directory.parent
    if last_directory == directory:
        cog.error("Couldn't find myst.yml")

with open(directory / "myst.yml") as f:
    config = yaml.safe_load(f)

math = config.get("project", {}).get("math", {})
math_only_config = {"math": math}
for line in yaml.dump(math_only_config).splitlines():
    cog.outl(line)
EOF
)
cog -p "${script}" -r "$@"
