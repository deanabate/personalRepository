
# TextFrequencyApp --------------------------------------------------------


#### Libraries ####
library(tidyverse)
library(DT)
library(textreadr)
library(tidytext)
library(shiny)
library(slam)
# install.packages("slam")
data(stop_words)

# Define UI for application 
ui <- fluidPage(

    # Application title
    titlePanel("Text App"),

    # Sidebar Panel
    sidebarPanel(
                fileInput("file", label = h3("File input"), accept=c('.txt')),
             
                radioButtons("stopWords", "Remove Stopwords?",
                                          choices = c(Yes = "Yes",
                                                      No = "No"),
                                          selected = "Yes"),
                
                actionButton("go", "Go!"),
                
                downloadButton("downloadData", "Download")        
               ),
    # Display Output table
    hr(),
    mainPanel(DT::dataTableOutput("table"))
    
)

# Define server logic for application
server <- function(input, output) {

    observeEvent(input$go, {
        
        # So the App doesn't crash without file input
        file = input$file
        if (is.null(file)) {
            return(NULL)
        }
        
        # User File Input
        userText <- read_document(file$datapath, skip = 0, 
                                   remove.empty = TRUE, 
                                   trim = TRUE, 
                                   combine = FALSE, format = FALSE, ocr = TRUE)
        
        # Remove Stopwords Function
        removeStopWords <- function(text_df) {
            text_df <<- text_df %>%
                            anti_join(stop_words)
        }
        
        # Stemming Algorithm
        conjuEnds <- c("ed$", "ing$", "es$", "en$")
        pluralEnds <- c("s$")
        
        stemmingAlgo <- function(.data, word) {
            .data <- .data %>%
                        mutate(word = if_else(grepl(paste(conjuEnds, collapse = "|"), word), 
                                              gsub(paste(conjuEnds, collapse = "|"), "", word), word),
                               word = if_else(grepl(paste(pluralEnds, collapse = "|"), word) & nchar(word) > 3 & str_sub(word, -2, -2) != "s", 
                                              gsub(paste(pluralEnds, collapse = "|"), "", word), word)
                        )
        }
        
        # Creating the TextDF
        text_df <- tibble(line = 1:length(userText), text = userText) %>%
                    unnest_tokens(word, text) %>%
                    stemmingAlgo() %>%
                    count(word, sort = TRUE) 
        
        # Ifelse for Stopword Input
        if (input$stopWords == "Yes") {
            removeStopWords(text_df)
        } else {
            text_df
        }
        
        # UI DataTable Output
        output$table = DT::renderDataTable({
            datatable(head(text_df, 25), 
                      options = list(pageLength = 25),
                      colnames = c('Word', 'Count'),
                      caption = 'Table 1: These are the 25 most frequent words!')
            
        })
        
        # User Settings and Original file
        stopWordSetting <- paste(input$stopWords)
        settingsdf <- data.frame(input=c("stopWords"),
                                  value=c(stopWordSetting), stringsAsFactors=F)
        
        #### Download Data ####
        # Zips together multiple csv files 
        output$downloadData <- downloadHandler(
            filename = function() {
                "output.zip"
            },
            content = function(file) {
                # go to temp dir to avoid permission issues
                userDir <- setwd(tempdir())
                on.exit(setwd(userDir))
                
                # create list of dataframes and NULL value to store fileNames
                listDataFrames = list(output_file = head(text_df, 25), 
                                       settings_file = settingsdf,
                                       input_file = userText)
                allFileNames = NULL
                
                # Loop through each dataframe
                for(i in 1:length(listDataFrames)) {
                    # write each dataframe as csv and save fileName
                    fileName <- paste0(names(listDataFrames)[i], ".csv")
                    write.csv(listDataFrames[i], fileName, row.names = FALSE)
                    allFileNames <- c(fileName, allFileNames)
                }
                
                # write the zip file
                zip(file, allFileNames) 
                
            }, 
        contentType = "application/zip"
        )
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
