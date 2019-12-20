args<-commandArgs(TRUE)
file<-args[1]
N<-as.numeric(args[2])
Outfile<-args[3]

library(dplyr)
library(tidyr)


read.table(file=file,header=F)->S
names(S)<-c("Chr","pos","tW","tP","tS","tH","tL")
mean(exp(S$tW))->mtWatterson
mean(exp(S$tP))->mtPi
length(S$tP)->totalsites
sqrt(var(exp(S$tP))/length(S$tP))-> sterror
sd(exp(S$tP))->stddev

a1 = sum(1/1:(N-1));  a2 = sum((1/1:(N-1))^2)
b1 = (N+1)/(3*(N-1)); b2 = 2*(N^2 + N + 3)/(9*N*(N-1))
c1 = b1 - 1/a1;       c2 = b2 - (N+2)/(a1*N) + a2/a1^2
e1 = c1/a1;           e2 = c2/(a1^2+a2)

sum(exp(S$tW)) ->All_watterson
sum(exp(S$tP)) ->All_pi
a1*All_watterson ->SS 
(All_pi - All_watterson) / sqrt(e1*SS + e2*SS^2) ->TajD



x<-cbind(file,mtWatterson,mtPi,sterror,stddev,totalsites,TajD)
write.table(x,file=Outfile, quote=F, sep="\t", row.names=F, col.names=F)
