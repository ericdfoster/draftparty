######################################################################################
###                                                                                ###
### dataToGit                                                                      ###
###                                                                                ###
### DESCRIPTION: A function that can be used for sending data to the git           ###
###              repository.                                                       ###
###                                                                                ###
### INPUTS:                                                                        ###
###                                                                                ###
###    + fp.data - Either the filepath of the data that is about to be pushed to   ###
###                or the actual data.frame itself.                                ###
###                                                                                ###
###    + fp.git  - The relative filepath/filename to use when storing the data on  ###
###                git. For example, "/Data/GUESSES_XXXX".                         ###
###                                                                                ###
###    + fp.repo - The filepath of the local git repository. Defaults to the       ###
###                "C:/R Projects/draftparty" repository.                          ###
###                                                                                ###
###    + sortby  - A character vector of column names from the file stored at      ###
###                fp.data. This is strongly recommended by git2rdata.             ###
###                                                                                ###
######################################################################################

dataToGit <- function(fp.data, fp.git, fp.repo = "", sortby){
  
  ### LIBRARIES ###
  require(git2rdata)
  
  ### USE THE FOLLOWING BASH COMMAND TO FIND THE REPOSITORY LOCATION, IF NECESSARY ###
  ###    git rev-parse --show-toplevel
  if(fp.repo == ""){
    
    repo <- repository(path = "C:/R Projects/draftparty")
    
  }else{
    
    repo <- repository(path = fp.repo)
    
  }
  
  ### BE SURE TO PULL FROM THE REPOSITORY FIRST ###
  pull(repo = repo)
  
  ### READ IN THE DATASET ###
  if(typeof(fp.data) == "character"){
    
    DAT_01 <- read.table(file = fp.data, header = TRUE, sep = ",")
    
  }else if(typeof(fp.data) = "list"){
    
    DAT_01 <- fp.data
    
  }
  
  ### WRITE TO THE REPOSITORY ###
  write_vc(x = DAT_01, file = fp.git, root = repo, sorting = sortby, stage = TRUE, strict = FALSE)
  
}