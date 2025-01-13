# Gecko_sexchromosome
This repository includes some pipelines used in Gecko genome study, mainly for the phylogeny and the sex chromosome analysis.

## sex chromosome identify
This pipeline (in [01.Identify_sexchromosome](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/01.Identify_sexchromosome) includes three pipelines:
1. Identify the sex chromosome by the depth method. ([a.depth_method.sh](https://github.com/DivedJin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/01.Identify_sexchromosome/a.depth_method.sh))
2. Identify the sex chromosome by the Fst method. ([b.Fst_method.sh](https://github.com/DivedJin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/01.Identify_sexchromosome/b.Fst_method.sh))
3. Filter small scaffolds. ([c.filter_smallscaffold.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/01.Identify_sexchromosome/c.filter_smallscaffold.sh))

## Whole genome alignment by LAST and Maf merge 
This pipeline (in [02.AlignmentLAST](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/02.AlignmentLAST)) includes two pipelines:
1. Whole genome or chromosome alignment. ([a.LAST_alignment.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/02.AlignmentLAST/a.LAST_alignment.sh))
2. MAF files merge by Multiz. ([b.LAST_multiz.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/02.AlignmentLAST/b.LAST_multiz.sh))

## species tree construct
This pipeline (in [03.phylogeny](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/03.phylogeny)) includes five steps:
1. The alignment region extracted from whole genome alignment. ([a.get_alignment.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/03.phylogeny/a.get_alignment.sh))
2. The phylogeny constructed. ([b.phylogeny.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/03.phylogeny/b.phylogeny.sh))
3. The species divergence time estimate. ([c.divergence.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/03.phylogeny//c.divergence.sh))
4. The topology ratio of each node calculate. ([d.discovista.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/03.phylogeny/03.phylogeny/d.discovista.sh))
5. The introgression and ILS estimate. ([e.Quible.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/03.phylogeny/03.phylogeny//e.Quible.sh))

## Ancestral karyotype analysis
This pipeline (in [04.Karyotype](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/04.Karyotype)) includes four steps:
1. The command line of DESCHRAMBLER. ([a.DESCHRAMBLER.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/04.Karyotype/a.DESCHRAMBLER.sh))
2. The command line of ANGES. ([b.anges.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/04.Karyotype/b.anges.sh))
3. Visualized ancestral karyotypes. ([c.merge_karyotype.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/04.Karyotype/c.merge_karyotype.sh))
4. The variant of ancestral karyotypes. ([d.grimm.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/04.Karyotype/d.grimm.sh))

## Sex chromosome evolution 
This pipeline (in [05.Sex_evolution](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/05.Sex_evolution)) includes five pipelines:
1. The case that the sex chromosome is aligned to the  homologous chromosome. ([a.Sexchromsome_alignment_merge.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/05.Sex_evolution/a.Sexchromsome_alignment_merge.sh))
2. The alignment filter. ([b.Mergemaf_filter.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/05.Sex_evolution/b.Mergemaf_filter.sh))
3. The male mutation bias estimate. ([c.male_mutation_bias.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/05.Sex_evolution/c.male_mutation_bias.sh))
4. The Sex chromosome divergence time estimate. ([d.scale_sexdivergencetime.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/05.Sex_evolution/d.scale_sexdivergencetime.sh))
5. The case that SDR gene cluster. ([e.SDR_gene_classification](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/05.Sex_evolution/e.SDR_gene_classification))

## Other pipelines (in [others](https://github.com/Dived-Jin/Gecko_Sexchromosome/tree/eb978283d0cedf755deb868efd83e29570673ffb/others))
1. The command line of geneconversion. ([run_genecoversion.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/others/run_genecoversion.sh))
2. Generated the Hi-C strength matrix. ([HiC_strength_calculate.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/others/HiC_strength_calculate.sh)) 
3. The dn, ds of gametologes estimate. ([Gametologues_dnds.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/others/Gametologues_dnds.sh)) 
4. Gene expression level calculate. ([RNAseq_TMPstat.sh](https://github.com/Dived-Jin/Gecko_Sexchromosome/blob/eb978283d0cedf755deb868efd83e29570673ffb/others/RNAseq_TMPstat.sh))

## Note
The Raw data and control file that been used in our work can download from figureshare ([XXXX](XXXXX))
