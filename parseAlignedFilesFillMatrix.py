\documentclass{article}

\begin{document}
\SweaveOpts{concordance=TRUE}

<<32mers>>=
par(mfrow=c(2,2),cex=1.2)
setwd("/Users/alice/Desktop/projects/heterochromatin/trf/chrUn")
A<-read.table("A")
B<-read.table("B")
D<-read.table("D")
E<-read.table("E")
lengthDist<-read.table("chrUn.length_dist")

plot(table(A$V2),main="A",xlab="repeat length",ylab="counts")
abline(v=1000,col="red",lw=3)
plot(table(B$V2),main="B",xlab="repeat length",ylab="counts")
abline(v=1000,col="red",lw=3)
plot(table(D$V2),main="D",xlab="repeat length",ylab="counts")
abline(v=1000,col="red",lw=3)
plot(table(E$V2),main="E",xlab="repeat length",ylab="counts")
abline(v=1000,col="red",lw=3)

plot(table(lengthDist$V2),main="chrUn of chimp female",xlab="contig length distribution",ylab="counts")
abline(v=1000,col="red",lw=3)
@

<<plot heatmap>>=
if (!require("gplots")) {
  install.packages("gplots", dependencies = TRUE)
  library(gplots)
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer", dependencies = TRUE)
  library(RColorBrewer)
}
library(heatmap3)

data<-as.data.frame(read.table("/Users/alice/Desktop/projects/heterochromatin/32mers/Un.AAACATGGAAATATCTACACCGCTATCTGTAT.nrf.words.aligned.txt",header=TRUE))
print(dim(data))
data<-data[rowSums(data)>0, ]
print(dim(data))
data<-data[sample(nrow(data), 10000), ]
print(dim(data))
data<-data.matrix(data)
my_palette <- colorRampPalette(c("beige","red"))(n = 10)
heatmap.2(data,dendrogram='column',Rowv=TRUE,Colv=TRUE,trace="none",col=my_palette,key.title ="occurences",notecol="black")
@


\end{document}