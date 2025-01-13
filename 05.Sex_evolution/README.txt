This folder include the piplines that are used to estimate male mutation bias & sex devergence time.
(1)a.Sexchromsome_alignment_merge.sh : The case that the sex chomsome aligned to other homologues in other species.
    - example/*.txt : the sex chromosome list and the homologues list in other species.

(2)b.Mergemaf_filter.sh: removed the repeat and cds region from maf file
    the inputdir structure and file name same as example example/maffilter.

(3)c.male_mutation_bias.sh : calculated the male mutation bias

(4)d.scale_sexdivergencetime.sh: scaled the sex divergence time

(5)e.SDR_gene_classification: this directory is an example case to categorize genes on SDR into ancestral, gain and unknown
