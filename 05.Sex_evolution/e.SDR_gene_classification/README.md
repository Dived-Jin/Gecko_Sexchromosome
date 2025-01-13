# SDR gene categorization
this directory is an example case to categorize genes on SDR into ancestral, gain and unknown
```
## Input
- ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int: gene coordinates in BED format. column 7th is the geneID, column 8th is the gene index
- Duplications.tsv: output of orthoFinder, under Gene_Duplication_Events/
- N0.tsv: output of orthoFinder, under Phylogenetic_Hierarchical_Orthogroups/
- 19species.ort.filt80: RBH ortholog results
- all.pairwise.tab.addDS_conversion.txt.filt: gametolog table
- ARIPRA.tpm.rename.norm.format.ts.median.tauV2.filt1: SDR gene with transcriptome data
- ARIPRA.pep.blast.swissprot.xls.format.rename: SDR gene annotation
```
