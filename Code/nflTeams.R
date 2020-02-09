######################################################################################
###                                                                                ###
### nflTeams                                                                       ###
###                                                                                ###
### DESCRIPTION: Helper function that returns the names of the NFL teams as well   ###
###              as their color schemes (planned) and perhaps some helpful images  ###
###    (hypothesized).                                                             ###
###                                                                                ###
### INPUTS:                                                                        ###
###                                                                                ###
### OUTPUTS:                                                                       ###
###                                                                                ###
###    + A data.frame of team names and color scheme parameters (planned).         ###
###                                                                                ###
### NOTES:                                                                         ###
###                                                                                ###
######################################################################################

nflTeams <- function(){
  
  return(data.frame(TEAMNAME = c("Cardinals",
                                 "Falcons",
                                 "Ravens",
                                 "Bills",
                                 "Panthers",
                                 "Bears",
                                 "Bengals",
                                 "Browns",
                                 "Cowboys",
                                 "Broncos",
                                 "Lions",
                                 "Packers",
                                 "Texans",
                                 "Colts",
                                 "Jaguars",
                                 "Chiefs",
                                 "Raiders",
                                 "Chargers",
                                 "Rams",
                                 "Dolphins",
                                 "Vikings",
                                 "Patriots",
                                 "Saints",
                                 "Giants",
                                 "Jets",
                                 "Eagles",
                                 "Steelers",
                                 "49ers",
                                 "Seahawks",
                                 "Buccaneers",
                                 "Titans",
                                 "Redskins")))
  
}