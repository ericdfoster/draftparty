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

FP_01 <- sort(dir(path = here::here("Code"), pattern = "\\.[rR]$", full.names = FALSE))
FP_01 <- FP_01[!grepl(pattern = "setup.R", x = FP_01)]
lapply(X = FP_01, FUN = function(x){ source(here::here("Code", x)) })

#################
### LOAD DATA ###
#################

updateEnvironmentDatasets(action = "pull")
if(!any(list.files(path = here::here("Data"), recursive = TRUE) == 
        paste0("DRAFT_", format(Sys.Date(), "%Y"), ".tsv"))){
  
  assign(x = paste0("DRAFT_", format(Sys.Date(), "%Y")),
         value = tibble(YEAR = rep(as.numeric(format(Sys.Date(), "%Y")), 32),
                        PICK = 1:32,
                        TEAM = rep("", 32),
                        PLAYER_FIRST = rep("", 32),
                        PLAYER_LAST = rep("", 32),
                        POSITION = rep("", 32),
                        COLLEGE = rep("", 32),
                        SIDE = rep("", 32),
                        SIDEN = as.numeric(rep(NA, 32))))
  updateEnvironmentDatasets(action = "push")
  
}
if(!any(list.files(path = here::here("Data"), recursive = TRUE) ==
        paste0("GUESSES_", format(Sys.Date(), "%Y"), ".tsv"))){
  
  assign(x = paste0("GUESSES_", format(Sys.Date(), "%Y")),
         value = tibble(PIRATE = character(),
                        PIRATEID = numeric(),
                        YEAR = numeric(),
                        PICK = numeric(),
                        GUESSID = numeric(),
                        GUESS = character(),
                        GUESSN = numeric()))
  
}
