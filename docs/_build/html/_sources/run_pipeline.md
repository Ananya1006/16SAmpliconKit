# Running the Pipeline 

After successfully downloading your raw sequencing data, follow these steps to run the pipeline using Snakemake. 

### Step 1: Navigate to the rawreads/ directory based on data type
Once the raw reads are downloaded, navigate to the `rawreads/` directory. Based on whether you are using **paired-end** or **single-end** data, go to the appropriate directory:
```
cd paired_end/rawreads/ (for paired-end data)
```
or
```
cd single_end/rawreads/ (for single-end data)
```
### Step 2: Update the primer sequence based on the amplicon region
Modify the B1_create_snakefile.sh script and add the correct primer sequence relevant to your dataset.
- The default primer used in the scripts is designed for the V4 region of the 16S rRNA gene (515F/806R).
- This primer is relevant to the example dataset provided in the `test_data/` folder, as well as the sample SRR IDs mentioned in the scripts under both `paired_end/` and `single_end/` directories.
- Modify the below section in the script to the primer sequence suited to your data
```
# Define primers
forward_primer = "TAC[ACT][ACG]GGGT[AT]TCTAATCC"
reverse_primer = "GTG[CT]CAGC[AC]GCCGCGGTAA"
```
### Step 3: Make the Scripts Executable
```
chmod +x *.sh
```

### Step 4: Auto-Generate Snakefiles for Each BioProject
- Run the `B1_create_snakefile.sh` script to generate a custom Snakefile in each project directory based on the present SRR IDs. 
- This automatically detects the SRR IDs and adds an array in the generated Snakefile, which is then used to dynamically build Snakemake rules for each sample.
- This step ensures that all the downloaded samples are correctly registered and processed in subsequent steps of the pipeline without the need to manually edit.

```
bash B1_create_snakefile.sh
```
### Step 5: Execute the Snakefile in each folder
Once the Snakefile has been generated using the `B1_create_snakefile.sh` script, you can proceed to execute the full Snakemake workflow by running the master script from the rawreads directory.

```
bash B2_snakefile_master.sh
```
This master script runs a complete 16S amplicon processing pipeline, which includes:
- Quality control of raw reads using FastQC
- Adapter and primer trimming using BBDuk
- Importing and demultiplexing reads in QIIME 2
- Denoising and ASV inference via DADA2
- Taxonomic classification using a pre trained SILVA classifier
- Phylogenetic tree construction
- Generation of summary visualizations (.qzv files) for downstream analysis

All intermediate and final outputs are organized in structured directories for easy access.




