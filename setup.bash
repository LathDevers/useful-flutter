#!/bin/bash

# This script creates the git ORIG_HEAD file.
# Clones Flutter in the Documents folder.
# Updates the PATH environment variable.
# Accepts Android Licenses.
# Installs Cocoapods on macOS using Homebrew.
# Runs flutter doctor.

# Check the current operating system
os_type=$(uname)

# Create git ORIG_HEAD file
file_path="./.git/ORIG_HEAD"
if [ -e "$file_path" ]; then
  echo "File $file_path already exists."
else
  # Use the echo command to write the content to the file
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" > "$file_path"

  # Check if the file was created successfully
  if [ -e "$file_path" ]; then
    echo "File $file_path created."
  else
    echo "ERROR: File $file_path creation failed!"
  fi
fi

# Clone Flutter
current_dir=$(pwd)
if [ "$(uname)" == "Darwin" ]; then
  # macOS
  documents_dir="$HOME/Documents"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 9)" == "MINGW64_NT" ]; then
  # Windows
  documents_dir="$USERPROFILE/Documents"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  documents_dir="$HOME/Documents"
else
  echo "ERROR: Unsupported OS."
  exit 1
fi
flutter_bin_path="$documents_dir/flutter/bin"
cd "$documents_dir"
git clone https://github.com/flutter/flutter.git -b stable
cd "$current_dir"

# Update PATH
if [ "$os_type" == "Darwin" ]; then
  export PATH="$PATH:$flutter_bin_path"
  echo $PATH
  which_flutter=$(which flutter)
  if [ -z "$which_flutter" ]; then
    echo "ERROR: Flutter path export failed!"
  fi
elif [ "$OS" == "Windows_NT" ]; then
  # Check if the 'Path' variable already exists
  if [ -z "$Path" ]; then
    setx Path "$flutter_bin_path"
  else
    setx Path "$Path;$flutter_bin_path"
  fi

  echo "Flutter 'bin' directory added to the 'Path' environment variable."
fi

# Accept Android Licenses
yes | flutter doctor --android-licenses

# Install Cocoapods on macOS using Homebrew
if [ "$os_type" == "Darwin" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if ! command -v brew &> /dev/null; then
    echo "Homebrew could not be installed."
    exit 1
  fi

  if ! command -v pod &> /dev/null; then
    brew install cocoapods
    echo "Cocoapods has been installed."
  else
    echo "Cocoapods is already installed."
  fi
fi

# Run flutter doctor
flutter doctor