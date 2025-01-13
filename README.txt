# Gecko_sexchromosome
This repository includes some pipelines used in Gecko genome study, mainly for the phylogeny and the sex chromosome analysis.

## sex chromosome identify
This pipeline (in [01.Identify_sexchromosome]() includes three pipelines:
1. Identify the sex chromosome by the depth method. ([a.]())
2. Identify the sex chromosome by the Fst method. ([b.]())
3. Filter small scaffolds. (in c.)

## Whole genome alignment by LAST and Maf merge 
This pipeline (in []()) includes two pipelines:
1. Whole genome or chromosome alignment. ([a.]())
2. MAF files merge by Multiz. ([b.]())

## species tree construct
This pipeline (in []()) includes five steps:
1. The alignment region extracted from whole genome alignment. ([a.]())
2. The phylogeny constructed. ([b.]())
3. The species divergence time estimate. ([c.]())
4. The topology ratio of each node calculate. ([d.]())
5. The introgression and ILS estimate. ([e.]())

## Ancestral karyotype analysis
This pipeline (in []()) includes four steps:
1. The command line of DESCHRAMBLER. ([a.]())
2. The command line of ANGES. ([b.]())
3. Visualized ancestral karyotypes. ([c.]())
4. The variant of ancestral karyotypes. ([d.]())

## Sex chromosome evolution 
This pipeline (in []()) includes five pipelines:
1. The case that the sex chromosome is aligned to the  homologous chromosome. ([a.]())
2. The alignment filter ([b.]())
3. The male mutation bias estimate. ([c.]())
4. The Sex chromosome divergence time estimate. ([d.]())
5. The case that SDR gene cluster. ([e.]())

## Other pipelines (in []())
1. The command line of geneconversion. ([]())
2. Generated the Hi-C strength matrix. ([]()) 
3. The dn, ds of gametologes estimate. ([]()) 
4. Gene expression level calculate. ([]())
