## Directory Structure Overview

Here’s the directory structure of the `16SAmpliconKit` repository to help you understand where each script and data resides:

```
16SAmpliconKit/
│
├── A1_setup_env.sh                  # Script to create and configure the conda environment
├── test_data/                       # Example test dataset and Snakefile
│   ├── Snakefile
│   ├── SRR13686819_1.fastq.gz
│   ├── SRR13686819_2.fastq.gz
│
├── classifiers/                     # QIIME 2-compatible SILVA trained classifiers 
│
├── adapters.fa                      # List of Adapter sequences for trimming
│
├── paired_end/                      # Pipeline scripts and data structure for paired-end reads
│   ├── A2_fetch_paired_data.sh      # Script to fetch SRA data for paired-end samples
│   ├── rawreads/
│   │   ├── B1_create_snakefile.sh   # Script to generate Snakemake rules
│   │   ├── B2_snakefile_master.sh   # Master script to run the Snakemake pipeline
│   └── ...                          # Outputs and intermediate files will be stored here
│
├── single_end/                      # Equivalent structure for single-end read processing
│   ├── A2_fetch_singlend_data.sh
│   ├── rawreads/
│   │   ├── B1_create_snakefile.sh
│   │   ├── B2_snakefile_master.sh
│   └── ...
│
└── README.md                        # Overview and usage instructions
```
