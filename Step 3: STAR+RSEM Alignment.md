# Why?
- Align FASTQ files with STAR
- Use --quantMode TranscriptomeSAM so RSEM can quantify transcripts.
- Quantify per-sample with RSEM.

```bash
#!/usr/bin/env bash
#SBATCH -J STAR_RSEM
#SBATCH -p slim16
#SBATCH --mem=250000
#SBATCH -n 32
#SBATCH -o %x_%j.out
set -euo pipefail
module load ngs/STAR/2.7.1a
module load ngs/RSEM/1.3.0

DEMUX=$BASE/Giovanna/demultiplex
RUN_TAG="gencode_v48"
STAR_INDEX="genome/star-index_v48"
RSEM_PREFIX="genome/rsem_hg38_gencode48/rsem_hg38_gencode48"
GTF="genome/gencode.v48.annotation.gtf"

MAP_DIR="mapping_transcriptome_${RUN_TAG}"
RSEM_DIR="rsem_${RUN_TAG}"
mkdir -p "$MAP_DIR" "$RSEM_DIR"

# build sample list
find "$DEMUX" -name 'read1_*.fastq.gz' \
 | sed -E 's#.*/read1_(.+)\.fastq.gz#\1#' \
 | sort -u > Acc_List_${RUN_TAG}.txt

while read -r sample; do
  R1="$DEMUX/read1_${sample}.fastq.gz"
  R2="$DEMUX/read2_${sample}.fastq.gz"

  outdir="$MAP_DIR/$sample"
  mkdir -p "$outdir"

  STAR --genomeDir "$STAR_INDEX" \
       --runThreadN 16 \
       --readFilesIn "$R1" "$R2" \
       --readFilesCommand zcat \
       --sjdbGTFfile "$GTF" \
       --quantMode TranscriptomeSAM \
       --outSAMtype BAM SortedByCoordinate \
       --outFileNamePrefix "${outdir}/"

  ALN_TX="${outdir}/Aligned.toTranscriptome.out.bam"

  rsem_out="$RSEM_DIR/$sample"
  mkdir -p "$rsem_out"

  rsem-calculate-expression \
    --alignments --paired-end -p 16 -q \
    "$ALN_TX" "$RSEM_PREFIX" "$rsem_out/$sample"

done < Acc_List_${RUN_TAG}.txt
```

# Output
- STAR logs: mapping_transcriptome_<tag>/<sample>/
- RSEM results: rsem_<tag>/<sample>/<sample>.genes.results
