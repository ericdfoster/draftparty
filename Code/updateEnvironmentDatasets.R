######################################################################################
###                                                                                ###
### updateEnvironmentDatasets                                                      ###
###                                                                                ###
### DESCRIPTION: A function that can be used for automating the calls to pull      ###
###              (i.e.; download the git datasets) or push (i.e.; save the         ###
###    modified datasets to the git repository). This function is essentially a    ###
###    (hopefully) smart wrapper around the dataFromGit and dataToGit functions.   ###
###                                                                                ###
### INPUTS:                                                                        ###
###                                                                                ###
###    + action - A character string. Either "pull" in order to download data from ###
###               the git repository or "push" to save data to the git repository. ###
###       The default value is set to "pull".                                      ###
###                                                                                ###
### OUTPUTS:                                                                       ###
###                                                                                ###
###    + The datasets in the R environment are either updated or saved.            ###
###                                                                                ###
### NOTES: The push action for the updateEnvironmentDatasets function is only      ###
###        enabled for the present year. Any other pushes to the git repository    ###
###    should directly use the dataToGit function and not this wrapper. Of special ###
###    interest may be an update to the PIRATES dataset which can be accomplished  ###
###    using a separate function, updatePirates.                                   ###
###                                                                                ###
######################################################################################

updateEnvironmentDatasets <- function(action = "pull"){
  
  if(tolower(action) == "pull"){
    
    ### GET A LIST OF ALL DATA FILES IN THE REPOSITORY Data FOLDER ###
    FILES_01 <- list.files(path = here::here("Data"), recursive = TRUE)
    
    ### FIND THE MINIMUM AND MAXIMUM BOUNDARY FOR YEAR OF DRAFT ###
    YEAR_MIN <- min(as.numeric(gsub(pattern = "\\D+",
                                    replacement = "",
                                    x = FILES_01)), na.rm = TRUE)
    YEAR_MAX <- max(as.numeric(gsub(pattern = "\\D+",
                                    replacement = "",
                                    x = FILES_01)), na.rm = TRUE)
    for(a in YEAR_MIN:YEAR_MAX){
      
      ### CHECK THAT A DRAFTPARTY EXISTED DURING THIS YEAR ###
      if(paste0("DRAFT_", a, ".tsv") %in% FILES_01){
        
        assign(x = paste0("DRAFT_", a),
               value = dataFromGit(fp.git = paste0("/Data/DRAFT_", a)),
               envir = .GlobalEnv)
        assign(x = paste0("GUESSES_", a),
               value = dataFromGit(fp.git = paste0("/Data/GUESSES_", a)),
               envir = .GlobalEnv)
        
      }
      
    }
    assign(x = "PIRATES", value = dataFromGit(fp.git = "/Data/PIRATES"),
           envir = .GlobalEnv)
    
  }else if(tolower(action) == "push"){
    
    ### CHECK THAT THE DRAFT DATASET HAS BEEN CREATED FOR THE CURRENT YEAR ###
    if(exists(paste0("DRAFT_", format(Sys.Date(), "%Y")))){
      
      dataToGit(fp.data = get(x = paste0("DRAFT_", format(Sys.Date(), "%Y"))),
                fp.git = paste0("/Data/DRAFT_", format(Sys.Date(), "%Y")),
                sortby = c("PICK"))
      
    }
    
    ### CHECK THAT THE GUESSES DATASET HAS BEEN CREATED FOR THE CURRENT YEAR ###
    if(exists(paste0("GUESSES_", format(Sys.Date(), "%Y")))){
      
      dataToGit(fp.data = get(x = paste0("GUESSES_", format(Sys.Date(), "%Y"))),
                fp.git = paste0("/Data/GUESSES_", format(Sys.Date(), "%Y")),
                sortby = c("PIRATEID", "GUESSID"))
      
    }
    
  }
  
}