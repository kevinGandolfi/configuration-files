#!/bin/bash

set -e  # Stop on error

DOTFILES_DIR="$HOME/repositories/configuration-files/dotfiles"

# Create required directories
mkdir -p "$HOME/.config/nvim"

# List of files/directories to link
declare -A LINKS=(
  [".bashrc"]="$HOME/.bashrc"
  [".editorconfig"]="$HOME/.editorconfig"
  ["init.lua"]="$HOME/.config/nvim/init.lua"
  ["lua"]="$HOME/.config/nvim/lua"
)

# Loop over all links
for source_name in "${!LINKS[@]}"; do
  source_path="$DOTFILES_DIR/$source_name"
  target_path="${LINKS[$source_name]}"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    echo "Removing existing: $target_path"
    rm -rf "$target_path"
  fi

  echo "Linking $source_path -> $target_path"
  ln -s "$source_path" "$target_path"
done

echo "✅ All dotfiles linked successfully."
