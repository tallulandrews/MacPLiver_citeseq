args <- commandArgs(trailingOnly=TRUE);
# args: antibody triples file; output file

orig_triples <- read.delim(args[1], sep="\t", stringsAsFactors=T)

# get preliminary whitelist

cell_read_count <- as.vector(table(orig_triples[,1]))
cell_read_count <- cell_read_count[order(cell_read_count, decreasing=T)]
plot(cell_read_count, log="xy")

write.table(names(cell_read_count)[cell_read_count>200], file="prelim_whitelist.txt", quote=FALSE, row.names=FALSE, col.names=FALSE);

# make matrix

sparse_mat_tuples <- aggregate(orig_triples[,3], by=list(orig_triples[,1], orig_triples[,2]), function(x) {length(unique(x))});

require(Matrix)
genes <- factor(sparse_mat_tuples[,2])
cells <- factor(sparse_mat_tuples[,1])
mat <- sparseMatrix(i=as.numeric(genes), j=as.numeric(cells), x=sparse_mat_tuples[,3]);
rownames(mat) <- levels(genes);
colnames(mat) <- levels(cells);

# antibody tag 2 gene/antigen
ref <- read.delim("../100819QG_TotalSeq-C_human_Panel_list.csv", sep="\t",header=T)

saveRDS(mat, args[2])
