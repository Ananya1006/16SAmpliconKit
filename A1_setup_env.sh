#!/bin/bash

CYAN="\033[1;36m"
RESET="\033[0m"

# Downloading Miniconda...
echo -e "${CYAN}Downloading Miniconda installer...${RESET}"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Installing Miniconda...
echo -e "${CYAN}Installing Miniconda and adding to path...${RESET}"
bash Miniconda3-latest-Linux-x86_64.sh -b -u -p "$HOME/miniconda3"
export PATH="$HOME/miniconda3/bin:$PATH"   
rm Miniconda3-latest-Linux-x86_64.sh

# Shell integration (only once needed)
echo -e "${CYAN}Initializing conda shell...${RESET}"
conda init bash     

# Refresh shell
source ~/.bashrc

# Installing Mamba...
echo -e "${CYAN}Installing Mamba from conda-forge...${RESET}"
conda install -y -c conda-forge mamba

# Set up .condarc
echo -e "${CYAN}Setting up .condarc with conda-forge and bioconda...${RESET}"
cat <<EOF > ~/.condarc
channels:
  - defaults
  - conda-forge
  - bioconda
channel_priority: strict
EOF

mamba shell init

echo -e "${CYAN}Done!${RESET}"
echo -e "${CYAN}Setting up environments...${RESET}"

# Creating environment for sra-tools...
echo -e "${CYAN}Creating environment sra for sra-tools...${RESET}"
#conda create -n sra -y sra-tools
mamba create -n sra -c bioconda -c conda-forge -y sra-tools=3.2.1

# Creating environment for QC tools...
echo -e "${CYAN}Creating environment qc for data quality check...${RESET}"
mamba create -n qc -y fastqc multiqc bbmap trimmomatic

# Creating environment for QIIME2...
echo -e "${CYAN}Creating environment qiime2 for amplicon data analysis...${RESET}"
conda config --set channel_priority flexible
conda env create -n qiime2 --file https://data.qiime2.org/distro/amplicon/qiime2-amplicon-2024.10-py310-linux-conda.yml

# Creating environment for Snakemake...
echo -e "${CYAN}Creating environment snakemake...${RESET}"
conda create -n snakemake_env python=3.10 -y
conda install -n snakemake_env -c conda-forge snakemake -y

echo -e "${CYAN}Setup complete!${RESET}"
echo -e "${CYAN}Activate an environment using: mamba activate env_name${RESET}"
echo -e "${CYAN}Deactivate with: mamba deactivate${RESET}"
