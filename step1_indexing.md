# Step 1 — Genome Indexing (STAR)

Before aligning reads, STAR needs a **pre-built genome index**.  
This is built once per **genome assembly (hg38)** + **annotation version (GENCODE v48 or v45)**.

---

## Why?

- Provides STAR with the reference genome sequence and splice junctions.  
- Required by STAR’s `--genomeDir`.  
- The splice junction database is created from the **GTF annotation** and improves mapping of reads across exons.

---

## 1. Download reference genome (hg38)

Change into your genome folder (defined in `config.sh` as `$GENOME`):

```bash
cd $BASE/genome

# Download hg38 FASTA
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gzip -d hg38.fa.gz   # decompress

# Result:
# genome/hg38.fa
```
## 2. Download annotations

# GENCODE v48
```bash
wget -O gencode.v48.annotation.gtf.gz \
  https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_48/gencode.v48.annotation.gtf.gz
gzip -d gencode.v48.annotation.gtf.gz
```

```bash
# GENCODE v45 (optional)
wget -O gencode.v45.annotation.gtf.gz \
  https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_45/gencode.v45.annotation.gtf.gz
gzip -d gencode.v45.annotation.gtf.gz
```

## 3. Build STAR index

```bash
#!/usr/bin/env bash
#SBATCH -J STAR_index
#SBATCH -p slim16
#SBATCH --mem=250000
#SBATCH -n 16
#SBATCH -o %x_%j.out
set -euo pipefail
module load ngs/STAR/2.7.1a

# Choose annotation
GTF="genome/gencode.v48.annotation.gtf"
STAR_INDEX="genome/star-index_v48"
OVERHANG=149  # read length - 1 (150bp reads)

mkdir -p "$STAR_INDEX"

STAR --runThreadN 16 \
     --runMode genomeGenerate \
     --genomeDir "$STAR_INDEX" \
     --genomeFastaFiles genome/hg38.fa \
     --sjdbGTFfile "$GTF" \
     --sjdbOverhang $OVERHANG
```

Output

STAR index in genome/star-index_v48/ (or _v45/)

Used later in STAR alignment.
