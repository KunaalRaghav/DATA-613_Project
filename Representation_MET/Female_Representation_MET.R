#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)

ui <- fluidPage(
  titlePanel("Five-Tab Shiny App"),
  
  tabsetPanel(
    id = "main_tabs",
    
    tabPanel(
      title = "Tab 1",
      sidebarLayout(
        sidebarPanel(
          h4("Controls - Tab 1")
          # add inputs here
        ),
        mainPanel(
          h3("Content - Tab 1")
          # add outputs here
        )
      )
    ),
    
    tabPanel(
      title = "Tab 2",
      fluidRow(
        column(
          width = 4,
          h4("Left panel - Tab 2")
          # inputs/outputs
        ),
        column(
          width = 8,
          h4("Right panel - Tab 2")
          # inputs/outputs
        )
      )
    ),
    
    # ---------------- TAB 3 WITH JPEG BACKGROUND ----------------
    tabPanel(
      title = "Tab 3",
      
      tags$div(
        style = "
          background-image: url('MET.jpeg');
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
          min-height: 100vh;
          padding: 30px;
          border-radius: 12px;
        ",
        
        h3("Full-width content - Tab 3"),
        p("This tab now has a JPEG background from your images folder.")
      )
    ),
    
    tabPanel(
      title = "Tab 4",
      sidebarLayout(
        sidebarPanel(
          h4("Controls - Tab 4")
          # inputs
        ),
        mainPanel(
          h3("Content - Tab 4")
          # outputs
        )
      )
    ),
    
    tabPanel(
      title = "Tab 5",
      fluidRow(
        column(
          width = 6,
          h4("Left - Tab 5")
          # stuff
        ),
        column(
          width = 6,
          h4("Right - Tab 5")
          # stuff
        )
      )
    )
  )
)

server <- function(input, output, session) {
  # add server logic for each tab here
}

shinyApp(ui, server)
