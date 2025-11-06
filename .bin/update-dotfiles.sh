#!/bin/sh

# Sync dotfiles repo and ensure that dotfiles are tangled correctly afterward

BRANCH="main"

GREEN='\033[1;32m'
BLUE='\033[1;34m'
RED='\033[1;30m'
NC='\033[0m'

# Navigate to the directory of this script (generally ~/.dotfiles/.bin)
cd $(dirname $(readlink -f $0))
cd ..

echo -e "${BLUE}Adding all files to git...${NC}"
git add .

echo -e "${BLUE}Committing updates to repo...${NC}"
echo
git commit -m "Update dotfiles"
git push origin $BRANCH
echo


# Run stow to ensure all new dotfiles are linked
stow -vt ~ */
