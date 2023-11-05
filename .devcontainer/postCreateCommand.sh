#! /bin/bash

# Specify a folder for hooks (only available for git version >= 2.9)
git config core.hooksPath .githooks

# Auto-create missing upstream branch
git config push.autoSetupRemote true
