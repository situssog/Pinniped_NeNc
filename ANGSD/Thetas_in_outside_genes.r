args<-commandArgs(TRUE)
theta<-args[1]
clusters<-args[2]
N<-as.numeric(args[3])
Within_region<-args[4]
distance<-as.numeric(args[5])
Outside_region<-args[6]

library(dplyr)
library(tidyr)

#this script is submitted Rscript Thetas_in_outside_genes.r F50__Svalbard__LIB6__Odo_ros_0_8_per_site.thetas Walrus_protein_coding_gene_locations 24 Odo_ros_pi_within_genes 0 Odo_ros_pi_outside_genes

theta = read.table(file=theta, header=F, comment.char="")
colnames(theta) <- c("Chromo", "Pos", "Watterson", "Pairwise", "thetaSingleton", "thetaH", "thetaL")

clusters = read.table(file=clusters)



new_clusters <- data.frame(clusters$V1,clusters$V2,clusters$V3)
colnames(new_clusters) <- c("Scaffold", "start", "stop")


#coef needed for calculation of D
a1 = sum(1/1:(N-1));  a2 = sum((1/1:(N-1))^2)
b1 = (N+1)/(3*(N-1)); b2 = 2*(N^2 + N + 3)/(9*N*(N-1))
c1 = b1 - 1/a1;       c2 = b2 - (N+2)/(a1*N) + a2/a1^2
e1 = c1/a1;           e2 = c2/(a1^2+a2)


# gene + X bp
distance<-args[5]

new_clusters$startpos = NA
new_clusters$endpos  = NA
new_clusters$thetaW = NA
new_clusters$Pi = NA
new_clusters$S = NA
new_clusters$TajimaD = NA
new_clusters$totalsites = NA

new_clusters[,2]<-as.numeric(as.vector(new_clusters[,2]))
new_clusters[,3]<-as.numeric(as.vector(new_clusters[,3]))

for (i in 1:nrow(new_clusters))
{
  sites = (theta$Pos >= (new_clusters[i,2]-distance) & 
	theta$Pos <= (new_clusters[i,3]+distance) & 
	theta$X.Chromo == as.vector(new_clusters[i,1]))
  new_clusters$startpos[i] = new_clusters[i,2]-distance
  new_clusters$endpos[i]  = new_clusters[i,3]+distance
  new_clusters$thetaW[i]  = sum(exp(theta$Watterson[sites]))
  new_clusters$Pi[i]      = sum(exp(theta$Pairwise[sites]))
  new_clusters$S[i]       = a1*new_clusters$thetaW[i]
  new_clusters$TajimaD[i] = (new_clusters$Pi[i] - new_clusters$thetaW[i]) / sqrt(e1*new_clusters$S[i] + e2*new_clusters$S[i]^2)
  new_clusters$totalsites[i] = length(theta$Pairwise[sites])
}

new_clusters <- new_clusters %>%
	filter(totalsites > 0)

write.table(new_clusters, file=Within_region, quote= FALSE, row.names=FALSE)


theta$coding = NA
for (i in 1:nrow(theta)){
	print(i)
	in_coding<-new_clusters %>%
		filter(Scaffold==as.vector(theta[i,1])) %>%
		mutate(coding=(start<=(as.numeric(as.vector(theta[i,2]))-distance) & 
			stop>=(as.numeric(as.vector(theta[i,2]))+distance))*1) %>% 
		ungroup() %>%
		select(coding) %>% 
		unlist() %>%
		as.vector() %>%
		sum()
	theta$coding[i]<-(in_coding!=0)*1
}


final_table<-theta %>% 
	filter(coding==0) %>%
	ungroup() %>%
	dplyr::summarize(thetaW=sum(exp(Watterson)), 
		Pi=sum(exp(Pairwise)), 
		totalsites=n()) %>% 
	mutate(S=a1*thetaW, 
		TajimaD=(Pi - thetaW) / sqrt(e1*S + e2*S^2))

write.table(final_table, file=Outside_region, quote= FALSE, row.names=FALSE)


 
 


