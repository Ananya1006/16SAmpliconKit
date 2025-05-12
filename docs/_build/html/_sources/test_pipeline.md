# Testing the installation on a example dataset

After completing the setup and installation of the Conda environment using `A1_setup_env.sh`, you can verify that everything is working by running the pipeline on the provided test dataset.

### Step 1: Navigate to the `test_data` Directory

The `test_data/` directory contains:
- Sample paired-end FASTQ files: `SRR13686819_1.fastq.gz` and `SRR13686819_2.fastq.gz`
- A pre-written `Snakefile` to test functionality
From the root of the repository, run:
```
cd test_data/
```
### Step 2: Activate the snakemake environment and execute the Snakefile
```
conda activate snakemake_env
snakemake -s Snakefile --cores 4 (You can increase the number depending on available CPU cores)
```
This will perform the following steps on the test dataset:
- Perform basic quality control
- Trim adapters and primers
- Generate preliminary outputs to verify that tools are working as expected

After successful execution, check for output files in the test_data/ directory. If no errors occur, your setup is working correctly, and you are ready to run the pipeline with your own datasets. 