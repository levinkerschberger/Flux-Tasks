#!/bin/bash

read -rp "Enter the organization, in which you want to import your tasks: " org

while [[ -z "$org" ]]; do
    echo "Organization name cannot be empty!"
    read -rp "Enter the organization parameter: " org
done

folder=${1:-$PWD}

for file in $(find "$folder" -name '*.task'); do
    echo "Creating task for $(basename "$file")..."
    influx task create --org "$org" -f "$file"
done

echo "All tasks created."