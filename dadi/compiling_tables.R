# ==================================================
# Documents and scripts were written by: Sergio Tusso
# Evolutionary Biology Center, Uppsala University, Sweden
# 2019
# email: sergio.tusso@evobio.eu
# +++++++++++++++++++++++++++++++++++++++++++++++++

library("ggplot2")
library("ggcorrplot") # this is to produce the correlation plot
library("dplyr")
library("tidyr")
library("plyr")
library("extRemes") # this package was used to perform Likelihood Ratio Test
library("ggpubr") # for multiple plots


# Loading data
# there are 4 replicates for each model with 100 bootstraps for each replicate:
data_neutral<- read.table("summary_table_neutral_model.txt", T) %>% mutate(model="neutral")

data_twopopchanges<- read.table("summary_table_twopopchanges.txt", T)  %>% mutate(model="twopopchanges")
data_twopopchangesr1<- read.table("summary_table_twopopchanges_R1.txt", T)  %>% mutate(model="twopopchangesr1")
data_twopopchangesr2<- read.table("summary_table_twopopchanges_R2.txt", T)  %>% mutate(model="twopopchangesr2")
data_twopopchangesr3<- read.table("summary_table_twopopchanges_R3.txt", T)  %>% mutate(model="twopopchangesr3")

data_growthplusbottle<- read.table("summary_table_growthplusbottle.txt", T) %>% mutate(model="growthplusbottle")
data_growthplusbottler1<- read.table("summary_table_growthplusbottle_R1.txt", T) %>% mutate(model="growthplusbottler1")
data_growthplusbottler2<- read.table("summary_table_growthplusbottle_R2.txt", T) %>% mutate(model="growthplusbottler2")
data_growthplusbottler3<- read.table("summary_table_growthplusbottle_R3.txt", T) %>% mutate(model="growthplusbottler3")

data_bottleplusgrowth<- read.table("summary_table_bottleplusgrowth.txt", T)  %>% mutate(model="bottleplusgrowth")
data_bottleplusgrowthr1<- read.table("summary_table_bottleplusgrowth_R1.txt", T)  %>% mutate(model="bottleplusgrowthr1")
data_bottleplusgrowthr2<- read.table("summary_table_bottleplusgrowth_R2.txt", T)  %>% mutate(model="bottleplusgrowthr2")
data_bottleplusgrowthr3<- read.table("summary_table_bottleplusgrowth_R3.txt", T)  %>% mutate(model="bottleplusgrowthr3")

data_bottlepop<- read.table("summary_table_bottlepop.txt", T) %>% mutate(model="bottlepop")
data_bottlepopr1<- read.table("summary_table_bottlepop_R1.txt", T) %>% mutate(model="bottlepopr1")
data_bottlepopr2<- read.table("summary_table_bottlepop_R2.txt", T) %>% mutate(model="bottlepopr2")
data_bottlepopr3<- read.table("summary_table_bottlepop_R3.txt", T) %>% mutate(model="bottlepopr3")

data_growth<- read.table("summary_table_growth.txt", T) %>% mutate(model="growth")
data_growthr1<- read.table("summary_table_growth_R1.txt", T) %>% mutate(model="growthr1")
data_growthr2<- read.table("summary_table_growth_R2.txt", T) %>% mutate(model="growthr2")
data_growthr3<- read.table("summary_table_growth_R3.txt", T) %>% mutate(model="growthr3")


# Information per species and population:
species_information<-read.table("information_per_species.txt", T) %>% mutate(sp=file) %>% select(-file)

# Loading number of individuals per population:
n_values<-read.table("n_values_ed.txt", T) 

# Loading population parameters (Pi, Theta, TajsD):
pi_data<-read.table("All_diversitystats_diffMin_ed.txt", T) %>% 
	merge(n_values, by=c("sizeFiltering","pop","lib","sp","completion","others")) 


# From each replicate we extracted information of likelihood to compare between replicates and models: 
# Comparison between replicates and models:
pre_ed_twopopchanges_likelihood<-data_twopopchanges %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_twopopchanges_likelihoodr1<-data_twopopchangesr1 %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_twopopchanges_likelihoodr2<-data_twopopchangesr2 %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_twopopchanges_likelihoodr3<-data_twopopchangesr3 %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")

pre_ed_growthplusbottle_likelihood<-data_growthplusbottle %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_growthplusbottle_likelihoodr1<-data_growthplusbottler1 %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_growthplusbottle_likelihoodr2<-data_growthplusbottler2 %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_growthplusbottle_likelihoodr3<-data_growthplusbottler3 %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")

pre_ed_bottleplusgrowth_likelihood<-data_bottleplusgrowth %>% mutate(TB=T, TF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_bottleplusgrowth_likelihoodr1<-data_bottleplusgrowthr1 %>% mutate(TB=T, TF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_bottleplusgrowth_likelihoodr2<-data_bottleplusgrowthr2 %>% mutate(TB=T, TF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_bottleplusgrowth_likelihoodr3<-data_bottleplusgrowthr3 %>% mutate(TB=T, TF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")

pre_ed_bottlepop_likelihood<-data_bottlepop %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_bottlepop_likelihoodr1<-data_bottlepopr1 %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_bottlepop_likelihoodr2<-data_bottlepopr2 %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_bottlepop_likelihoodr3<-data_bottlepopr3 %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")

pre_ed_growth_likelihood<-data_growth %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_growth_likelihoodr1<-data_growthr1 %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_growth_likelihoodr2<-data_growthr2 %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")
pre_ed_growth_likelihoodr3<-data_growthr3 %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")

pre_ed_neutral_likelihood<-data_neutral %>% mutate(nuB=1, nuF="NA", TB=0, TF="NA", var_nuB="NA", var_nuF="NA", var_TB="NA", var_TF="NA") %>% select("sizeFiltering", "pop", "lib", "sp", "completion", "others", "nuB", "nuF", "TB", "TF", "log_likelihood", "var_nuB", "var_nuF", "var_TB", "var_TF", "var_log_likelihood", "bootstraps", "model")

# Function to calculate SD
sd_from_var <- function(x){
  sd_vector<-c()
  for (value in seq(1, length(x))){
    if (x[value]!="NA"){
      sd_vector[value]<-sqrt(as.numeric(x[value]))
    } else {
      sd_vector[value]<-NA
    }
  }
  return(sd_vector)
}


# Function to calculate log 10 from a vector:
log10_vector <- function(x){
  log10_vector<-c()
  for (value in seq(1, length(x))){
    if (is.na(x[value]) | x[value]==0 ){
      log10_vector[value]<-0
    } else {
      log10_vector[value]<-log10(as.numeric(x[value]))
    }
  }
  return(log10_vector)
}


#compiling likelihhod tables:
likelihood_table_pre_ed<-rbind(pre_ed_twopopchanges_likelihood, 
    pre_ed_twopopchanges_likelihoodr1, 
    pre_ed_twopopchanges_likelihoodr2, 
    pre_ed_twopopchanges_likelihoodr3, 
    pre_ed_growthplusbottle_likelihood, 
    pre_ed_growthplusbottle_likelihoodr1, 
    pre_ed_growthplusbottle_likelihoodr2, 
    pre_ed_growthplusbottle_likelihoodr3, 
    pre_ed_bottleplusgrowth_likelihood, 
    pre_ed_bottleplusgrowth_likelihoodr1, 
    pre_ed_bottleplusgrowth_likelihoodr2, 
    pre_ed_bottleplusgrowth_likelihoodr3, 
    pre_ed_bottlepop_likelihood, 
    pre_ed_bottlepop_likelihoodr1, 
    pre_ed_bottlepop_likelihoodr2, 
    pre_ed_bottlepop_likelihoodr3, 
    pre_ed_growth_likelihood, 
    pre_ed_growth_likelihoodr1, 
    pre_ed_growth_likelihoodr2, 
    pre_ed_growth_likelihoodr3, 
    pre_ed_neutral_likelihood) %>% mutate(sd_nuB=sd_from_var(var_nuB), sd_nuF=sd_from_var(var_nuF), sd_TB=sd_from_var(var_TB), sd_TF=sd_from_var(var_TF), sd_log_likelihood=sd_from_var(var_log_likelihood))

likelihood_table_pre_ed$model <- factor(likelihood_table_pre_ed$model, levels = c("neutral", 
                                                                                  "bottlepop", 
                                                                                  "bottlepopr1", 
                                                                                  "bottlepopr2", 
                                                                                  "bottlepopr3", 
                                                                                  "growth", 
                                                                                  "growthr1", 
                                                                                  "growthr2", 
                                                                                  "growthr3", 
                                                                                  "bottleplusgrowth", 
                                                                                  "bottleplusgrowthr1", 
                                                                                  "bottleplusgrowthr2", 
                                                                                  "bottleplusgrowthr3", 
                                                                                  "growthplusbottle", 
                                                                                  "growthplusbottler1", 
                                                                                  "growthplusbottler2", 
                                                                                  "growthplusbottler3", 
                                                                                  "twopopchanges", 
                                                                                  "twopopchangesr1", 
                                                                                  "twopopchangesr2", 
                                                                                  "twopopchangesr3"))

likelihood_table_pre_ed$TB<-as.numeric(likelihood_table_pre_ed$TB)

# using per chromosome values but with different filtering size:
likelihood_table_pre_ed2<-merge(likelihood_table_pre_ed, pi_data, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others"), all.x=TRUE) %>% 
	merge(sd_pi_data, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others"), all.x=TRUE)


# re-formatting step
compressed_model<-c()
for (line in likelihood_table_pre_ed$model){
  if (line=="neutral"){
    compressed_model<-c(compressed_model, "neutral")
  }
  if (line %in% c("bottlepop", "bottlepopr1", "bottlepopr2", "bottlepopr3")){
    compressed_model<-c(compressed_model, "bottle")
  }
  if (line %in% c("growth", "growthr1", "growthr2", "growthr3")){
    compressed_model<-c(compressed_model, "growth")
  }
  if (line %in% c("bottleplusgrowth", "bottleplusgrowthr1", "bottleplusgrowthr2", "bottleplusgrowthr3")){
    compressed_model<-c(compressed_model, "bottleplusgrowth")
  }
  if (line %in% c("growthplusbottle", "growthplusbottler1", "growthplusbottler2", "growthplusbottler3")){
    compressed_model<-c(compressed_model, "growthplusbottle")
  }
  if (line %in% c("twopopchanges", "twopopchangesr1", "twopopchangesr2", "twopopchangesr3")){
    compressed_model<-c(compressed_model, "twopopchanges")
  }
}

likelihood_table_pre_ed <- cbind(likelihood_table_pre_ed, compressed_model)
likelihood_table_pre_ed$compressed_model <- factor(likelihood_table_pre_ed$compressed_model, 
  levels = c("neutral", "bottle", "growth", "bottleplusgrowth", "growthplusbottle", "twopopchanges"))

likelihood_table_pre_ed2 <- cbind(likelihood_table_pre_ed2, compressed_model)
likelihood_table_pre_ed2$compressed_model <- factor(likelihood_table_pre_ed2$compressed_model, 
  levels = c("neutral", "bottle", "growth", "bottleplusgrowth", "growthplusbottle", "twopopchanges"))


######
# this section identifies the replicate with the highest likelihood within each model:
select_replicate <- function(x_lr1, 
                            x_lr2, 
                            x_lr3, 
                            x_l){
  column_replicate<-c()
  for (line in seq(1, length(x_l))){
    max_value<-max(x_lr1[line], 
      x_lr2[line], 
      x_lr3[line], 
      x_l[line])
    column_replicate<-c(column_replicate, which(c(x_lr1[line], 
      x_lr2[line], 
      x_lr3[line], 
      x_l[line])==max_value))
  }
  return(column_replicate)
}

data_bottlepop_com<-rbind(data_bottlepopr1,
                          data_bottlepopr2,
                          data_bottlepopr3,
                          data_bottlepop) %>% 
                    select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model) %>% 
                    group_by(sizeFiltering, pop, lib, sp, completion, others) %>% 
                    spread(log_likelihood, key=model) %>% 
                    #filter(!(is.na(data_bottlepopr))) %>% 
                    #filter(!(is.na(data_bottlepopr1))) %>% 
                    #filter(!(is.na(data_bottlepopr2))) %>% 
                    #filter(!(is.na(data_bottlepopr3))) %>% 
                    mutate(max_bottlepop=select_replicate(bottlepopr1, 
                                                          bottlepopr2, 
                                                          bottlepopr3, 
                                                          bottlepop)) %>% 
                    ungroup() %>%  
                    select(sizeFiltering, pop, lib, sp, completion, others, max_bottlepop)


data_growth_com<-rbind(data_growthr1,
                      data_growthr2,
                      data_growthr3,
                      data_growth) %>% 
    select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model) %>% 
    group_by(sizeFiltering, pop, lib, sp, completion, others) %>% 
    spread(log_likelihood, key=model) %>% 
    #filter(!(is.na(bottleplusgrowthr2))) %>% 
    mutate(max_growth=select_replicate(growthr1, 
                                      growthr2, 
                                      growthr3, 
                                      growth)) %>% 
    ungroup() %>%  
    select(sizeFiltering, pop, lib, sp, completion, others, max_growth)


data_growthplusbottle_com<-rbind(data_growthplusbottler1,
                                  data_growthplusbottler2,
                                  data_growthplusbottler3,
                                  data_growthplusbottle) %>% 
                          select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model) %>% 
                          group_by(sizeFiltering, pop, lib, sp, completion, others) %>% 
                          spread(log_likelihood, key=model) %>% 
                          #filter(!(is.na(bottleplusgrowthr2))) %>% 
                          mutate(max_growthplusbottle=select_replicate(growthplusbottler1, 
                                                                        growthplusbottler2, 
                                                                        growthplusbottler3, 
                                                                        growthplusbottle)) %>% 
                          ungroup() %>%  
                          select(sizeFiltering, pop, lib, sp, completion, others, max_growthplusbottle)

data_bottleplusgrowth_com<-rbind(data_bottleplusgrowthr1,
                                  data_bottleplusgrowthr2,
                                  data_bottleplusgrowthr3,
                                  data_bottleplusgrowth) %>% 
                            select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model) %>% 
                            group_by(sizeFiltering, pop, lib, sp, completion, others) %>% 
                            spread(log_likelihood, key=model) %>% 
                            #filter(!(is.na(bottleplusgrowthr2))) %>% 
                            mutate(max_bottleplusgrowth=select_replicate(bottleplusgrowthr1, 
                                                                          bottleplusgrowthr2, 
                                                                          bottleplusgrowthr3, 
                                                                          bottleplusgrowth)) %>% 
                            ungroup() %>%  
                            select(sizeFiltering, pop, lib, sp, completion, others, max_bottleplusgrowth)


data_twopopchanges_com<-rbind(data_twopopchangesr1,
                                  data_twopopchangesr2,
                                  data_twopopchangesr3,
                                  data_twopopchanges) %>% 
                            select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model) %>% 
                            group_by(sizeFiltering, pop, lib, sp, completion, others) %>% 
                            spread(log_likelihood, key=model) %>% 
                            #filter(!(is.na(twopopchangesr2))) %>% 
                            mutate(max_twopopchanges=select_replicate(twopopchangesr1, 
                                                                          twopopchangesr2, 
                                                                          twopopchangesr3, 
                                                                          twopopchanges)) %>% 
                            ungroup() %>%  
                            select(sizeFiltering, pop, lib, sp, completion, others, max_twopopchanges)


sub_data_growthplusbottler1<- merge(data_growthplusbottler1, data_growthplusbottle_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_growthplusbottle==1)
sub_data_growthplusbottler2<- merge(data_growthplusbottler2, data_growthplusbottle_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_growthplusbottle==2)
sub_data_growthplusbottler3<- merge(data_growthplusbottler3, data_growthplusbottle_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_growthplusbottle==3)
sub_data_growthplusbottle<- merge(data_growthplusbottle, data_growthplusbottle_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_growthplusbottle==4)

sub_data_bottleplusgrowthr1<- merge(data_bottleplusgrowthr1, data_bottleplusgrowth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_bottleplusgrowth==1)
sub_data_bottleplusgrowthr2<- merge(data_bottleplusgrowthr2, data_bottleplusgrowth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_bottleplusgrowth==2)
sub_data_bottleplusgrowthr3<- merge(data_bottleplusgrowthr3, data_bottleplusgrowth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_bottleplusgrowth==3)
sub_data_bottleplusgrowth<- merge(data_bottleplusgrowth, data_bottleplusgrowth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
    filter(max_bottleplusgrowth==4)


# from each replicate with filtes data, leaving only those replicates with the highest likelihhod:
sub_data_bottlepopr1<- merge(data_bottlepopr1, data_bottlepop_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_bottlepop==1)
sub_data_bottlepopr2<- merge(data_bottlepopr2, data_bottlepop_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_bottlepop==2)
sub_data_bottlepopr3<- merge(data_bottlepopr3, data_bottlepop_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_bottlepop==3)
sub_data_bottlepop<- merge(data_bottlepop, data_bottlepop_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_bottlepop==4)

sub_data_growthr1<- merge(data_growthr1, data_growth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_growth==1)
sub_data_growthr2<- merge(data_growthr2, data_growth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_growth==2)
sub_data_growthr3<- merge(data_growthr3, data_growth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_growth==3)
sub_data_growth<- merge(data_growth, data_growth_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_growth==4)

sub_data_twopopchangesr1<- merge(data_twopopchangesr1, data_twopopchanges_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_twopopchanges==1)
sub_data_twopopchangesr2<- merge(data_twopopchangesr2, data_twopopchanges_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_twopopchanges==2)
sub_data_twopopchangesr3<- merge(data_twopopchangesr3, data_twopopchanges_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_twopopchanges==3)
sub_data_twopopchanges<- merge(data_twopopchanges, data_twopopchanges_com ,by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(max_twopopchanges==4)

maxRep_twopopchanges<-rbind(sub_data_twopopchangesr1, sub_data_twopopchangesr2, sub_data_twopopchangesr3, sub_data_twopopchanges) %>% mutate(model="twopopchanges")
maxRep_growthplusbottle<-rbind(sub_data_growthplusbottler1, sub_data_growthplusbottler2, sub_data_growthplusbottler3, sub_data_growthplusbottle) %>% mutate(model="growthplusbottle")
maxRep_bottleplusgrowth<-rbind(sub_data_bottleplusgrowthr1, sub_data_bottleplusgrowthr2, sub_data_bottleplusgrowthr3, sub_data_bottleplusgrowth) %>% mutate(model="bottleplusgrowth")
maxRep_bottlepop<-rbind(sub_data_bottlepopr1, sub_data_bottlepopr2, sub_data_bottlepopr3, sub_data_bottlepop) %>% mutate(model="bottlepop")
maxRep_growth<-rbind(sub_data_growthr1, sub_data_growthr2, sub_data_growthr3, sub_data_growth) %>% mutate(model="growth")

maxRep_twopopchanges_likelihood<-maxRep_twopopchanges %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, bootstraps, model)
maxRep_bottleplusgrowth_likelihood<-maxRep_bottleplusgrowth %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, bootstraps, model)
maxRep_bottlepop_likelihood<-maxRep_bottlepop %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, bootstraps, model)
maxRep_growthplusbottle_likelihood<-maxRep_growthplusbottle %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, bootstraps, model)
maxRep_growth_likelihood<-maxRep_growth %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, bootstraps, model)
maxRep_neutral_likelihood<-data_neutral %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, bootstraps, model)

maxRep_twopopchanges_likelihood<-maxRep_twopopchanges %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model)
maxRep_bottleplusgrowth_likelihood<-maxRep_bottleplusgrowth %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model)
maxRep_bottlepop_likelihood<-maxRep_bottlepop %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model)
maxRep_growthplusbottle_likelihood<-maxRep_growthplusbottle %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model)
maxRep_growth_likelihood<-maxRep_growth %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model)
maxRep_neutral_likelihood<-data_neutral %>% select(sizeFiltering, pop, lib, sp, completion, others, log_likelihood, model)


# the we compiled a single table with one replicate per model (the replicate with the highest likelihood).
likelihood_table<-rbind(maxRep_neutral_likelihood, maxRep_bottlepop_likelihood, maxRep_growth_likelihood, maxRep_bottleplusgrowth_likelihood, maxRep_growthplusbottle_likelihood, maxRep_twopopchanges_likelihood) 

## Model comparison:
# this function run likelihood ratio test for a pair of models:
lr_test <- function(x, y, alpha, dfx) {
  vector_pvalues<-c()
  for (i in seq(1,length(x))){
    test<-lr.test(as.vector(x[i])*(-1),as.vector(y[i])*(-1),alpha = 0.05, df = dfx)
    vector_pvalues<-c(vector_pvalues,as.vector(test$p.value))
  }
  return(vector_pvalues)
}

table_with_pvalues<-likelihood_table %>% 
	group_by(sizeFiltering, pop, lib, sp, completion, others) %>% 
	spread(model, log_likelihood) %>% 
	mutate(pvalue_neutral_bottle=lr_test(neutral, bottlepop, 0.05, 2), pvalue_neutral_growth=lr_test(neutral, growth, 0.05, 2), pvalue_bottle_bottleplusgrowth=lr_test(bottlepop, bottleplusgrowth, 0.05, 1), pvalue_bottleplusgrowth_growthplusbottle=lr_test(bottleplusgrowth, growthplusbottle, 0.05, 1), pvalue_bottleplusgrowth_twopopchanges=lr_test(bottleplusgrowth, twopopchanges, 0.05, 1)) %>% 
	select(sizeFiltering, pop, lib, sp, completion, others, neutral, bottlepop, pvalue_neutral_bottle, growth, pvalue_neutral_growth, bottleplusgrowth, pvalue_bottle_bottleplusgrowth, growthplusbottle, pvalue_bottleplusgrowth_growthplusbottle, twopopchanges, pvalue_bottleplusgrowth_twopopchanges)


# this function selects the best demographic model:
select_model <- function(x) {
  selected_model<-c()
  for (i in seq(1,length(x$pop))){
    if (x$pvalue_neutral_bottle[i]<0.05 | x$pvalue_neutral_growth[i]<0.05){
      # model is not neutral:
      if (x$pvalue_neutral_growth[i]<0.05){
        if (x$growth[i]>x$bottlepop[i]){
          # growth of complex
          if (x$pvalue_bottle_bottleplusgrowth[i]<0.05) {
            if (x$pvalue_bottleplusgrowth_growthplusbottle[i]<0.05 | x$pvalue_bottleplusgrowth_twopopchanges[i]<0.05){
              # 4 par model
              if (x$growthplusbottle[i]>x$twopopchanges[i]){
                #growthplusbottle
                selected_model<-c(selected_model, "growthplusbottle")
              } else {
                #twopopchanges
                selected_model<-c(selected_model, "twopopchanges")
              }
            } else {
              selected_model<-c(selected_model, "bottleplusgrowth")
            }
          } else {
            selected_model<-c(selected_model, "growth")
          }
        } else {
          # bottle or complex
          if (x$pvalue_bottle_bottleplusgrowth[i]<0.05) {
            if (x$pvalue_bottleplusgrowth_growthplusbottle[i]<0.05 | x$pvalue_bottleplusgrowth_twopopchanges[i]<0.05){
              # 4 par model
              if (x$growthplusbottle[i]>x$twopopchanges[i]){
                #growthplusbottle
                selected_model<-c(selected_model, "growthplusbottle")
              } else {
                #twopopchanges
                selected_model<-c(selected_model, "twopopchanges")
              }
            } else {
              selected_model<-c(selected_model, "bottleplusgrowth")
            }
          } else {
            selected_model<-c(selected_model, "bottle")
          }
        }
      } else {
        # bottle or complex
        if (x$pvalue_bottle_bottleplusgrowth[i]<0.05) {
          if (x$pvalue_bottleplusgrowth_growthplusbottle[i]<0.05 | x$pvalue_bottleplusgrowth_twopopchanges[i]<0.05){
            # 4 par model
            if (x$growthplusbottle[i]>x$twopopchanges[i]){
              #growthplusbottle
              selected_model<-c(selected_model, "growthplusbottle")
            } else {
              #twopopchanges
              selected_model<-c(selected_model, "twopopchanges")
            }
          } else {
            selected_model<-c(selected_model, "bottleplusgrowth")
          }
        } else {
          selected_model<-c(selected_model, "bottle")
        }
      }
    } else {
      selected_model<-c(selected_model, "neutral")
    }
  }
  return(selected_model)
}

# this is the final table with pvalues for each demographic model:
table_with_pvalues<-table_with_pvalues %>% mutate(sel_model=select_model(table_with_pvalues))

names(table_with_pvalues)<- c("sizeFiltering", "pop", "lib", "sp", "completion", "others", "neutral_Likelihood", "bottlepop__Likelihood", "pvalue_neutral_bottle", "growth_Likelihood", "pvalue_neutral_growth", "bottleplusgrowth_Likelihood", "pvalue_bottle_bottleplusgrowth", "growthplusbottle_Likelihood", "pvalue_bottleplusgrowth_growthplusbottle", "twopopchanges_Likelihood", "pvalue_bottleplusgrowth_twopopchanges", "sel_model")

write.table(table_with_pvalues, file = "table_with_pvalues2_perChr_filtering.txt", append = FALSE, quote = F, sep = "\t", row.names = F)

# formatting steps:
maxRep_twopopchanges_selmodel<-merge(maxRep_twopopchanges,table_with_pvalues, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(sel_model==model) %>% select(sizeFiltering, pop, lib, sp, completion, others, nuB, nuF, TB, TF, log_likelihood, var_nuB, var_nuF, var_TB, var_TF, var_log_likelihood, bootstraps, model, sel_model, neutral_Likelihood, bottlepop__Likelihood, pvalue_neutral_bottle, growth_Likelihood, pvalue_neutral_growth, bottleplusgrowth_Likelihood, pvalue_bottle_bottleplusgrowth, growthplusbottle_Likelihood, pvalue_bottleplusgrowth_growthplusbottle, twopopchanges_Likelihood, pvalue_bottleplusgrowth_twopopchanges)
maxRep_bottleplusgrowth_selmodel<-merge(maxRep_bottleplusgrowth,table_with_pvalues, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(sel_model==model) %>% mutate(TB=T, TF="NA", var_TB=var_T, var_TF="NA") %>% select(sizeFiltering, pop, lib, sp, completion, others, nuB, nuF, TB, TF, log_likelihood, var_nuB, var_nuF, var_TB, var_TF, var_log_likelihood, bootstraps, model, sel_model, neutral_Likelihood, bottlepop__Likelihood, pvalue_neutral_bottle, growth_Likelihood, pvalue_neutral_growth, bottleplusgrowth_Likelihood, pvalue_bottle_bottleplusgrowth, growthplusbottle_Likelihood, pvalue_bottleplusgrowth_growthplusbottle, twopopchanges_Likelihood, pvalue_bottleplusgrowth_twopopchanges)
maxRep_bottlepop_selmodel<-merge(maxRep_bottlepop,table_with_pvalues, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(sel_model=="bottle") %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select(sizeFiltering, pop, lib, sp, completion, others, nuB, nuF, TB, TF, log_likelihood, var_nuB, var_nuF, var_TB, var_TF, var_log_likelihood, bootstraps, model, sel_model, neutral_Likelihood, bottlepop__Likelihood, pvalue_neutral_bottle, growth_Likelihood, pvalue_neutral_growth, bottleplusgrowth_Likelihood, pvalue_bottle_bottleplusgrowth, growthplusbottle_Likelihood, pvalue_bottleplusgrowth_growthplusbottle, twopopchanges_Likelihood, pvalue_bottleplusgrowth_twopopchanges)
maxRep_growth_selmodel<-merge(maxRep_growth,table_with_pvalues, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(sel_model==model) %>% mutate(nuB=nu, nuF="NA", TB=T, TF="NA", var_nuB=var_nu, var_nuF="NA", var_TB=var_T, var_TF="NA") %>% select(sizeFiltering, pop, lib, sp, completion, others, nuB, nuF, TB, TF, log_likelihood, var_nuB, var_nuF, var_TB, var_TF, var_log_likelihood, bootstraps, model, sel_model, neutral_Likelihood, bottlepop__Likelihood, pvalue_neutral_bottle, growth_Likelihood, pvalue_neutral_growth, bottleplusgrowth_Likelihood, pvalue_bottle_bottleplusgrowth, growthplusbottle_Likelihood, pvalue_bottleplusgrowth_growthplusbottle, twopopchanges_Likelihood, pvalue_bottleplusgrowth_twopopchanges)
maxRep_growthplusbottle_selmodel<-merge(maxRep_growthplusbottle,table_with_pvalues, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% filter(sel_model==model) %>% select(sizeFiltering, pop, lib, sp, completion, others, nuB, nuF, TB, TF, log_likelihood, var_nuB, var_nuF, var_TB, var_TF, var_log_likelihood, bootstraps, model, sel_model, neutral_Likelihood, bottlepop__Likelihood, pvalue_neutral_bottle, growth_Likelihood, pvalue_neutral_growth, bottleplusgrowth_Likelihood, pvalue_bottle_bottleplusgrowth, growthplusbottle_Likelihood, pvalue_bottleplusgrowth_growthplusbottle, twopopchanges_Likelihood, pvalue_bottleplusgrowth_twopopchanges)


# and this is the final table with only the summary table with the best model per population
total_data_selmodel<-rbind(maxRep_twopopchanges_selmodel, maxRep_bottleplusgrowth_selmodel, maxRep_bottlepop_selmodel, maxRep_growth_selmodel, maxRep_growthplusbottle_selmodel)#, maxRep_neutral_selmodel) 

# per chromosome with filter:
sub_total_data_selmodel_withPi<- merge(sub_total_data_selmodel, pi_data, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others")) %>% 
	merge(sd_pi_data, by=c("sizeFiltering", "pop", "lib", "sp", "completion", "others"))
write.table(sub_total_data_selmodel_withPi, file = "total_data_selmodel_withPi_perChr_withFiters.txt", append = FALSE, quote = F, sep = "\t", row.names = F)


