#################
### LIBRARIES ###
#################

library(shiny)
library(here)

##############
### SOURCE ###
##############

source(here("Code", "setup.R"))

######################
### USER INTERFACE ###
######################

ui <- fluidPage(

    ### TITLE ###
    titlePanel(paste0(format(Sys.Date(), "%Y"), " NFL DRAFT PARTY")),

    ### SIDEBAR PANEL LAYOUT ###
    sidebarLayout(
        
        ### SIDEBAR PANEL ###
        sidebarPanel(

            tabsetPanel(
                
                id = "sidescreens",
                
                tabPanel(paste0(format(Sys.Date(), "%Y"), " Draft"),
                         
                         selectInput(inputId = "DRAFT_YEAR",
                                     label = "Year:",
                                     choices = c(2017:as.numeric(format(Sys.Date(), "%Y")))[unlist(lapply(X = 2017:as.numeric(format(Sys.Date(), "%Y")), FUN = function(x){ exists(paste0("DRAFT_", x)) }))],
                                     selected = as.numeric(format(Sys.Date(), "%Y"))),
                         
                         selectInput(inputId = "DRAFT_PICK",
                                     label = "Pick Number:",
                                     choices = get(paste0("DRAFT_",
                                                          format(Sys.Date(), "%Y")))$PICK),
                         
                         selectInput(inputId = "DRAFT_TEAM",
                                     label = "Team Name:",
                                     choices = nflTeams()$TEAMNAME),
                         
                         textInput(inputId = "DRAFT_FIRST_NAME",
                                   label = "Player First Name:"),
                         
                         textInput(inputId = "DRAFT_LAST_NAME",
                                   label = "Player Last Name:"),
                         
                         selectInput(inputId = "DRAFT_POSITION",
                                     label = "Player Position:",
                                     choices = c("C", "CB", "DE", "DT", "G", "K", "LB", "P", "QB", "RB", "S", "T", "TE", "WR")),
                         
                         textInput(inputId = "DRAFT_COLLEGE",
                                   label = "Player College:"),
                         
                         selectInput(inputId = "DRAFT_SIDE",
                                     label = "OFF or DEF:",
                                     choices = c("OFF", "DEF"))
                         
                         )
                
            )
            
        ),

        ### MAIN PANEL ###
        mainPanel(
            
            tabsetPanel(
                
                id = "mainscreens",
                
                tabPanel("Pirates", DT::dataTableOutput(outputId = "PIRATES"))
                
            )

        )
        
    )
    
)

##############################
### SERVER-SIDE OPERATIONS ###
##############################

server <- function(input, output) {
    
    output$PIRATES <- DT::renderDataTable({
        
        DT::datatable(PIRATES, options = list("pageLength" = 20))
        
    })

}

###########################
### RUN THE APPLICATION ###
###########################

shinyApp(ui = ui, server = server)