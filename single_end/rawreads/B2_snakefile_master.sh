#!/bin/bash

# Change directory to the root folder 
#path to rawreads folder
eval "$(mamba shell hook --shell bash)"
mamba activate snakemake_env
# Loop through each folder
for prjna_folder in PRJNA*/; do
    # Check if the folder contains a snakefile_main
    if [ -f "$prjna_folder/Snakefile" ]; then
        echo "Running Snakemake in $prjna_folder"
        # Change directory to the PRJNA folder
        cd "$prjna_folder"
        
        # Run Snakemake
        snakemake -s Snakefile --cores 10
        
        # Move back to the root folder
        cd ..
    else
        echo "No snakefile_main found in $prjna_folder"
    fi
done

