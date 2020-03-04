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
    
    ### ADJUST FORMATTING ###
    tags$head(
        
        tags$style(HTML("hr {border-top: 1px solid #000000;}"))
        
    ),

    ### TITLE ###
    titlePanel(paste0(format(Sys.Date(), "%Y"), " NFL DRAFT PARTY")),

    ### SIDEBAR PANEL LAYOUT ###
    sidebarLayout(
        
        ### SIDEBAR PANEL ###
        sidebarPanel(

            tabsetPanel(
                
                id = "sidescreens",
                
                tabPanel(title = paste0(format(Sys.Date(), "%Y"), " Draft"),
                         
                         br(),
                         
                         selectInput(inputId = "DRAFT_PICK",
                                     label = "Pick Number:",
                                     choices = get(paste0("DRAFT_",
                                                          format(Sys.Date(), "%Y")))$PICK,
                                     selected = 1),
                         
                         selectInput(inputId = "DRAFT_TEAM",
                                     label = "Team Name:",
                                     choices = nflTeams()$TEAMNAME),
                         
                         textInput(inputId = "DRAFT_FIRST_NAME",
                                   label = "Player First Name:"),
                         
                         textInput(inputId = "DRAFT_LAST_NAME",
                                   label = "Player Last Name:"),
                         
                         selectInput(inputId = "DRAFT_POSITION",
                                     label = "Player Position:",
                                     choices = c(" ", "C", "CB", "DE", "DT", "G", "K", "LB", "P", "QB", "RB", "S", "T", "TE", "WR")),
                         
                         textInput(inputId = "DRAFT_COLLEGE",
                                   label = "Player College:"),
                         
                         selectInput(inputId = "DRAFT_SIDE",
                                     label = "OFF or DEF:",
                                     choices = c("OFF", "DEF", " ")),
                         
                         actionButton(inputId = "DRAFT_PUSH",
                                      label = "Update Draft")
                         
                         ),
                
                tabPanel(title = "Change View",
                         
                         selectInput(inputId = "DRAFT_YEAR",
                                     label = "Year:",
                                     choices = c(2017:as.numeric(format(Sys.Date(), "%Y")))[unlist(lapply(X = 2017:as.numeric(format(Sys.Date(), "%Y")), FUN = function(x){ exists(paste0("DRAFT_", x)) }))],
                                     selected = as.numeric(format(Sys.Date(), "%Y"))),
                         
                         hr(),
                         
                         )
                
            )
            
        ),

        ### MAIN PANEL ###
        mainPanel(
            
            tabsetPanel(
                
                id = "mainscreens",
                
                tabPanel("Draft Results", DT::dataTableOutput(outputId = "DRAFT_RESULTS")),
                
                tabPanel("Pirates", DT::dataTableOutput(outputId = "PIRATES"))
                
            )

        )
        
    )
    
)

##############################
### SERVER-SIDE OPERATIONS ###
##############################

server <- function(input, output) {
    
    ### PLACE HOLDERS FOR REACTIVE OUTPUT ###
    
    values <- reactiveValues(DF_DRAFT_RESULTS = get(x = paste0("DRAFT_", format(Sys.Date(), "%Y"))))

    ### DIRECTLY MODIFY THE OUTPUT LIST ###
    
    output$PIRATES <- DT::renderDataTable({
        
        DT::datatable(PIRATES, options = list("pageLength" = 20))
        
    })
    
    # BOTH PAST AND PRESENT DRAFT RESULTS #
    output$DRAFT_RESULTS <- DT::renderDataTable({
        
        if(input$DRAFT_YEAR == format(Sys.Date(), "%Y")){
            
            # PAST DRAFT RESULTS #
            DT::datatable(values$DF_DRAFT_RESULTS, options = list("pageLength" = 32))
            
        }else{
            
            # PRESENT DRAFT RESULTS #
            DT::datatable(get(x = paste0("DRAFT_", input$DRAFT_YEAR)), options = list("pageLength" = 32))
            
        }
        
    })
    
    ### EVENT OBSERVATIONS ###
    
    # BUTTON TO RECORD A DRAFT PICK HAS BEEN PRESSED #
    observeEvent(eventExpr = input$DRAFT_PUSH, handlerExpr = {
        
        # GET THE PRESENT DRAFT RESULTS #
        TEMP_01 <- values$DF_DRAFT_RESULTS
        
        # RECORD THE PICK #
        TEMP_01$TEAM[as.numeric(input$DRAFT_PICK)] <- input$DRAFT_TEAM
        TEMP_01$PLAYER_FIRST[as.numeric(input$DRAFT_PICK)] <- input$DRAFT_FIRST_NAME
        TEMP_01$PLAYER_LAST[as.numeric(input$DRAFT_PICK)] <- input$DRAFT_LAST_NAME
        TEMP_01$POSITION[as.numeric(input$DRAFT_PICK)] <- input$DRAFT_POSITION
        TEMP_01$COLLEGE[as.numeric(input$DRAFT_PICK)] <- input$DRAFT_COLLEGE
        TEMP_01$SIDE[as.numeric(input$DRAFT_PICK)] <- input$DRAFT_SIDE
        TEMP_01$SIDEN[as.numeric(input$DRAFT_PICK)] <- ifelse(input$DRAFT_SIDE == "DEF", 1, ifelse(input$DRAFT_SIDE == "OFF", 0, NA))
        
        # OVERWRITE THE OLD DRAFT RESULTS WITH THE UPDATED DRAFT RESULTS #
        # ...IN THE APPLICATION #
        values$DF_DRAFT_RESULTS <- TEMP_01
        # ...IN THE GLOBAL ENVIRONMENT #
        assign(x = paste0("DRAFT_", format(Sys.Date(), "%Y")), value = TEMP_01, envir = .GlobalEnv)
        # ...IN THE LOCAL GIT REPOSITORY #
        # NOTE: A MANUAL COMMIT/PUSH IS NEEDED TO SAVE TO THE GLOBAL GIT REPOSITORY #
        updateEnvironmentDatasets(action = "push")
        
    })

}

###########################
### RUN THE APPLICATION ###
###########################

shinyApp(ui = ui, server = server)