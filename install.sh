#!/bin/bash

# Define repository and local paths (assume $GITDIR already exists)
                GITDIR=~/gitdir
           GITHUB_REPO="https://github.com/philipprochazka/fonts.git"
LOCAL_FONT_SOURCE_PATH="$GITDIR/fonts"

# Destination paths for user-specific or system-wide installation
  USER_FONT_FOLDER="$HOME/.local/share/fonts"
SYSTEM_FONT_FOLDER="/usr/share/fonts"

# Check if the font source directory exists; if not, clone the GitHub repo
if [ ! -d "$LOCAL_FONT_SOURCE_PATH" ]; then
    echo "Local font source directory not found. Cloning from GitHub..."
    git clone "$GITHUB_REPO" "$LOCAL_FONT_SOURCE_PATH"
    echo "Fonts cloned to $LOCAL_FONT_SOURCE_PATH."
else
    echo "Local font source directory found at $LOCAL_FONT_SOURCE_PATH."
fi

# Check if the user font folder exists
if [ ! -d "$USER_FONT_FOLDER" ]; then
    echo "No user font folder detected."
    echo "Select one of the following options:"
    echo "1. Create the user font folder and install fonts there."
    echo "2. Install fonts system-wide (requires sudo privileges)."
    read -p "Enter your choice (1 or 2): " user_choice

    if [ "$user_choice" -eq 1 ]; then
        # Create the user font folder and set it as destination
        mkdir -p "$USER_FONT_FOLDER"
        echo "User font folder created at $USER_FONT_FOLDER."
        DESTINATION_FOLDER="$USER_FONT_FOLDER"
    elif [ "$user_choice" -eq 2 ]; then
        # Use the system-wide font folder (requires sudo)
        DESTINATION_FOLDER="$SYSTEM_FONT_FOLDER"
        sudo mkdir -p "$DESTINATION_FOLDER"
        echo "System-wide font folder selected at $DESTINATION_FOLDER."
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi
else
    # If the user font folder exists, use it as the destination
    DESTINATION_FOLDER="$USER_FONT_FOLDER"
fi

# Find and copy .ttf and .otf fonts from local git repository to destination
echo "Copying fonts from $LOCAL_FONT_SOURCE_PATH to $DESTINATION_FOLDER..."
find "$LOCAL_FONT_SOURCE_PATH" -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp {} "$DESTINATION_FOLDER" \;

# Update the font cache
fc-cache -f -v

echo "Fonts installed successfully in $DESTINATION_FOLDER."
