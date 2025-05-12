# Installation

Follow these steps to set up the environment and required tools.

#### Step 1: Clone the repository

```bash
git clone https://github.com/Ananya1006/16SAmpliconKit.git
cd 16SAmpliconKit
```
#### Step 2: Make the scripts executable
``` 
chmod +x *.sh
```
#### Step 3: Set up the conda environment and install tools
```
bash A1_setup_env.sh
```
The setup script will automatically create and configure multiple conda environments required for different stages of the 16S amplicon sequencing pipeline. These include:
- qc for quality control tools (e.g., fastQC, multiQC, BBTools, trimmomatic)
- sra for downloading sequencing data (e.g., sra-tools)
- qiime2 for 16S rRNA data analysis (e.g., QIIME2)
- snakemake_env for workflow execution using Snakemake and Python

After successful setup, a confirmation message will be printed.

