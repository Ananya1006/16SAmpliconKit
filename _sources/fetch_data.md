# Fetching Your Own Data

This guide explains how to fetch your own sequencing data and run the 16SAmpliconKit on it. Both paired-end and single-end sequencing data layouts are supported by 16SAmpliconKit. 

#### Step 1: Choose Paired-End or Single-End Data

- If you're working with **paired-end data**, use the `A2_fetch_paired_data.sh` script located in the `paired_end/` directory.
- If you're working with **single-end data**, use the `A2_fetch_singlend_data.sh` script located in the `single_end/` directory.

#### Step 2: Editing the Fetch Script: Add Your BioProject and Sample IDs

You need to specify the BioProject ID starting with "PRJNA" and sample IDs with "SRR" in the fetch script. Edit the `A2_fetch_paired_data.sh` or `A2_fetch_singlend_data.sh` file to include your BioProject IDs and corresponding SRR IDs, using any text editors like nano or vim, or notepad. 

(You can add multiple BioProjects and samples of same hypervariable region)

Here’s an example of how to define the BioProject and SRR IDs:

```
# Define associative array with BioProjects and SRR IDs : 
Example --> ["BioprojectID_samplesno."]="SRRID1 SRRID2 ....."
BIOPROJECTS=(
      ["PRJNA701402_1"]="SRR13686819"
      ["PRJNA1232715_1"]="SRR32595386"
)
```
#### Step 3: Make the Script Executable
```
chmod +x A2_fetch_paired_data.sh
or
chmod +x A2_fetch_singlend_data.sh
```

#### Step 4: Run the Script to Download Raw Reads
```
bash A2_fetch_paired_data.sh
```

This will create a rawreads/ folder inside the paired_end/ or single_end/ directory, with subdirectories for each BioProject. Each BioProject folder will contain SRR ID folders that have the raw sequencing data files.