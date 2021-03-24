# DECIPHER taxonomy assignment
library(DECIPHER)
library(tidyverse)
setwd("./working_dir/")

# load training set
load("./SILVA_SSU_r138_2019.RData") # CHANGE TO THE PATH OF YOUR TRAINING SET

fas <- "./sanger_seq_all.fas"
best_otus_seq <- readDNAStringSet(fas)

# taxonomy assignment
ids <- IdTaxa(best_otus_seq, trainingSet, strand = "both", processors = NULL, verbose = TRUE, threshold = 20)

# ranks of interest
ranks <- c("domain", "phylum", "class", "order", "family", "genus", "species") 

taxid <- t(sapply(ids, function(x) {
  m <- match(ranks, x$rank)
  taxa <- x$taxon[m]
  taxa[startsWith(taxa, "unclassified_")] <- NA
  taxa
}))

colnames(taxid) <- ranks

# as table
final_table <- as_tibble(taxid, rownames = "otu")