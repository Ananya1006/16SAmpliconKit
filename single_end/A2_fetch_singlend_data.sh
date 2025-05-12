#!/bin/bash

CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}Initializing Conda...${RESET}"
eval "$($HOME/miniconda3/bin/conda shell.bash hook)"

# Activate environment with SRA Toolkit
conda activate sra || { echo -e "${CYAN}Failed to activate conda environment 'sra'. Exiting.${RESET}"; exit 1; }

# Optional: update sra-tools if needed
echo -e "${CYAN}Updating sra-tools...${RESET}"
conda update -y -c bioconda sra-tools

echo -e "${CYAN}Retrieving single-end data...${RESET}"

# Define associative array with BioProjects and SRR IDs for single-end data
declare -A BIOPROJECTS

BIOPROJECTS=(
	["PRJNA1093236_1"]="SRR28522796"
)

# Process each BioProject
for PROJECT in "${!BIOPROJECTS[@]}"; do
    echo -e "${CYAN}Processing BioProject: $PROJECT...${RESET}"

    mkdir -p "sra_prefetch/$PROJECT"

    for ID in ${BIOPROJECTS[$PROJECT]}; do
        echo -e "${CYAN}Downloading $ID...${RESET}"
        prefetch "$ID" --output-directory "sra_prefetch/$PROJECT"

        echo -e "${CYAN}Converting $ID to FASTQ...${RESET}"
        fasterq-dump "sra_prefetch/$PROJECT/$ID/$ID.sra" --outdir "rawreads/$PROJECT"

        echo -e "${CYAN}Compressing FASTQ files for $ID...${RESET}"
        gzip -f rawreads/"$PROJECT"/*.fastq 2>/dev/null

        echo -e "${CYAN}Completed processing for $ID in $PROJECT!${RESET}"
    done
done

echo -e "${CYAN}All single-end sequencing files have been downloaded and zipped!${RESET}"
