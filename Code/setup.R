######################################################################################
###                                                                                ###
### setup                                                                          ###
###                                                                                ###
### DESCRIPTION: The setup script. This script will load the necessary libraries   ###
###              and will source the user-defined functions from the repository.   ###
###    The setup script will also load all data into dataframes.                   ###
###                                                                                ###
### INPUTS: None                                                                   ###
###                                                                                ###
### OUTPUTS: None                                                                  ###
###                                                                                ###
######################################################################################

#################
### LIBRARIES ###
#################

library(tidyverse)
library(git2rdata)
library(DT)
# require(here) # Technically, this call needs to be made within the app itself.

##############################
### USER-DEFINED FUNCTIONS ###
##############################

FP_01 <- sort(dir(path = paste0(getwd(), "/Code/"), pattern = "\\.[rR]$", full.names = FALSE))
FP_01 <- FP_01[!grepl(pattern = "setup.R", x = FP_01)]
lapply(X = FP_01, FUN = function(x){ source(here::here("Code", x)) })

#################
### LOAD DATA ###
#################

updateEnvironmentDatasets(action = "pull")