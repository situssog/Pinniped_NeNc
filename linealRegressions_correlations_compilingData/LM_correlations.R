library(car)
library(lme4)
library(lmtest)
library(dplyr)
library(tidyverse)
library(ggpmisc)
library("ggpubr") 

rm(list=ls(all=T)) 


# loading data:
#input only includes one representative per species and input2 includes all populations. 
# these files contain information of both population genetics parameters and life history traits: 
input<-read.csv("ResultsMatrix_forR_multiple_IUCN_April.csv",header=T) %>%
  filter(IncludeLM=="yes") # only 1 representative for species
input2<-read.csv("ResultsMatrix_forR_multiple_IUCN_April.csv",header=T) # all populations

# loading demographic infferences: 
demographicData<-read.table("total_data_selmodel_withPi_perChr_withFiters.txt", T) 

# merging both data sets: 
# from pi values we estimated Ne
dat<-merge(demographicData, input, by=c("Population_Code")) %>% 
  mutate(Ne_GTclade=Theta_pi/(4*Substitution_rate_GTclade), 
         Ne_Nc=Ne_GTclade/Nc_subspecies_IUCN)

dat2<-merge(demographicData, input2, by=c("Population_Code")) %>% 
  mutate(Ne_GTclade=Theta_pi/(4*Substitution_rate_GTclade), 
         Ne_Nc=Ne_GTclade/Nc_subspecies_IUCN)


##transform variables to log scale:
dat<-dat %>% 
  mutate(Nc_species_IUCN=log(Nc_species_IUCN), 
         Nc_subspecies_IUCN=log(Nc_subspecies_IUCN),
          Ne_GTclade=log(Ne_GTclade), 
          N1=log(N1), 
          N2=log(N2), 
          Theta_w=log(Theta_w), 
          Theta_pi=log(Theta_pi), 
          Estimated_area_occupancy=log(Estimated_area_occupancy), 
          MeanSSD=log(MeanSSD), 
          Harem_size=log(Harem_size), 
          Ne_Nc=log(Ne_Nc), 
          Lactation_length=log(Lactation_length), 
          Season_length=log(Season_length)) %>% 
  data.frame()

dat2<-dat2 %>% 
  mutate(Nc_species_IUCN=log(Nc_species_IUCN), 
         Nc_subspecies_IUCN=log(Nc_subspecies_IUCN),
         Ne_GTclade=log(Ne_GTclade), 
         N1=log(N1), 
         N2=log(N2), 
         Theta_w=log(Theta_w), 
         Theta_pi=log(Theta_pi), 
         Estimated_area_occupancy=log(Estimated_area_occupancy), 
         MeanSSD=log(MeanSSD), 
         Harem_size=log(Harem_size), 
         Ne_Nc=log(Ne_Nc), 
         Lactation_length=log(Lactation_length), 
         Season_length=log(Season_length)) %>% 
  data.frame()



# Loading phylogeny
library("ggtree")
tree<-read.tree(text="((((((Monachus_schauinslandi:16.27,Monachus_monachus:16.27):1.93,((Mir_leo_SouthAtlantic:4.66,Mir_ang_NorthAtlantic:4.66):11.92,(((Leptonychotes_weddellii:8.95,Hydrurga_leptonyx:8.95):4.01,Ommatophoca_rossii:12.94):0.53,Lobodon_carcinophagus:13.45):3.13):1.64):4.08,((((Pag_gro_STLAW:8.36,Phoca_fasciata:8.36):4.36,(((Pho_vit_Svalbard:2.13,Phoca_largha:2.13):4.38,((Phoca_caspica:5.48,(Hal_gry_STLAW:0.02,Hal_gry_UK_unsure:0.02):5.48):0.62,Phoca_sibirica:6.08):0.43):0.41,(Pus_his_Baltic:0.02,Pus_his_North_Atlantic_Svalbard:0.02,Pus_his_Saimaa:0.02):6.88):5.84):1.79,Cys_cri_Svalbard:14.47):5.46,Eri_bar_Svalbard:19.91):2.35):4.47,(((((((Zal_cal_1:0.02, Zal_cal_2:0.02, Zal_cal_3:0.02, Zal_cal_4:0.02, Zal_cal_5:0.02, Zal_cal_SMI:0.02):1.32, (Zal_wol_SF:0.02, Zal_wol_PC:0.02, Zal_wol_MO:0.02, Zal_wol_IV:0.02, Zal_wol_IBES:0.02, Zal_wol_GE:0.02, Zal_wol_FH:0.02, Zal_wol_ECEG:0):1.32):5.27,(Eum_jub_Grassy_Island:0.02, Eum_jub_Sugarloaf:0.02):6.59):2.61,(((((Arctocephalus_townsendi:0.81,Arctocephalus_philippii:0.81):4.10,((Arctocephalus_tropicalis:0.52,Arc_gaz_BIRDISLAND:0.52):4.15,((Arc_gal_Galapagos:0.97,(Arc_aus_Brazil:0.02, Arc_aus_Peru:0.02):0.97):1.09,(Arc_for_CF:0.02, Arc_for_OB:0.02, Arc_for_OP:0.02, Arc_for_VB:0.02):2.04):2.63):0.26):1.13,Phocarctos_hookeri:6.00):1.11,Arctocephalus_pusillus:7.09):0.30,Otaria_byronia:7.37):1.83):0.84,Neophoca_cinerea:10.00):1.95,Cal_urs_SMI:11.93):9.78,Odo_ros_Svalbard:21.69):5.02):8.62,Ursidae:35.29):8.10,Canidae:43.37);")
tree_without_unsampled<-ape::drop.tip(tree, c(tree$tip.label[!(tree$tip.label %in% dat$Population_Code )]))
# just to have a look to the phylogeny:
tree_ed<- ape::as.phylo(tree_without_unsampled)
fig_tree<- ggtree(tree_ed) + geom_text2(aes(subset=!isTip, label=node), hjust=-.3) + geom_tiplab() + geom_tippoint() + theme_tree2() #+ xlim(0, 40)
fig_tree

#########
##Ne and Nc are correlated
########
m1a<-lm(Ne_GTclade~Nc_species_IUCN, data=dat)
m1b<-lm(Ne_GTclade~Nc_subspecies_IUCN, data=dat) 
Anova(m1a, Type="III"); summary(m1a)
Anova(m1b, Type="III"); summary(m1b)

# phylogenetic correction:
library(nlme)
library(geiger)
# m1b<-lm(Ne_GTclade~Nc_subspecies_IUCN, data=dat)
tem_data<-data.frame(Population_Code=factor(dat$Population_Code, 
                                            levels=c(as.vector(tree_without_unsampled$tip.label))),
                     Nc_species_IUCN=dat$Nc_species_IUCN, 
                     Nc_subspecies_IUCN=dat$Nc_subspecies_IUCN, 
                     Ne_GTclade=dat$Ne_GTclade) %>% 
  arrange(Population_Code) 
row.names(tem_data)<-tem_data$Population_Code

fit<-gls(Ne_GTclade~Nc_species_IUCN, tem_data)
fit_withCorrection<-gls(Ne_GTclade~Nc_species_IUCN, tem_data, correlation=corPagel(0.1,tree_without_unsampled, fixed=FALSE),method="ML")
summary(fit)
summary(fit_withCorrection)

###--> Ne and Nc are correlated. We get the strongest correlation for Ne_GTclade vs Nc_subspecies_IUCN. 


###########
#### show that TajD is good predictor for demographic change
###########
sel<-!complete.cases(dat$N2) # select cases where 2P model best
N<-c(dat$N1[sel], dat$N2[!sel]) #select N1 when 2P Model best, select N2 where 3P model best
TD<-c(dat$TajD[sel],dat$TajD[!sel]) # select corresponding TajD values


m.N<-lm(N~TD) # to be run with phylogenetic control
m.N1<-lm(N1~TajD , data=dat[sel,])
m.N2<-lm(N2~TajD , data=dat[!sel,])

summary(m.N)
summary(m.N1)
summary(m.N2)

Population_CodeT<-c(as.vector(dat$Population_Code)[sel],
                    as.vector(dat$Population_Code)[!sel])
tem_data<-data.frame(Population_Code=factor(Population_CodeT, 
             levels=c(as.vector(tree_without_unsampled$tip.label))), N, TD) %>% 
  arrange(Population_Code) 
row.names(tem_data)<-tem_data$Population_Code

fit<-gls(N~TD, tem_data)
fit_withCorrection<-gls(N~TD, tem_data, correlation=corPagel(0.2,tree_without_unsampled, fixed=FALSE),method="ML")

summary(fit)
summary(fit_withCorrection)


#--> N1 and N2 correlate with TajD -> hence TajD can be used a summary stats for demographic change

###########
####reduce number of explanatory variables by looking at their correlation
##########
dat

dat$Land_Predator<-as.numeric(dat$Land_Predator)
dat$Copulation_WaterorLand<-as.numeric(dat$Copulation_WaterorLand)
dat$Diving_depth<-as.numeric(dat$Diving_depth)
dat$Female_group_size<-as.numeric(dat$Female_group_size)
dat$Fur_dimorphism<-as.numeric(dat$Fur_dimorphism)
dat$Breeding_IceorLand<-as.numeric(dat$Breeding_IceorLand)
dat$Land_Preinputor<-as.numeric(dat$Land_Preinputor)

cor_data<-dat %>% 
  select(TajD, Theta_pi, 
         MeanSSD, 
         Harem_size, 
         Season_length, 
         Lactation_length, 
         Generation_time_species,
         Breeding_latitude, 
         Breeding_IceorLand, 
         Estimated_area_occupancy) %>% 
  data.frame()


intercor<-round(cor(cor_data),2)
write.csv(intercor,"./Collinearity.csv")


###########
##### which factors influence susceptibility to demographic change (Stoffels suggest MeanSSD + IceorLand)
############

response<-dat$TajD
m.full<-lm(response ~ Harem_size + Season_length + Breeding_IceorLand  + Estimated_area_occupancy,  data=dat)
summary(m.full)

#fit all possible combinations of single and two factor models only - no more to avoid overparameterization
# each demographic model was test additionally for phylogenetic correction with the same line as above. 
lm0<-lm(response ~ 1, data=dat)
lm1.1<-lm(response ~ Harem_size, data=dat)
lm1.2<-lm(response ~ Season_length, data=dat)
lm1.3<-lm(response ~ Breeding_IceorLand, data=dat)
lm1.4<-lm(response ~ Estimated_area_occupancy, data=dat) # to be run with phylogenetic control
lm2.1<-lm(response ~ Harem_size + Season_length, data=dat)
lm2.2<-lm(response ~ Harem_size + Breeding_IceorLand, data=dat)
lm2.3<-lm(response ~ Harem_size + Estimated_area_occupancy, data=dat)
lm2.4<-lm(response ~ Season_length + Breeding_IceorLand, data=dat)
lm2.5<-lm(response ~ Season_length + Estimated_area_occupancy, data=dat)
lm2.6<-lm(response ~ Breeding_IceorLand + Estimated_area_occupancy, data=dat)

##AIC based check
n<-dim(dat)[1]
aic.models<-AIC(lm0,lm1.1,lm1.2,lm1.3,lm1.4, lm2.1,lm2.2,lm2.3,lm2.4,lm2.5,lm2.6,m.full) 
aic<-aic.models$AIC
k<-I(aic.models$df)  
AICc<-aic+2*k*(k+1)/(n-k-1)
deltaAIC<-I(aic-min(aic.models[,2]))
deltaAICc<-I(AICc-min(AICc)) 
wAIC<-exp(-deltaAIC/2)/sum(exp(-deltaAIC/2))
wAICc<-exp(-deltaAICc/2)/sum(exp(-deltaAICc/2))
bic<-AIC(lm0,lm1.1,lm1.2,lm1.3,lm1.4, lm2.1,lm2.2,lm2.3,lm2.4,lm2.5,lm2.6,m.full,k=log(n))$AIC 

result.aic<-data.frame("model"=rownames(aic.models),
                       k,"AIC"=aic,"AICc"=round(AICc,3),"deltaAIC"=round(deltaAIC,3),"deltaAICc"=round(deltaAICc,3),
                       "wAIC"=round(wAIC,3),"wAICc"=round(wAICc,3),bic)

result.aic<-result.aic[order(result.aic$AICc),]#sorted AIC table
result.aic
write.csv(result.aic,"./Rout_TajD.csv",row.names=F)

#--> not strong evidence for either of the Stoffels factors (interpreted to be due to human impact) contributing. Good, makes sense.

###########
#####fitting 'response corrected for factors influencing it' 
############

response<-dat$Ne_Nc
m.full<-lm(response ~ TajD + Harem_size + Season_length + Breeding_latitude + Breeding_IceorLand,  data=dat)
summary(m.full)


#fit all possible combinations of single and two factor models only - no more to avoid overparameterization
# each model was addicionally tested with phylogenetic correction as before. 

lm0<-lm(response ~ 1, data=dat)
lm1.1<-lm(response ~ TajD, data=dat)
lm1.2<-lm(response ~ Harem_size, data=dat)
lm1.3<-lm(response ~ Season_length, data=dat)
lm1.4<-lm(response ~ Breeding_IceorLand, data=dat)
lm1.5<-lm(response ~ Breeding_latitude, data=dat)
lm2.1<-lm(response ~ TajD + Harem_size, data=dat)
lm2.2<-lm(response ~ TajD + Season_length, data=dat)
lm2.3<-lm(response ~ TajD + Breeding_IceorLand, data=dat)
lm2.4<-lm(response ~ TajD + Breeding_latitude, data=dat) # to be run with phylogenetic control
lm2.5<-lm(response ~ Harem_size + Season_length, data=dat)
lm2.6<-lm(response ~ Harem_size + Breeding_IceorLand, data=dat)
lm2.7<-lm(response ~ Harem_size + Breeding_latitude, data=dat)
lm2.8<-lm(response ~ Season_length + Breeding_IceorLand, data=dat)
lm2.9<-lm(response ~ Season_length + Breeding_latitude, data=dat)
lm2.10<-lm(response ~ Breeding_IceorLand + Breeding_latitude, data=dat)

##AIC based check
n<-dim(dat)[1]

aic.models<-AIC(lm0,lm1.1,lm1.2,lm1.3,lm1.4,lm1.5,lm2.1,lm2.2,lm2.3,lm2.4,lm2.5,lm2.6,lm2.7,lm2.8,lm2.9,lm2.10,m.full)
aic<-aic.models$AIC
k<-I(aic.models$df)  
AICc<-aic+2*k*(k+1)/(n-k-1)
deltaAIC<-I(aic-min(aic.models[,2]))
deltaAICc<-I(AICc-min(AICc)) 
wAIC<-exp(-deltaAIC/2)/sum(exp(-deltaAIC/2))
wAICc<-exp(-deltaAICc/2)/sum(exp(-deltaAICc/2))
bic<-AIC(lm0,lm1.1,lm1.2,lm1.3,lm1.4,lm1.5,lm2.1,lm2.2,lm2.3,lm2.4,lm2.5,lm2.6,lm2.7,lm2.8,lm2.9,lm2.10,m.full,k=log(n))$AIC
result.aic<-data.frame("model"=rownames(aic.models),
                       k,"AIC"=aic,"AICc"=round(AICc,3),"deltaAIC"=round(deltaAIC,3),"deltaAICc"=round(deltaAICc,3),
                       "wAIC"=round(wAIC,3),"wAICc"=round(wAICc,3),bic)
result.aic<-result.aic[order(result.aic$AICc),]#sorted AIC table
write.csv(result.aic,"./Rout_NeNc.csv",row.names=F)

#--> best models m.back.final and m.for.final based on AIC only m.back.1

summary(lm(dat$Ne_GTclade~dat$TajD))
summary(lm(dat$Nc_subspecies_IUCN~dat$TajD))
summary(lm(dat$TajD~dat$Ne_GTclade + dat$Nc_subspecies_IUCN))

#######
###look at the residuals to see if that explains IUCN categories
#######
# for Ne_Nc use lm2.4

response<-dat$Ne_Nc
model<-lm1.1#m.for.final

diff<-exp(response)-exp(predict(model))

#if Ne/Nc is higher than Ne/Nc predicted that can be ineterpreted as being due to relatively low Nc due to recent pop change
#hence for positive diff a species is in trouble
plot(exp(response),type="n")
text(1:17,exp(response),dat$Species_abbreviation)
text(1:17,exp(predict(model)),dat$Species_abbreviation,col="red")

##strongest outliers are tropical species (ArcGal, ZalWol) and EumJub
plot(diff,type="n")
text(1:17,diff,dat$Species_abbreviation)
abline(h=0)

#overall species of CONCERN have higher positive diff then species of LC --> IUCN cats capture this!
plot(exp(response)~dat$IUCN_cat_subspecies)
plot(diff~dat$IUCN_cat_subspecies,ylab="delta Ne/Nc") # Figure 3B

dat$predicted_Ne_Nc<-predict(model)

# phylogenetic test
resexplain<-lm(diff ~ dat$IUCN_cat_subspecies) #--> explains IUCN category exp first, otherwise we take the ratio (log(a)-log(b) = log(a/b) --> response-predicted)
oriexplain<-lm(exp(response) ~ dat$IUCN_cat_subspecies) # --> does not explain IUCN category
summary(resexplain)
summary(oriexplain)

## using the species cathegories:
resexplain_sp<-lm(diff ~ dat$IUCN_cat_subspecies) #--> explains IUCN category exp first, otherwise we take the ratio (log(a)-log(b) = log(a/b) --> response-predicted)
oriexplain_sp<-lm(exp(response) ~ dat$IUCN_cat_subspecies) # --> does not explain IUCN category
summary(resexplain_sp)
summary(oriexplain_sp)


# we can now add back all others populations for which we have specific Nc estimates
# merge species specific predictions with full data set

a<-data.frame(Species_abbreviation=dat$Species_abbreviation,Ne_Nc_pre=predict(model))
dat3<-merge(a,dat2,all.y=T)
diff2<-exp(dat3$Ne_Nc)-exp(dat3$Ne_Nc_pre)

plot(dat3$Ne_Nc,type="n")
text(1:36,dat3$Ne_Nc,dat3$Species_abbreviation)
text(1:36,dat3$Ne_Nc_pre,dat3$Species_abbreviation,col="red")

##strongest outliers are PusHis populations (makes total sense) and tropical species (ArcGal, ZalWol) and EumJub
plot(diff2,type="n",log="y")
text(1:36,diff2,dat3$Species_abbreviation)
abline(h=0)

plot(dat3$Ne_Nc~dat3$IUCN_cat)
plot(diff2~dat3$IUCN_cat)

#correlation with IUCN cat gets lost when specific populations are included

resexplain<-lm(diff2 ~ dat3$IUCN_cat_subspecies) #--> explains IUCN category exp first, otherwise we take the ratio (log(a)-log(b) = log(a/b) --> response-predicted)
oriexplain<-lm(exp(dat3$Ne_Nc) ~ dat3$IUCN_cat_subspecies) # --> does not explain IUCN category
summary(resexplain)
summary(oriexplain)

plot(exp(response)~dat$IUCN_cat)
plot(diff~dat$IUCN_cat,ylab="delta Ne/Nc") # Figure 3B
resexplain<-lm(diff ~ dat$IUCN_cat) #--> explains IUCN category exp first, otherwise we take the ratio (log(a)-log(b) = log(a/b) --> response-predicted)
oriexplain<-lm(exp(response) ~ dat$IUCN_cat) # --> does not explain IUCN category
summary(resexplain)
summary(oriexplain)

