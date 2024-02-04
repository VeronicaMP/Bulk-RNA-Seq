#! /bin/bash
# STAR_alignment

#SBATCH -J STAR_alignment
#SBATCH -p slim16                                       # Partition
#SBATCH --mem 250000                                    # Memory request
#SBATCH -n 32                                           # cores
#SBATCH -N 1                                            # one node ?required
#SBATCH -o /work/project/goecap_001/Bulk_RNA_seq/STAR_align_%j.out

module load ngs/STAR/2.7.1a
module load ngs/RSEM/1.3.0

# Generate Acc_List.txt with just file names
ls /work/project/goecap_001/Bulk_RNA_seq/Giovanna/demultiplex/*.fastq.gz | xargs -n 1 basename > /work/project/goecap_001/Bulk_RNA_seq/Giovanna/demultiplex/Acc_List.txt

if [ ! -e mapping_transcriptome ]; then
  mkdir mapping_transcriptome
fi
if [ ! -e rsem ]; then
  mkdir rsem
fi

for id in `cat /work/project/goecap_001/Bulk_RNA_seq/Giovanna/demultiplex/Acc_List.txt`; do
  echo "start to process sample $id"
  constructed_path="/work/project/goecap_001/Bulk_RNA_seq/Giovanna/demultiplex/${id}"
  echo "Constructed path: $constructed_path"
  
  # Verifying existence of the file before proceeding
  if [ ! -f "$constructed_path" ]; then
    echo "File not found: $constructed_path" >> missing_files.log
    continue  # Skip to the next iteration of the loop
  else
    echo "File exists: $constructed_path"
  fi

  # Only proceed if the directory does not already exist
  if [ ! -e mapping_transcriptome/$id ]; then
    echo "  mapping started"
    mkdir mapping_transcriptome/$id
    STAR --genomeDir genome/star-index \
         --runThreadN 10 \
         --readFilesIn $constructed_path \
         --readFilesCommand zcat \
         --sjdbGTFfile /work/project/goecap_001/Bulk_RNA_seq/genome/gencode.v45.annotation.gtf \
         --quantMode TranscriptomeSAM \
         --outSAMtype BAM SortedByCoordinate \
         --outFileNamePrefix mapping_transcriptome/$id/
    echo "  mapping done"
  fi

  # Check for the presence of STAR output before starting RSEM
  if [ ! -f mapping_transcriptome/$id/Aligned.toTranscriptome.out.bam ]; then
    echo "STAR output not found for $id, skipping RSEM..."
    continue  # Skip to the next iteration of the loop
  else
    echo "STAR output found, proceeding with RSEM..."
  fi
  
  # Proceed with RSEM if the output directory does not already exist
  if [ ! -e rsem/$id ]; then
    echo "rsem started"
    mkdir rsem/$id
    # Count the number of FASTQ files to decide on single-end or paired-end
    num_fa=$(ls -1 ${constructed_path%.*}*.fastq.gz | wc -l)
    if [ $num_fa -eq 1 ]; then
      rsem-calculate-expression --alignments \
                                -p 10 \
                                mapping_transcriptome/$id/Aligned.toTranscriptome.out.bam \
                                genome/rsem_hg38_gencode45/rsem_hg38_gencode45 \
                                rsem/$id/$id
    else
      rsem-calculate-expression --alignments \
                                --paired-end \
                                -p 10 \
                                -q \
                                mapping_transcriptome/$id/Aligned.toTranscriptome.out.bam \
                                genome/rsem_hg38_gencode45/rsem_hg38_gencode45 \
                                rsem/$id/$id
    fi
    echo "  rsem done"
  fi
done

