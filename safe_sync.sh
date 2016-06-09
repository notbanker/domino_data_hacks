#!/usr/bin/env bash

# Create a code checkpoint before domino sync
# This is an extra layer of protection over version control.
# If the sync fails and somehow demands a reset or what-have-you, this might save you.
#
# To create a one-click sync on mac osx dock, do the following:
#     1. Make this executable
#     2. Rename it with .app extension
#     3. Drag into dock
#     4. Rename back to sync_lib.sh
#     5. In finder, right click on sync_lib.sh and "Get Info"
#     6. Under the "open with" dropdown, select the terminal application
# Unfortunately you'll have to repeat 5-6 every time you edit this file as your IDE will likely revert it.


# Usage:
#        sync_lib.sh <project>

declare -a dirs=("lib" )           # <---  Add to this list

USER=$(whoami)
src_dir=${1:-"/Users/$USER/project/lib"}
src_checkpoint_dir=${3:-"/Users/${USER}/project/lib_checkpoints"}


# 1. Make a copy of your code:
#                                       <label> <code_dir> <checkpoint_directory>
/bin/bash ${src_dir}/bash/checkpoint.sh "sync" "${src_dir}" "${src_checkpoint_dir}"   # <---- Assumes location of checkpoint.sh in /<src_dir>/bash/checkpoint.sh modify as needed


# 2. And only then sync
cd "${src_dir}"
domino sync || echo "Your sync failed somehow. If needed, you can retrieve code from ${src_checkpoint_dir}"
