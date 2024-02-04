#! /bin/bash
# STAR_alignemnt

#SBATCH -J STAR
#SBATCH -p slim16                                       # Partition
#SBATCH --mem 250000                                    # Memory request
#SBATCH -n 32                                           # cores
#SBATCH -N 1                                            # one node ?required
#SBATCH -o /work/project/goecap_001/Bulk_RNA_seq/STAR%j.out

module load ngs/STAR/2.7.1a

#REF_GENOME=/work/project/goecap_001/Bulk_RNA_seq/Genome  # path to human genome

STAR --runThreadN 10 \
     --runMode genomeGenerate \
     --genomeDir /work/project/goecap_001/Bulk_RNA_seq/genome/star-index \
     --genomeFastaFiles /work/project/goecap_001/Bulk_RNA_seq/genome/hg38.fa \
