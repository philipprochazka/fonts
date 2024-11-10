#!/bin/bash

# Define the remote font repository URL and user/system destination folders
GITHUB_REPO_URL="https://github.com/philipprochazka/fonts"
USER_FONT_FOLDER="$HOME/.local/share/fonts"
SYSTEM_FONT_FOLDER="/usr/share/fonts"

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

# List of font files to download (update with specific paths in the GitHub repo)
FONT_FILES=(
    "path/to/font1.ttf"
    "path/to/font2.otf"
    # Add more paths to fonts as needed
)

# Download each font file from the GitHub repository to the destination folder
for font_file in "${FONT_FILES[@]}"; do
    font_url="$GITHUB_REPO_URL/raw/main/$font_file"
    dest_file="$DESTINATION_FOLDER/$(basename $font_file)"
    echo "Downloading $font_url to $dest_file..."
    curl -L -o "$dest_file" "$font_url"
done

# Update the font cache
fc-cache -f -v

echo "Fonts installed successfully in $DESTINATION_FOLDER."
