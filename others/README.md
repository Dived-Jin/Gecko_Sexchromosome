this folder is used to keep some pipelines that used in analysis.

The abbreviations in the document are represented the species name, which is found in [species.txt](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/af3026331796bd45a6fcf1bb4dc1415eb5a400ed/species.txt).

(1) HiC_strength_calculate.sh: this file is used to generate the Hi-C interaction strength matrix. 
```
    used: sh HiC_strength_calculate.sh <HiC_alignment> <genomefasta> <outname>
        - HiC_alignment: HiC data aligned to the genome by juicer
        - genomefasta: genome fasta file 
        - outname: output prefix 
    for example: sh HiC_strength_calculate.sh merged_nodups.txt coleonyx_brevis.XY.fasta coleonyx_brevis.XY     
```
(2) run_genecoversion.sh: this file is used to estimate genecoversion.
   ```
    used: sh run_genecoversion.sh <alignment_path_list>
        - alignment_path_list: the list file which alignment path.
```
(3) Gametologues_dnds.sh: this file is used to calculate the dn/ds of gametology by Paml.
   ```
    used: sh Gametologues_dnds.sh <pairwise_list> <protein_fasta> <cds_fasta>
        - pairwise_list: include two columns; chrXZ geneid, chrYW geneid
        - protein_fasta: protein file of all species with fasta formate.
        - cds_fasta: cds file of all species with fasta format.
```
(4) RNAseq_TMPstat.sh:  this file is used to calculate the gene expression for each species.
```
    used: sh RNAseq_TMPstat.sh <cds_fasta> <gene_gff> <sample.list> <outdir>
        - cds_fasta: cds file with fasta format.
        - gene_gff: genome annotation file with gff3 format
        - sample.list: fastq file include two or three columns; sample name, fq/fq1, fq2
   ```
