##############################################################################################
##############################################################################################
###                          RUN REGRESSION DISCONTINUITY MODELS                           ###
###     THIS CODE WILL READ THE DISTANCE AND DEFORESTATION DATA TO RUN RD MODELS           ###
###     HERE WE WILL RUN THE MODELS TO CALCULATE HETEROGENEOUS EFFECTS FOR                 ###
###     DEFORESTATION, COCA CROPS, AND ILLEGAL GOLD MINING. THIS ANALYSIS WILL             ###
###     ONLY USE ALL  BORDERS WITHOUT COMPOUND TREATMENT EFFECT                            ###        
##############################################################################################
##############################################################################################

rm(list=ls())
library(plyr)
library(dplyr)
library(data.table)
library(rdrobust)
library(rdd)
library(stringr)
library(stargazer)
library(foreign)
library(ggplot2)
library(magrittr)
library(foreign)
library(stringr)
library(rlang)
library(tidyr)
library(RATest)

# Source tables functions
setwd(Sys.getenv("ROOT_FOLDER"))
source("R/rd_functions.R")
source("modeling/merge_datasets.R")

##############################################################################################
###################################### 1. DEFORESTATION ######################################
##############################################################################################

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
####################### (NIGHT-LIGHT DATA: CLUMPS: {1: CLUMP, 0: NO CLUMP}) ##################
##############################################################################################


list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, clumps_5k == 1))
rd_robust_clump1 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})


list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, clumps_5k == 0))
rd_robust_clump0 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_clump0, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump0.rds"))
saveRDS(rd_robust_clump1, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump1.rds"))

rd_robust_clump0 <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump0.rds"))
rd_robust_clump1 <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump1.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (ROADS BUFFER: {1: INSIDE 5KM ROAD BUFFER, 0: OUTSIDE}) ################
##############################################################################################


list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, roads == 1))
rd_robust_clump1_2 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, roads == 0))
rd_robust_clump0_2 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_clump0_2, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_roads0.rds"))
saveRDS(rd_robust_clump1_2, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_roads1.rds"))


##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
################ (Institutions:  {1: Municipality created before 1950}) ######################
##############################################################################################


list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, ao_crea <= 1950))
rd_robust_inst0 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, ao_crea > 1950))
rd_robust_inst1 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_inst0, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_inst0.rds"))
saveRDS(rd_robust_inst1, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_inst1.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (Violence: {1: homicide rate > median pre-2000; 0 ow}) #################
##############################################################################################

list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, hom_q34 == 0))
rd_robust_hom0 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, hom_q34 == 1))
rd_robust_hom1 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_hom0, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom0.rds"))
saveRDS(rd_robust_hom1, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom1.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (Conflict: {1: Presence illegal armed groups pre-2000}) ################
##############################################################################################


list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, pres_cerac_1 == 0))
rd_robust_conflict0 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2:3], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, pres_cerac_1 == 1))
rd_robust_conflict1 <- lapply(list_df, function(park){
  rdrobust(
    y = park$loss_sum,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_conflict0, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_conflict0.rds"))
saveRDS(rd_robust_conflict1, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_conflict1.rds"))

##############################################################################################
################################### 2. SIMCI DATA: COCA CROPS ################################
##############################################################################################

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
###################### (NIGHT-LIGHT DATA: CLUMPS 5K: {1: CLUMP, 0: NO CLUMP}) ################
##############################################################################################

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, clumps_5k == 1))
rd_robust_clump1_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, clumps_5k == 0))
rd_robust_clump0_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_clump0_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump0_coca.rds"))
saveRDS(rd_robust_clump1_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump1_coca.rds"))

rd_robust_clump0_coca <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump0_coca.rds"))
rd_robust_clump1_coca <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump1_coca.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
################ (Institutions:  {1: Municipality created before 1950}) ######################
##############################################################################################

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, ao_crea <= 1950))
rd_robust_inst0_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 8,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, ao_crea > 1950))
rd_robust_inst1_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_inst0_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_inst0_coca.rds"))
saveRDS(rd_robust_inst1_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_inst1_coca.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (Violence: {1: homicide rate > median pre-2000; 0 ow}) #################
##############################################################################################

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, hom_q34 == 0))
rd_robust_hom0_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, hom_q34 == 1))
rd_robust_hom1_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_hom0_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom0_coca.rds"))
saveRDS(rd_robust_hom1_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom1_coca.rds"))


##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (ROADS BUFFER: {1: INSIDE 5KM ROAD BUFFER, 0: OUTSIDE}) ################
##############################################################################################


list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, roads == 1))
rd_robust_roads1_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, roads == 0))
rd_robust_roads0_coca <- lapply(list_df, function(park){
  rdrobust(
    y = park$coca_agg,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_roads1_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_roads0_coca.rds"))
saveRDS(rd_robust_roads0_coca, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_roads1_coca.rds"))

##############################################################################################
################################# 2. SIMCI DATA: ILLEGAL MINING ##############################
##############################################################################################

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
###################### (NIGHT-LIGHT DATA: CLUMPS 5K: {1: CLUMP, 0: NO CLUMP}) ################
##############################################################################################


counter <- 0
list_df <- c(defo_dist[2]) %>%
  lapply(., function(x) base::subset(x, clumps_5k ==1))
rd_robust_clump1_mining <- lapply(list_df, function(park){
  counter <<- counter + 1
  print(counter)
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, clumps_5k == 0))
rd_robust_clump0_mining <- lapply(list_df, function(park){
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})


saveRDS(rd_robust_clump0_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump0_mining.rds"))
saveRDS(rd_robust_clump1_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump1_mining.rds"))

rd_robust_clump0_mining <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump0_mining.rds"))
rd_robust_clump1_mining <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_clump1_mining.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
################ (Institutions:  {1: Municipality created before 1950}) ######################
##############################################################################################

counter <- 0
list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, ao_crea <= 1950))
rd_robust_inst0_mining <- lapply(list_df, function(park){
  counter <<- counter + 1
  print(counter)
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, ao_crea > 1950))
rd_robust_inst1_mining <- lapply(list_df, function(park){
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})


saveRDS(rd_robust_inst0_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_inst0_mining.rds"))
saveRDS(rd_robust_inst1_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_inst1_mining.rds"))

##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (Violence: {1: homicide rate > median pre-2000; 0 ow}) #################
##############################################################################################

counter <- 0
list_df <- c(defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, hom_q34 == 0))

rd_robust_hom0_mining <- lapply(list_df, function(park){
  counter <<- counter + 1
  print(counter)
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, hom_q34 == 1))
rd_robust_hom1_mining <- lapply(list_df, function(park){
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})


saveRDS(rd_robust_hom0_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom0_mining.rds"))
saveRDS(rd_robust_hom1_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom1_mining.rds"))

# rd_robust_hom0_mining <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom0_mining.rds"))
# rd_robust_hom1_mining <- readRDS(str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_hom1_mining.rds"))

s##############################################################################################
#################################### OPTIMAL ROBUST BANDWITHS ################################
##################### (ROADS BUFFER: {1: INSIDE 5KM ROAD BUFFER, 0: OUTSIDE}) ################
##############################################################################################

counter <- 0
list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, roads == 1))
rd_robust_road1_mining <- lapply(list_df, function(park){
  counter <<- counter + 1
  print(counter)
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

counter <- 0
list_df <- c(defo_dist[2], defo_dist_terr) %>%
  lapply(., function(x) base::subset(x, roads == 0))
rd_robust_road0_mining <- lapply(list_df, function(park){
  counter <<- counter + 1
  print(counter)
  rdrobust(
    y = park$illegal_mining_EVOA_2014,
    x = park$dist_disc,
    covs = cbind(park$altura_tile_30arc, park$slope, park$roughness, park$prec, 
                 park$sq_1km.1, park$treecover_agg, as.factor(as.character(park$buffer_id))),
    vce = "nn",
    nnmatch = 3,
    all = T
  )
})

saveRDS(rd_robust_road0_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_roads0_mining.rds"))
saveRDS(rd_robust_road1_mining, str_c(Sys.getenv("OUTPUT_FOLDER"), "/RD/Models/new_results/rd_robust_roads1_mining.rds"))
