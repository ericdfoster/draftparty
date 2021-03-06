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
                
                tabPanel(title = paste0(format(Sys.Date(), "%Y"), " Guesses"),
                         
                         selectInput(inputId = "GUESS_PICK",
                                     label = "Pick Number:",
                                     choices = get(paste0("DRAFT_",
                                                          format(Sys.Date(), "%Y")))$PICK,
                                     selected = 1),
                         
                         hr(),
                         
                         uiOutput(outputId = "GUESS_GUESSES"),
                         
                         actionButton(inputId = "GUESS_PUSH",
                                      label = "Update Guesses"),
                         
                         hr(),
                         
                         selectInput(inputId = "GUESS_PIRATES",
                                     label = "Who is playing?",
                                     choices = PIRATES$PIRATE,
                                     multiple = TRUE)
                         
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
                
                tabPanel("Guesses", DT::dataTableOutput(outputId = "GUESS_RESULTS")),
                
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
    
    values <- reactiveValues(DF_DRAFT_RESULTS = get(x = paste0("DRAFT_", format(Sys.Date(), "%Y"))),
                             DF_GUESS_RESULTS = get(x = paste0("GUESSES_", format(Sys.Date(), "%Y"))))
    

    ### DIRECTLY MODIFY THE OUTPUT LIST ###
    
    # OUR MERRY BAND OF PIRATES #
    output$PIRATES <- DT::renderDataTable({
        
        DT::datatable(PIRATES, options = list("pageLength" = 20))
        
    })
    
    # BOTH PAST AND PRESENT DRAFT RESULTS #
    output$DRAFT_RESULTS <- DT::renderDataTable({
        
        if(input$DRAFT_YEAR == format(Sys.Date(), "%Y")){
            
            # PRESENT DRAFT RESULTS #
            DT::datatable(values$DF_DRAFT_RESULTS, options = list("pageLength" = 32))
            
        }else{
            
            # PAST DRAFT RESULTS #
            DT::datatable(get(x = paste0("DRAFT_", input$DRAFT_YEAR)), options = list("pageLength" = 32))
            
        }
        
    })
    
    # BOTH PAST AND PRESENT GUESS RESULTS #
    output$GUESS_RESULTS <- DT::renderDataTable({
        
        if(input$DRAFT_YEAR == format(Sys.Date(), "%Y")){
            
            # PRESENT GUESS RESULTS #
            DT::datatable(arrange(values$DF_GUESS_RESULTS, desc(PICK), PIRATEID), options = list("pageLength" = 100))
            
        }else{
            
            # PAST GUESS RESULTS #
            DT::datatable(arrange(get(x = paste0("GUESSES_", input$DRAFT_YEAR)), GUESSID, PIRATEID), options = list("pageLength" = 100))
            
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
    
    # BUTTON TO RECORD GUESSES HAS BEEN PRESSED #
    observeEvent(eventExpr = input$GUESS_PUSH, handlerExpr = {
        
        # GET THE PRESENT GUESSES #
        TEMP_01 <- values$DF_GUESS_RESULTS
        
        # RECORD THE GUESSES #
        if(!is.null(input$GUESS_PIRATES)){
            
            TEMP_02 <- tibble(PIRATE = input$GUESS_PIRATES,
                              PIRATEID = PIRATES$PIRATEID[match(input$GUESS_PIRATES, PIRATES$PIRATE)],
                              YEAR = as.numeric(rep(format(Sys.Date(), "%Y"), length(input$GUESS_PIRATES))),
                              PICK = as.numeric(rep(input$GUESS_PICK, length(input$GUESS_PIRATES))),
                              GUESSID = unlist(lapply(X = 1:length(input$GUESS_PIRATES),
                                                      FUN = function(x){ nrow(TEMP_01[TEMP_01$PIRATE == input$GUESS_PIRATES[x], ]) + 1 })),
                              GUESS = unlist(lapply(X = 1:length(input$GUESS_PIRATES),
                                                    FUN = function(x){ input[[input$GUESS_PIRATES[x]]] })),
                              GUESSN = unlist(lapply(X = 1:length(input$GUESS_PIRATES),
                                                     FUN = function(x){
                                                         
                                                         ifelse(input[[input$GUESS_PIRATES[x]]] == "DEF",
                                                                1,
                                                                ifelse(input[[input$GUESS_PIRATES[x]]] == "OFF",
                                                                       0,
                                                                       NA))
                                                         
                                                     })))
            
        }else{
            
            # CREATE AN EMPTY GUESSES TIBBLE FOR THE NEW GUESSES #
            TEMP_02 <- tibble(PIRATE = character(),
                              PIRATEID = numeric(),
                              YEAR = numeric(),
                              PICK = numeric(),
                              GUESSID = numeric(),
                              GUESS = character(),
                              GUESSN = numeric())
            
        }
        
        # OVERWRITE THE OLD GUESSES WITH THE UPDATED GUESSES #
        # ...IN THE APPLICATION #
        values$DF_GUESS_RESULTS <- bind_rows(TEMP_01, TEMP_02)
        # ...IN THE GLOBAL ENVIRONMENT #
        assign(x = paste0("GUESSES_", format(Sys.Date(), "%Y")), value = bind_rows(TEMP_01, TEMP_02), envir = .GlobalEnv)
        # ...IN THE LOCAL GIT REPOSITORY #
        # NOTE: A MANUAL COMMIT/PUSH IS NEEDED TO SAVE TO THE GLOBAL GIT REPOSITORY #
        updateEnvironmentDatasets(action = "push")
        
    })
    
    ### RENDER UI FROM THE SERVER-SIDE ###
    
    output$GUESS_GUESSES <- renderUI(expr = {
        
        TEMP_01 <- list(hr())
        
        if(!is.null(input$GUESS_PIRATES)){
            
            TEMP_01 <- lapply(X = 1:length(input$GUESS_PIRATES),
                              FUN = function(x){
                                  
                                  selectInput(inputId = input$GUESS_PIRATES[x],
                                              label = paste0(input$GUESS_PIRATES[x], "'s Guess:"),
                                              choices = c("OFF", "DEF", " "))
                                  
                              })
            
        }
        
        TEMP_01
        
    })

}

###########################
### RUN THE APPLICATION ###
###########################

shinyApp(ui = ui, server = server)