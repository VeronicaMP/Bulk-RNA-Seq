# Why?
- Analyses require a samplesheet linking sample IDs to conditions, batches, replicates.
- Prevents mistakes in grouping samples.

```bash
#!/usr/bin/env bash
BASE="/work/project/goecap_001/Bulk_RNA_seq"
RSEM_DIR="$BASE/rsem_gencode_v48"
OUT="$BASE/samples.tsv"

echo -e "sample\tcondition\tbatch\tindividual\treplicate\tnotes" > "$OUT"

find "$RSEM_DIR" -maxdepth 1 -mindepth 1 -type d -printf "%f\n" \
 | sort | while read s; do
     echo -e "${s}\tFILLME\t1\tNA\t1\t" >> "$OUT"
   done
```
#Output
- samples.tsv with editable fields.
- Edit in Excel/LibreOffice (save as tab-delimited).
