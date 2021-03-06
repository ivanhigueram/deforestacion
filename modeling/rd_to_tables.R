###############################################################################
###############################################################################
##            REGRESSION DISCONTINUITY TABLES FROM RD_OBJECTS                ##
## This code will take the rdrobust functions output and convert if to a     ##
## LaTeXcode. The process will use the functions in ./R/rd_to_tables.R and   ##
## will use stargazer package to convert summary talbes into LaTeX code      ##
##                                                                           ##
###############################################################################
###############################################################################

library(plyr)
library(dplyr)
library(rdrobust)
library(stargazer)
library(ggplot2)
library(magrittr)
library(foreign)
library(stringr)
library(rlang)
library(purrr)



# Source tables functions
setwd(Sys.getenv("ROOT_FOLDER"))
source("R/func_tables.R")
source("modeling/merge_datasets.R")

# Set directories
setwd(paste0(Sys.getenv("OUTPUT_FOLDER")))

###############################################################################
###### RESULTS DATAFRAME PER TABLE: DEFORESTATION FOR EACH PROTECTED AREA #####
################################## (TABLE 3) ##################################
###############################################################################

list_files <- list.files("RD/Models/new_results/", full.names = T)
rd_robust_2_controls <- list_files[str_detect(list_files, '_2_ctrl')] 

list_df <- c(defo_dist, defo_dist_terr)
df_robusts_controls <- rd_to_df_2(rd_robust_2_controls, 
           control_df = list_df, 
           names = c("All", "National", "Regional", "Black", "Ingigenous"),
           digits = 4,
           stargazer = F,
           baseline_variable = "loss_sum", 
           latex = F) %>% .[,c(2,3,5,4)]


###############################################################################
###### RESULTS DATAFRAME PER TABLE: DEFORESTATION FOR EACH PROTECTED AREA #####
################################# (TABLE A2) ##################################
###############################################################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_2 <- list_files[str_detect(list_files, '_2.rds')] 
list_df <- c(defo_dist, defo_dist_terr)
df_robust <- rd_to_df_2(rd_robust_2, 
                      control_df = list_df, 
                      names = c("All", "National", "Regional", "Black", "Ingigenous"),
                      digits = 4,
                      baseline_variable = "loss_sum",
                      latex = TRUE) %>% .[,c(2,3,5,4)] 

###############################################################################
####### RESULTS DATAFRAME PER TABLE: COCA CROPS FOR EACH PROTECTED AREA #######
###############################################################################

list_files <- list.files("RD/Models/new_results/", full.names = T)
rd_robust_2_coca <- list_files[str_detect(list_files, '_2_coca')] 

list_df <- c(defo_dist[1:2], defo_dist_terr)
df_robust_coca_control <- rd_to_df_2(rd_robust_2_coca, 
                                     control_df = list_df, 
                                     names = c("All", "National", "Black", "Ingigenous"),
                                     digits = 4,
                                     baseline_variable = "coca_agg",
                                     latex = TRUE) %>% .[c(1, 2, 4, 3)]


###############################################################################
###### RESULTS DATAFRAME PER TABLE: MINING 2014 FOR EACH PROTECTED AREA #######
###############################################################################

list_files <- list.files("RD/Models/new_results/", full.names = T)
rd_robust_2_mining <- list_files[str_detect(list_files, '2_mining')] 

list_df <- c(defo_dist[1:2], defo_dist_terr)
df_robust_mining <- rd_to_df_2(rd_robust_2_mining, 
                               control_df = list_df, 
                               names = c("All", "National", "Black", "Ingigenous"),
                               digits = 4,
                               baseline_variable = "illegal_mining_EVOA_2014",
                               latex = TRUE) %>% .[,c(1, 2, 4, 3)]



###############################################################################
###### RESULTS DATAFRAME PER TABLE: DEFORESTATION FOR EACH PROTECTED AREA #####
################ HETEROGENEUS EFFECTS FOR LIGHTS AND ROADS ####################
################################## (TABLE 5) ##################################
###############################################################################

################################## LIGHTS ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_lights <- list_files[str_detect(list_files, regex("robust_clump0\\.|robust_clump1\\."))] 

list_df <- c(defo_dist[2:3], defo_dist_terr)
df_clumps_list <- lapply(rd_robust_het_effects_lights, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("All","National", "Regional", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = "loss_sum",
             latex = TRUE) %>% .[, c(2, 3, 5, 4)] 
})
                     
################################## ROADS ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_roads <- list_files[str_detect(list_files, regex("robust_roads0\\.|robust_roads1\\."))] 

list_df <- c(defo_dist[2:3], defo_dist_terr)
df_roads_list <- lapply(rd_robust_het_effects_roads, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("All", "National", "Regional", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = "loss_sum",
             latex = TRUE) %>% .[c(2, 3, 5, 4)]
})



###############################################################################
########## RESULTS DATAFRAME PER TABLE: COCA FOR EACH PROTECTED AREA ##########
################ HETEROGENEUS EFFECTS FOR LIGHTS AND ROADS ####################
###############################################################################

################################## LIGHTS ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_coca_het_effects_lights <- list_files[str_detect(list_files, regex("robust_clump0_coca|robust_clump1_coca"))] 

list_df <- c(defo_dist[2], defo_dist_terr)
df_clumps_coca_list <- lapply(rd_robust_coca_het_effects_lights, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = "coca_agg",
             latex = TRUE) %>% .[, c(1, 2, 3)]
})

################################## ROADS ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_roads <- list_files[str_detect(list_files, regex("robust_roads0_coca\\.|robust_roads1_coca\\."))] 

list_df <- c(defo_dist[2], defo_dist_terr)
df_roads_list <- lapply(rd_robust_het_effects_roads, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Regional", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = 'coca_agg',
             latex = TRUE) %>% .[c(1, 2, 4, 3)]
}) 


###############################################################################
######## RESULTS DATAFRAME PER TABLE: MINING FOR EACH PROTECTED AREA ##########
################ HETEROGENEUS EFFECTS FOR LIGHTS AND ROADS ####################
###############################################################################

################################## LIGHTS ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_mining_het_effects_lights <- list_files[str_detect(list_files, regex("robust_clump0_mining|robust_clump1_mining"))] 

list_df <- c(defo_dist[2], defo_dist_terr)
df_clumps_mining_list <- lapply(rd_robust_mining_het_effects_lights, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Black", "Ingigenous"),
             baseline_variable = 'illegal_mining_EVOA_2014',
             digits = 4,
             latex = TRUE) %>% .[c(1, 2, 3)]
})

################################## ROADS ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_roads <- list_files[str_detect(list_files, regex("robust_roads0_coca\\.|robust_roads1_coca\\."))] 

list_df <- c(defo_dist[2:3], defo_dist_terr)
df_roads_list <- lapply(rd_robust_het_effects_roads, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Regional", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = 'illegal_mining_EVOA_2014',
             latex = TRUE)
})



###############################################################################
#### RESULTS DATAFRAME PER TABLE: DEFORESTATION  FOR EACH PROTECTED AREA ######
######## HETEROGENEUS EFFECTS FOR INSTITUTIONS: MUNI AGE AND HOMICIDES  #######
###############################################################################

############################# CREATED BEFORE 1950 ##############################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_institutions <- list_files[str_detect(list_files, regex('inst[0-9].rds'))]

list_df <- c(defo_dist[2:3], defo_dist_terr)
df_inst_het_effects_list <- lapply(rd_robust_het_effects_institutions, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Regional", "Black", "Indigenous"),
             baseline_variable = 'loss_sum',
             digits = 4,
             latex = TRUE) %>% .[c(1, 2, 4, 3)]
})  

################################## HOMICIDES ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_homicides <- list_files[str_detect(list_files, regex('hom\\d.rds'))] 

list_df <- c(defo_dist[2:3], defo_dist_terr)
df_homicides_het_effects <- lapply(rd_robust_het_effects_homicides, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Regional", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = 'loss_sum',
             latex = TRUE) %>% .[c(1, 2, 4, 3)]
})


###############################################################################
###### RESULTS DATAFRAME PER TABLE: SIMCI COCA  FOR EACH PROTECTED AREA #######
######## HETEROGENEUS EFFECTS FOR INSTITUTIONS: MUNI AGE AND HOMICIDES  #######
###############################################################################

############################# CREATED BEFORE 1950 ##############################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_institutions_coca <- list_files[str_detect(list_files, regex('inst\\d_coca'))]

list_df <- c(defo_dist[2], defo_dist_terr)
df_inst_het_effects_list_coca <- lapply(rd_robust_het_effects_institutions_coca, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Black", "Indigenous"),
             baseline_variable = 'coca_agg',
             digits = 4,
             latex = TRUE) %>% .[c(1, 2, 3)]
})  

################################## HOMICIDES ##################################

# list_files <- list.files("RD/Models/new_results", full.names = T)
# rd_robust_het_effects_homicides_coca <- list_files[str_detect(list_files, regex('hom\\d_coca'))] 
# 
# list_df <- c(defo_dist[2:3], defo_dist_terr)
# df_homicides_het_effects_coca <- lapply(rd_robust_het_effects_homicides_coca, function(x){
#   rd_to_df_2(x, 
#              control_df = list_df, 
#              names = c("National", "Regional", "Black", "Ingigenous"),
#              digits = 4,
#              baseline_variable = 'coca_agg',
#              latex = TRUE) %>% .[c(1, 2, 4, 3)]
# })



###############################################################################
##### RESULTS DATAFRAME PER TABLE: SIMCI MINING  FOR EACH PROTECTED AREA ######
######## HETEROGENEUS EFFECTS FOR INSTITUTIONS: MUNI AGE AND HOMICIDES  #######
###############################################################################

############################# CREATED BEFORE 1950 ##############################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_institutions_mining <- list_files[str_detect(list_files, regex('inst\\d_m'))]

list_df <- c(defo_dist[2:3], defo_dist_terr)
df_inst_het_effects_list_mining <- lapply(rd_robust_het_effects_institutions_mining, function(x){
  rd_to_df_2(x, 
             control_df = list_df, 
             names = c("National", "Regional", "Black", "Indigenous"),
             baseline_variable = 'illegal_mining_EVOA_2014',
             digits = 4,
             latex = TRUE) %>% .[c(1, 2, 4, 3)]
})  

################################## HOMICIDES ##################################

list_files <- list.files("RD/Models/new_results", full.names = T)
rd_robust_het_effects_homicides_mining <- list_files[str_detect(list_files, regex('hom\\d_m'))]

list_df <- c(defo_dist[2], defo_dist_terr)
df_homicides_het_effects_mining <- lapply(rd_robust_het_effects_homicides_mining, function(x){
  rd_to_df_2(x,
             control_df = list_df,
             names = c("National", "Black", "Ingigenous"),
             digits = 4,
             baseline_variable = 'illegal_mining_EVOA_2014',
             latex = TRUE) %>% .[c(1, 2, 4, 3)]
})






