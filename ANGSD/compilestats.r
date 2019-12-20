args<-commandArgs(TRUE)
file<-args[1]
read.table(file=file,header=F)->S
names(S)<-c("(indexStart,indexStop)(firstPos_withData,lastPos_withData)(WinStart,WinStop)","Chr"," WinCenter","tW","tP","tF","tH","tL","Tajima","fuf","fud","fayh","zeng","nSites")
S<-S[S$nSites>100,]
mean((S$tW/S$nSites))->mtWaterson
mean((S$tP/S$nSites))->mtPi
sum(as.numeric(S$nSites))->totalsites
sqrt(var((S$tP/S$nSites))/length(S$tP/S$nSites))-> sterror
sd((S$tP/S$nSites))->stddev
mean(S$Tajima)->mTajD
x<-cbind(file,mtWaterson,mtPi,totalsites,sterror,stdev,mTajD)
write.table(x,file="All_diversitystats.txt",append=T,quote=F,sep="\t",row.names=F,col.names=F)
