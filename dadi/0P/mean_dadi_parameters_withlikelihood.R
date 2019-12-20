# This script take the dadi output and estimate mean of parameters
# example: Rscript mean_dadi_parameters.R dadi_output.bootstrap.clean new_output.txt

rm(list=ls(all=TRUE))

options(echo=F)
args<-commandArgs(TRUE)

print(args[1])

aa=read.table(args[1], F)

results<-as.matrix(t(c(mean(aa$V1), mean(aa$V2), mean(aa$V3), 
                       var(aa$V1), var(aa$V2), var(aa$V3), 
                       dim(aa)[1])), nrow = 1)

write.table(results, file = args[2], sep = "\t", col.names = FALSE, row.names = FALSE, append=TRUE)
