### Getting rarefied table
library("vegan")
args <- commandArgs(TRUE)
file_in <- as.character(args[1])
size=as.integer(args[2])
otu_df<-read.table(file_in, header=TRUE, row.names=1, sep="\t")
otu_mat<-as.matrix(otu_df)
transp_otu_mat<-t(otu_mat)
rarefied=rrarefy(transp_otu_mat, size)
t_rarefied=t(rarefied)
write.table(t_rarefied, "rarefied_otu_table.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names=TRUE)



