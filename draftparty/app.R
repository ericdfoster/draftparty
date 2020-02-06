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

            
            
        ),

        ### MAIN PANEL ###
        mainPanel(
            
            tabsetPanel(
                
                id = "mainscreens",
                
                tabPanel("Pirates", DT::dataTableOutput(outputId = "pirates"))
                
            )

        )
        
    )
    
)

##############################
### SERVER-SIDE OPERATIONS ###
##############################

server <- function(input, output) {
    
    output$pirates <- DT::renderDataTable({
        
        DT::datatable(PIRATES)
        
    })

}

###########################
### RUN THE APPLICATION ###
###########################

shinyApp(ui = ui, server = server)