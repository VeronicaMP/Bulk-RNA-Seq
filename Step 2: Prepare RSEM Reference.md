# Why?
- RSEM also needs a reference (FASTA + GTF).
- Creates .grp and transcript structures for quantification.
- Must match STAR index version.

```bash
#!/usr/bin/env bash
#SBATCH -J RSEM_ref
#SBATCH -p slim16
#SBATCH --mem=120000
#SBATCH -n 16
#SBATCH -o %x_%j.out
set -euo pipefail
module load ngs/STAR/2.7.1a
module load ngs/RSEM/1.3.0

# GENCODE v48
rsem-prepare-reference \
  --gtf genome/gencode.v48.annotation.gtf \
  --star \
  --star-path $(dirname $(which STAR)) \
  genome/hg38.fa \
  genome/rsem_hg38_gencode48/rsem_hg38_gencode48
```
# Output: 
- genome/rsem_hg38_gencode48/ (or _v45/)
- Key file: .grp (required by RSEM).
