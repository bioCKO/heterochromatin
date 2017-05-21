load('/Volumes/Przeworski_baboon_data/kinetics_cmp/IPDlist_passes.Plus.rda')
#load('/Volumes/Przeworski_baboon_data/kinetics_cmp/IPDlist_passes.Minus.rda')
#load('/Volumes/Przeworski_baboon_data/kinetics_cmp/IPDlist_passes.PlusEmpty.rda')
#load('/Volumes/Przeworski_baboon_data/kinetics_cmp/IPDlist_passes.MinusEmpty.rda')

/Volumes/Przeworski_baboon_data/kinetics_cmp/IPDlist_passes.PlusEmpty.rda
par(mfrow=c(2,2))
require("MASS")
require(dplyr)

IPD_start_0=list(pass1=IPDlistPASS1_0,
                 pass2=IPDlistPASS2_1,
                 pass3=IPDlistPASS3_0,
                 pass4=IPDlistPASS4_1,
                 pass5=IPDlistPASS5_0)

IPD_start_1=list(pass1=IPDlistPASS1_1,
                 pass2=IPDlistPASS2_0,
                 pass3=IPDlistPASS3_1,
                 pass4=IPDlistPASS4_0,
                 pass5=IPDlistPASS5_1)




IPD_start_0_mean=lapply(IPD_start_0,
                        function(IPD) unlist(lapply(IPD,function(IPD) mean(log(IPD+0.01),na.rm=TRUE))))
IPD_start_1_mean=lapply(IPD_start_1,
                        function(IPD) unlist(lapply(IPD,function(IPD) mean(log(IPD+0.01),na.rm=TRUE))))


toPlot<-as.data.frame(t(Reduce(rbind,IPD_start_0_mean)))
colnames(toPlot)<-c("P1","P2","P3","P4","P5")
toPlot<-toPlot[with(toPlot, order(P1)), ]
#parcoord(toPlot, col=terrain.colors(length(toPlot[,1])), var.label=TRUE, main="start 0")
matplot(t(toPlot), col=terrain.colors(length(toPlot[,1])), main="start 0",type='l',lty=1)
boxplot(toPlot,outline=FALSE)

toPlot<-as.data.frame(t(Reduce(rbind,IPD_start_1_mean)))
colnames(toPlot)<-c("P1","P2","P3","P4","P5")
toPlot<-toPlot[with(toPlot, order(P1)), ]
#parcoord(toPlot, col=terrain.colors(length(toPlot[,1])), var.label=TRUE, main="start 1")
matplot(t(toPlot), col=terrain.colors(length(toPlot[,1])), main="start 1",type='l',lty=1)
boxplot(toPlot,outline=FALSE)