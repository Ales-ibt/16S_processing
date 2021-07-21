### Calculo de estimadores alfa diversidad con el paquete phyloseq de R
library("phyloseq")
args <- commandArgs(TRUE)
file_in <- as.character(args[1])
otu_df<-read.table(file_in, header=TRUE, row.names=1)
otu_mat<-as.matrix(otu_df)
taxrank_mat <- as.matrix(paste0("OTU", 1:nrow(otu_mat)))
rownames(taxrank_mat) <- rownames(otu_mat)
colnames(taxrank_mat) <- ("TAX")
OTU<-otu_table(otu_mat, taxa_are_rows=TRUE)
TAX<-tax_table(taxrank_mat)
physeq = phyloseq(OTU, TAX)
diversity_index<-as.data.frame(round(estimate_richness(physeq, measures=c("Observed", "Chao1", "Shannon","Simpson")), 2))
diversity_index2<-data.frame(Sample=rownames(diversity_index))
diversity_index3<-cbind(diversity_index2, diversity_index)
colnames(diversity_index3)=c("Sample","Observed", "Chao1", "se.chao1","Shannon","Simpson")
write.table(diversity_index3, "simp_alpha_diversity_index.txt", quote = FALSE, sep = "\t", row.names = FALSE, col.names=TRUE)
#quit()

### Normalizando las muestras para beta diversidad
library("metagenomeSeq")
mydata<-load_meta(as.character(args[1]))
obj = newMRexperiment(mydata$counts)
p = cumNormStatFast(obj)
normalized_matrix = cumNormMat(obj, p = p)
exportMat(normalized_matrix, file ="normal_otu_table.txt")

### NMDS con la normalizada
library("vegan")
library("MASS")
otu_df<-read.table("normal_otu_table.txt", header=TRUE, row.names=1, sep="\t")
otu_mat<-as.matrix(otu_df)
transp_otu_mat<-t(otu_mat)

### Metamds
cru.mds_meta <- metaMDS(transp_otu_mat, trace = FALSE)
print(cru.mds_meta)
var_stress<-round(cru.mds_meta$stress, 6)

my_color=("#00BFFF")

png("metamds_bray.png", width = 5*300, height = 5*300, res = 400, pointsize = 8)
plot(cru.mds_meta, type = "n", cex.axis=0.6, cex.lab=0.6)
text(cru.mds_meta, labels = row.names(transp_otu_mat), cex=0.75, col=my_color)
coord<-par("usr")
text(coord[1]+0.4, coord[3]+0.1, labels=paste("Stress: ", var_stress, sep=''), cex=0.6)
dev.off()

### Dendograma con distancias de Bray
BrayDist_mangroves <- vegdist(transp_otu_mat, method = "bray")
hClustering <- hclust(BrayDist_mangroves, method = 'complete')

png("clust_bray.png", width = 5*300, height = 5*300, res = 400, pointsize = 8)
plot(hClustering)
dev.off()                        
quit()                           



