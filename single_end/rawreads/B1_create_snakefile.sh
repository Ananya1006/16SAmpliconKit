#!/bin/bash
CYAN="\033[1;36m"
RESET="\033[0m"

for prj_folder in PRJNA*; do
    if [[ -d "$prj_folder" ]]; then
        echo -e "${CYAN}Processing $prj_folder...creating Snakefile in $prj_folder${RESET}"

        samples=($(ls "$prj_folder"/*.fastq.gz | sed -E 's#.*/(SRR[0-9]+).*#\1#' | sort -u))
        snakefile="$prj_folder/Snakefile"

        cat > "$snakefile" <<EOL
samples = [$(printf '"%s", ' "${samples[@]}" | sed 's/, $//')]

# Define primer
forward_primer = "GTG[CT]CAGC[AC]GCCGCGGTAA"

EOL

        cat >> "$snakefile" <<'EOL'

rule all:
    input:
        expand("qc_1/{sample}_fastqc.html", sample=samples),
        expand("trim/{sample}.fastq.gz", sample=samples),
        "demux.qza", "demux.qzv", "repseqs.qza",
        "feature_table.qza", "dada2_stats.qza",
        "table.qzv", "repseqs.qzv",
        "rooted_tree.qza", "aligned-rep-seqs.qza",
        "masked-aligned-rep-seqs.qza",
        "unrooted-tree.qza", "rooted_tree.qza",
        "taxonomy.qza", "taxonomy.qzv"

rule create_qc1_directory:
    output:
        directory("qc_1")
    run:
        import os
        os.makedirs("qc_1", exist_ok=True)

rule fastqc1:
    input:
        R1 = "{sample}.fastq.gz"
    output:
        "qc_1/{sample}_fastqc.html"
    shell:
        "mamba run -n qc fastqc {input.R1} --outdir qc_1/"

rule bbduk_adapter_qual:
    input:
        adapters = "../../../adapters.fa",
        f = "{sample}.fastq.gz"
    output:
        "trim/{sample}_trim.fastq.gz"
    shell:
        "mamba run -n qc bbduk.sh in={input.f} out={output} \
        ref={input.adapters} ktrim=r k=23 qtrim=rl trimq=20 mink=11 hdist=1"

rule bbduk_primer_removal:
    input:
        f = "trim/{sample}_trim.fastq.gz"
    output:
        "trim/{sample}.fastq.gz"
    params:
        forward_primer = forward_primer
    shell:
        "mamba run -n qc bbduk.sh in={input.f} out={output} \
         literal={params.forward_primer} copyundefined k=16 mink=7 \
         ktrim=l hdist=1 ignorejunk"

rule create_manifest:
    output:
        "manifest.tsv"
    run:
        with open(output[0], "w") as f:
            f.write("sample-id\tabsolute-filepath\n")
            for sample in samples:
                f.write(f"{sample}\t$PWD/trim/{sample}.fastq.gz\n")

rule import_qza:
    input:
        "manifest.tsv"
    output:
        "demux.qza"
    shell:
        "mamba run -n qiime2 qiime tools import --type 'SampleData[SequencesWithQuality]' \
        --input-path {input} --output-path {output} --input-format SingleEndFastqManifestPhred33V2"

rule summarize_demux:
    input:
        "demux.qza"
    output:
        "demux.qzv"
    shell:
        "mamba run -n qiime2 qiime demux summarize --i-data {input} --o-visualization {output}"

rule dada2:
    input:
        "demux.qza"
    output:
        "repseqs.qza",
        "feature_table.qza",
        "dada2_stats.qza"
    shell:
        "mamba run -n qiime2 qiime dada2 denoise-single --i-demultiplexed-seqs {input} \
        --p-trunc-len 0 --p-n-threads 20 \
        --o-representative-sequences {output[0]} \
        --o-table {output[1]} --o-denoising-stats {output[2]}"

rule summary_table_dada2:
    input:
        "feature_table.qza"
    output:
        "table.qzv"
    shell:
        "mamba run -n qiime2 qiime feature-table summarize --i-table {input} --o-visualization {output}"

rule summary_repseq_dada2:
    input:
        "repseqs.qza"
    output:
        "repseqs.qzv"
    shell:
        "mamba run -n qiime2 qiime feature-table tabulate-seqs --i-data {input} --o-visualization {output}"

rule phylogeny:
    input:
        "repseqs.qza"
    output:
        alignment="aligned-rep-seqs.qza",
        masked_alignment="masked-aligned-rep-seqs.qza",
        tree="unrooted-tree.qza",
        rooted_tree="rooted_tree.qza"
    shell:
        "mamba run -n qiime2 qiime phylogeny align-to-tree-mafft-fasttree \
            --i-sequences {input} \
            --o-alignment {output.alignment} \
            --o-masked-alignment {output.masked_alignment} \
            --o-tree {output.tree} \
            --o-rooted-tree {output.rooted_tree}"

rule taxonomy:
    input:
        classifier = "../../../classifiers/silva138.1_AB_V4_classifier.qza",
        repseqs = "repseqs.qza"
    output:
        "taxonomy.qza"
    shell:
        "mamba run -n qiime2 qiime feature-classifier classify-sklearn \
        --i-classifier {input.classifier} \
        --i-reads {input.repseqs} \
        --o-classification {output} \
        --p-n-jobs 8"

rule tabulate_taxonomy:
    input:
        "taxonomy.qza"
    output:
        "taxonomy.qzv"
    shell:
        "mamba run -n qiime2 qiime metadata tabulate \
        --m-input-file {input} \
        --o-visualization {output}"
EOL

    fi
done
echo -e "${CYAN}Done!${RESET}"
