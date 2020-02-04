######################################################################################
###                                                                                ###
### setup                                                                          ###
###                                                                                ###
### DESCRIPTION: The setup script. This script will load the necessary libraries   ###
###              and will source the user-defined functions from the repository.   ###
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
require(here) # Technically, this call needs to be made within the app itself.

##############################
### USER-DEFINED FUNCTIONS ###
##############################

FP_01 <- sort(dir(path = paste0(getwd(), "/Code/"), pattern = "\\.[rR]$", full.names = FALSE))
FP_01 <- FP_01[!grepl(pattern = "setup.R", x = FP_01)]
lapply(X = FP_01, FUN = function(x){ source(here::here("Code", x)) })