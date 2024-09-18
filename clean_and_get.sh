#!/bin/bash

# Save the current directory
original_dir=$(pwd)

# Navigate to the "packages" folder
cd packages || exit

# Search for subfolders inside "packages" and run "flutter clean" in each
for package_dir in */; do
    if [ -d "$package_dir" ]; then
        echo "Entering $package_dir and executing 'flutter clean'"
        
        # Enter each subfolder (except 'build') and run "flutter clean"
        cd "$package_dir" || exit
        if [ "$package_dir" != "build/" ]; then
            flutter clean > /dev/null 2>&1
        fi

        # Return to the "packages" directory
        cd "$original_dir/packages" || exit
    fi
done

# Return to the original directory
cd "$original_dir" || exit

echo "Executing 'flutter clean' in the root directory"
# Run "flutter clean" in the root directory
flutter clean > /dev/null 2>&1

# Run "flutter pub get" in each subfolder of "packages" (except 'build')
for package_dir in packages/*/; do
    if [ -d "$package_dir" ] && [ "$package_dir" != "packages/build/" ]; then
        echo "Entering $package_dir and executing 'flutter pub get'"
        flutter pub get > /dev/null 2>&1
    fi
done

echo "Executing 'flutter pub get' in the root directory"
# Run "flutter pub get" in the root directory
flutter pub get

echo "Script completed successfully."
