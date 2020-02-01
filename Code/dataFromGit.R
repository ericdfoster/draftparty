######################################################################################
###                                                                                ###
### dataFromGit                                                                    ###
###                                                                                ###
### DESCRIPTION: A function that can be used for reading data frames from the git  ###
###              repository.                                                       ###
###                                                                                ###
### INPUTS:                                                                        ###
###                                                                                ###
###    + fp.git  - The relative filepath/filename to use when storing the data on  ###
###                git. For example, "/Data/GUESSES_XXXX".                         ###
###                                                                                ###
###    + fp.repo - The filepath of the local git repository. Defaults to the       ###
###                "C:/R Projects/draftparty" repository.                          ###
###                                                                                ###
### OUTPUTS:                                                                       ###
###                                                                                ###
###    + The requested dataframe.                                                  ###
###                                                                                ###
######################################################################################

dataFromGit <- function(fp.git, fp.repo = ""){
  
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
  
  ### READ THE FILE ###
  DAT_01 <- read_vc(file = fp.git, root = repo)
  
  ### RETURN THE DATAFRAME ###
  return(DAT_01)
  
}