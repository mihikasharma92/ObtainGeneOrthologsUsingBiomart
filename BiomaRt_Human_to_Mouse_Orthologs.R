# Load required libraries
library(biomaRt)

# RefLink: https://www.r-bloggers.com/converting-mouse-to-human-gene-names-with-biomart-package/
# Basic function to convert human to mouse gene names
convertHumanGeneList <- function(x)
{
  require("biomaRt")
  human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  
  genesV2 = getLDS(attributes = c("hgnc_symbol"), filters = "hgnc_symbol", values = x , mart = human, attributesL = c("mgi_symbol"), martL = mouse, uniqueRows=T)
  
  humanx <- unique(genesV2[, 2])
  
  # Print the first 6 genes found to the screen
  print(head(humanx))
  return(humanx)
}

# Read all the files in loop containing Human Genes to convert to mouse genes
dir = "/Users/sha6hg/Desktop/IPF_scRNA/AnnotationFiles/KrasnowAnnotationFiles/"
output_dir = "/Users/sha6hg/Desktop/IPF_scRNA/AnnotationFiles/KrasnowAnnotationFiles/Human_to_Mouse_Conversion/"
all_file_list = list.files(dir, recursive = F)[grepl(".txt", list.files(dir, recursive = F))]
all_file_path <- paste(dir, all_file_list, sep="")

# Loop through the files
for(file in all_file_list)
{
  print(file)
  file_path <- paste(dir, file, sep = "")
  gene_list_human <- as.data.frame(read.table(file_path, sep = "\n"))$V1
  gene_list_mouse <- convertHumanGeneList(gene_list_human)
  filename <- paste0(output_dir, strsplit(file, ".txt")[[1]], "_MouseGenes.txt")
  write.table(file = filename, gene_list_mouse, sep = "\n", row.names = F, quote = F, col.names = F)
}

