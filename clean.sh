#!/bin/bash

# Save the current directory
original_dir=$(pwd)
lock_file="pubspec.lock"

# Clean in root directory

flutter clean > /dev/null 2>&1
rm "build"
rm -rf ios/Pods ios/Podfile.lock

if [ -e "packages/" ]; then
    cd packages || exit
    packages_dir=$(pwd)
    # Search for subfolders inside "packages" and run "flutter clean" in each
    for package_dir in */; do
        if [ -d "$package_dir" ]; then
            echo "Entering $package_dir and executing 'flutter clean'"
            
            # Enter each subfolder (except 'build') and run "flutter clean"
            cd "$package_dir" || exit
            if [ "$package_dir" != "build/" ]; then
                flutter clean > /dev/null 2>&1
            fi

            if [ -e "$lock_file" ]; then
                rm "$lock_file"
                echo "Deleted $lock_file"
            fi

            # Return to the "packages" directory
            cd "$packages_dir" || exit
        fi
    done
fi

echo "Script completed successfully."
