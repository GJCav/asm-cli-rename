#!/bin/bash

# Create a lot of files for testing

for i in {1..40} ; do
    echo "Creating file $i" > file_$i.txt
done