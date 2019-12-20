# This script take the dadi output and estimate mean of parameters
# example: Rscript mean_dadi_parameters.R dadi_output.bootstrap.clean new_output.txt

rm(list=ls(all=TRUE))

options(echo=F)
args<-commandArgs(TRUE)

print(args[1])

aa=read.table(args[1], F)

results<-as.matrix(t(c(mean(aa$V1), mean(aa$V2), mean(aa$V3), mean(aa$V4), mean(aa$V5), 
                       sd(aa$V1), sd(aa$V2), sd(aa$V3), sd(aa$V4), sd(aa$V5),
                       dim(aa)[1])), nrow = 1)

write.table(results, file = args[2], sep = "\t", col.names = FALSE, row.names = FALSE, append=TRUE)

