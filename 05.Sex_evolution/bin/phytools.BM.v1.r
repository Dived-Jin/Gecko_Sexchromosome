library(ape)
library(geiger)
library(ouch)
library(phytools)
library(phangorn)

args = commandArgs(T)

treeFile = args[1]
matFile = args[2]
outFile = args[3]

tree <- read.tree(treeFile)
mat = read.table(matFile)
log2mat <- log2(mat + 1)

anc_results <- lapply(seq_len(nrow(log2mat)), function(i) {

  gene_name <- rownames(log2mat)[i]

  gene_expr <- as.numeric(log2mat[i, ])
  names(gene_expr) <- colnames(log2mat)

  ## 1. Keep only non-NA values
  gene_expr <- gene_expr[!is.na(gene_expr)]

  ## 2. Intersect tree and expression names
  common_tips <- intersect(names(gene_expr), tree$tip.label)

  ## Need at least 2 tips
  if (length(common_tips) < 2) return(NULL)

  gene_expr <- gene_expr[common_tips]

  ## 3. Prune tree
  pruned_tree <- drop.tip(tree, setdiff(tree$tip.label, common_tips))

  ## 4. Enforce identical order
  gene_expr <- gene_expr[pruned_tree$tip.label]

  ## Safety check (THIS prevents your error)
  if (length(gene_expr) != length(pruned_tree$tip.label) ||
      !identical(names(gene_expr), pruned_tree$tip.label)) {
    return(NULL)
  }

  ## 5. Recompute internal nodes
  Ntip  <- length(pruned_tree$tip.label)
  Nnode <- pruned_tree$Nnode
  internal_nodes <- (Ntip + 1):(Ntip + Nnode)

  node_desc <- lapply(internal_nodes, function(n) {
    pruned_tree$tip.label[
      Descendants(pruned_tree, n, type = "tips")[[1]]
    ]
  })
  names(node_desc) <- internal_nodes

  ## 6. fastAnc
  anc_bm <- fastAnc(pruned_tree, gene_expr)

  data.frame(
    gene = gene_name,
    node = names(anc_bm),
    expression = 2^anc_bm - 1,
    descendants = sapply(
      node_desc[names(anc_bm)],
      paste,
      collapse = ","
    ),
    row.names = NULL
  )
})

anc_table_all_genes <- do.call(rbind, anc_results)
write.table(anc_table_all_genes, outFile, quote = F, sep="\t", row.names = F)
