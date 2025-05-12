## Additional Information

This section provides important technical details, conventions, and resources to help ensure smooth execution of the `16SAmpliconKit` pipeline.

### 1. Primer Format (Regular expression based)

Ensure that primer sequences are written using **regular expressions** that match degenerate bases (IUPAC codes). For example:

- **V4 region (default)**  
  - Forward primer: `TAC[ACT][ACG]GGGT[AT]TCTAATCC`  
  - Reverse primer: `GTG[CT]CAGC[AC]GCCGCGGTAA`

Use square brackets (`[ ]`) for degenerate bases. Refer to [IUPAC nucleotide codes](https://www.bioinformatics.org/sms/iupac.html) for guidance.

### 2. Naming Requirements

- **BioProject folder names** must start with `PRJNA` followed by digits, e.g., `PRJNA123456`.
- **Sample file names** must begin with `SRR`, e.g., `SRR12345678_1.fastq.gz`.

> ⚠️ These naming conventions are critical for correct folder detection and automated Snakefile generation.

If you encounter issues during pipeline execution, consider the following common areas:

### 3. Snakemake Errors

- Make sure **Snakemake is installed** (v7 or above is recommended).
- Validate the Snakefile for missing variables (usually primer or file path issues).
- Use a dry run to preview workflow steps without execution:

```bash
snakemake -s Snakefile --dry-run
```
Official documentation : https://snakemake.readthedocs.io/

### 4. QIIME 2 Errors
Ensure QIIME 2 is installed and correctly activated.
Confirm with:
```
qiime info
```
Official Documentation: https://docs.qiime2.org/

### 5. Taxonomic Classifiers 
Classifiers were trained using SILVA version 138.1 (the database version) with QIIME 2 feature-classifier plugin,

