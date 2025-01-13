cut -f1-14,16-22,24 N0.tsv > N0.tsv.filt
perl bin/filter_Duplications_tsv.pl gene.lst/ Duplications.tsv > Duplications.tsv.filt
perl bin/filter_N0tsv.pl gene.lst/ N0.tsv.filt > N0.tsv.filt.filt
perl bin/obtain_orthoFinderDup_info.pl Duplications.tsv.filt ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int ARIPRA 0.5 > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add
perl bin/obtain_orthoFinder_info.v1.pl N0.tsv.filt.filt ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add

perl orthoFinder_to_CAFE5.pl N0.tsv.filt.filt > gene_families.txt
awk '$(NF-1)>1' gene_families.txt | awk '$25<150' | cut -f1-23 > gene_families.txt.filt
cafe5 -i gene_families.txt.filt -t species19.topology.nwk > cafe5.log 2>&1

perl bin/combine_cafe5.pl results/Base_change.tab ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add ARIPRA THAELE,LACAGI 10 > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add
perl bin/refine_one_to_one.pl 19species.ort.filt80 ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add | perl bin/refine_gametolog_pair.pl all.pairwise.tab.addDS_conversion.txt.filt - > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine
cut -f1-7,15 ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut
perl bin/AddColumn.v2.pl ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut ARIPRA.tpm.rename.norm.format.ts.median.tauV2.filt1 7 | perl bin/AddColumn.v2.pl - ARIPRA.pep.blast.swissprot.xls.format.rename 7 > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut.all_add

awk '$8=="ancestral"' ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut.all_add > ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut.all_add.tab
awk '$8!="ancestral" && $16>=1' ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut.all_add >> ARIPRA.gff.bed.sort.add_idx.nonPARXZ_int.add.add.add.refine.cut.all_add.tab

