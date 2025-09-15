# Bulk RNA-seq: STAR + RSEM (hg38, GENCODE v48 & v45) on SLURM
This repository provides a clean, reproducible pipeline to:

download references (hg38 + GENCODE),

build STAR & RSEM references (versioned),

align paired-end FASTQs with STAR and quantify with RSEM,

generate per-sample results and merged matrices for downstream analysis in R.

It’s designed for an HPC cluster with SLURM (e.g., LMU BMC slim16), but the scripts are portable.

Why these choices?

STAR is fast and accurate for spliced alignments. We use --quantMode TranscriptomeSAM so RSEM can quantify reads in transcript coordinates reliably.

RSEM performs robust transcript/gene quantification (expected counts, TPM) and is widely used in bulk RNA-seq.

Versioned references (v48 & v45): annotation updates can affect gene IDs/symbols and quantification. Keeping separate STAR/RSEM references per GENCODE version and writing outputs to version-tagged folders lets you compare runs without overwriting or mixing results.

sjdbOverhang = readLength-1: STAR’s splice junction annotation works best if you set overhang to typical read length minus one (e.g., 149 for 150bp reads).

Repository layout
bulk-rnaseq-star-rsem/
├─ README.md                      # this file
├─ config.sh                      # defaults (copy to config.local.sh and edit)
├─ scripts/
│  ├─ 1_Genome_Indexing_STAR.sh          # build STAR index (v48 or v45 via config)
│  ├─ 1b_RSEM_PrepareReference.sh        # build RSEM reference (v48 or v45 via config)
│  ├─ 3_STAR_RSEM_Paired.sh              # run STAR+RSEM (version-tagged outputs)
│  ├─ 4_make_samplesheet.sh              # generate metadata skeleton from rsem/<sample>/
│  ├─ 5_import_rsem_genelevel.R          # build counts/TPM matrices (gene-level)
│  └─ 5_import_tximport.R                # tximport route from isoforms → genes (DESeq2)
├─ .gitignore
└─ (runtime dirs created later, not tracked)
   ├─ genome/
   ├─ mapping_transcriptome_*version*/
   └─ rsem_*version*/

Requirements

SLURM (for sbatch)
STAR ≥ 2.7 and RSEM ≥ 1.3
(module names used here: ngs/STAR/2.7.1a, ngs/RSEM/1.3.0)

Optional for QC/visualization: samtools, deeptools, multiqc

R (for downstream), with packages: tidyverse, tximport, DESeq2, biomaRt (or parse GTF locally)
