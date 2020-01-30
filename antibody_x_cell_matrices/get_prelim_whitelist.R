
orig_triples_L1 <- read.delim("../C70_Caudate_denovo_cellbarcode_AntibodyTriples.out", sep="\t", stringsAsFactors=T)

# get preliminary whitelist

cell_read_count1 <- table(orig_triples_L1[,1])
cell_read_count1 <- cell_read_count1[order(cell_read_count1, decreasing=T)]
#plot(as.vector(cell_read_count1), log="xy")
rm(orig_triples_L1)

cell_read_count1 <- cell_read_count1[cell_read_count1>50]

orig_triples_L2 <- read.delim("../C70_Caudate_L002_denovo_cellbarcode_AntibodyTriples.out", sep="\t", stringsAsFactors=T)
cell_read_count2 <- table(orig_triples_L2[,1])
cell_read_count2 <- cell_read_count2[order(cell_read_count2, decreasing=T)]
#plot(as.vector(cell_read_count2), log="xy")
rm(orig_triples_L2)

cell_read_count2 <- cell_read_count2[cell_read_count2>50]

cell_read_count1 <- cell_read_count1[names(cell_read_count1) %in% names(cell_read_count2)]
cell_read_count2 <- cell_read_count2[match(names(cell_read_count1), names(cell_read_count2))]

cell_read_count <- cell_read_count1+cell_read_count2;
cell_read_count <- cell_read_count[order(cell_read_count, decreasing=T)]


plot(as.vector(cell_read_count), log="xy")

write.table(names(cell_read_count), file="prelim_whitelist.txt", quote=FALSE, row.names=FALSE, col.names=FALSE);

