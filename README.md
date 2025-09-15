# Bulk RNA-seq: STAR + RSEM Pipeline (hg38, GENCODE v48 & v45)

This repository documents and shares a reproducible **STAR + RSEM pipeline** for bulk RNA-seq.  
It is designed for HPC clusters with SLURM but can be adapted for other systems.

- **STAR** → alignment (spliced reads, transcriptome BAMs for quantification)  
- **RSEM** → quantification (expected counts, TPM)  
- **GENCODE v48 & v45** → versioned references, separate output directories  

## Quick Start

1. Clone this repo  
2. Adjust `config.local.sh` for your paths and cluster  
3. Follow the docs step by step in `docs/`  
4. Or view the combined Quarto document `bulk_rnaseq_pipeline.qmd`  

## Documentation

- [Step 1: Genome Indexing]
- [Step 2: Prepare Reference Reference]
- [Step 3: STAR + RSEM Alignment]
- [Step 4: Metadata creation]

## References

- Dobin et al. (2013) STAR  
- Li & Dewey (2011) RSEM  
- Frankish et al. (2021) GENCODE  
