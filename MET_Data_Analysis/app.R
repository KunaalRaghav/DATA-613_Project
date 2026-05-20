#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
library(docxtractr)
library(readxl)
library(scales)
library(keyring)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .tab-pane { min-height: 100vh; }
      .content-wrapper { padding: 20px; min-height: 100vh; }
    "))
  ),
  
  titlePanel(" The MET: A Presentation on Female Representation"),
  
  tabsetPanel(
    id="mainTabs",
    
    # ---------------- DIRECTORY TAB ----------------
    tabPanel("Directory",
             div(class = "content-wrapper", style = "background-color: #f8f9fa;",  # Light Grey
                 
                 h3("Welcome to The MET Shiny App"),
                 p("This app is brought to you by Kunaal Raghav."),
                 p("If you want to find out more about me, you can load up my personal biography in the input box below."),
                 p("My bio can be found as a Word file in the data folder of therepository."),
                 p("For ease of acess, the folder has been called up, and can be see in the dropdown below"),
                 
                 selectInput(
                   "choose_doc",
                   "Choose a biography Word file:",
                   choices = list.files("../data", pattern = "(?i)\\.docx$", full.names = FALSE)
                 ),
                 
                 downloadButton("download_bio", "Open Selected Biography"),
                 
                 hr(),
                 h4("Table of Contents"),
                 
                 tags$ul(
                   
                   # ---------------- STATS EXAM 1 ----------------
                   tags$li(
                     actionLink("go_exam1", HTML("<u>Tab: Stats Examination 1</u>")),
                     tags$ul(
                       tags$li("Query: Does the dataset show an increase in the acquisition of female artists’ work in the last 20 years?"),
                       tags$li("Graph 1: Bar chart of sex distribution by year"),
                       tags$li("Graph 2: Proportionality chart of sex distribution")
                     )
                   ),
                   
                   # ---------------- STATS EXAM 2 ----------------
                   tags$li(
                     actionLink("go_exam2", HTML("<u>Tab: Stats Examination 2</u>")),
                     tags$ul(
                       tags$li("Query: How many objects in the Textiles or Costume departments—traditionally female‑dominated labor—are listed without an artist's name compared to the Sculpture department?"),
                       tags$li("Graphs: User selects variables to compare; graphs show artist name included vs. missing across departments")
                     )
                   ),
                   
                   # ---------------- STATS EXAM 3 ----------------
                   tags$li(
                     actionLink("go_exam3", HTML("<u>Tab: Stats Examination 3</u>")),
                    
                     tags$ul(
                       tags$li("Query: What is the percentage of female creators in all of the departments?"),
                       tags$li("Graph 1: Bar chart of female creator percentages"),
                       tags$li("Graph 2: Pie chart of female creator proportions")
                     )
                   ),
                   
                   # ---------------- TEST TAB ----------------
                   tags$li(
                     actionLink("go_userguide", HTML("<u>Tab: User Guide</u>")),
                     
                     tags$ul(
                       tags$li("Filter the dataset by Year (Ascension_Year), Country (Cultures), Continent,Department, Artists Name and ARtist Sex"),
                       tags$li("Preview filtered data"),
                       tags$li("Download filtered Excel file"),
                       tags$li("Email the filtered file to yourself")
                     )
                   )
                 )
             )
    ),
    
    
    # ---------------- STATS EXAM 1 ----------------
    tabPanel("Stats Examination 1",
             h3("Statistical Examination 1"),
             
             p("This tab seeks to answer the following question:"),
             tags$ul(
               tags$li("Does the dataset show an increase in the acquisition of female artists’ work in the last 20 years?",
                       tags$ul(
                         tags$li("Done by looking at objects registered by year of creation"),
                         tags$li("Year of application in the Metropolitan Museum of Art could not be found, so this was the next best option")
                       )
               )
             ),
             
             p("Two graphs were created:"),
             tags$ul(
               tags$li("Graph 1",
                       tags$ul(
                         tags$li("Distribution of artist sex by year for the last 20 years")
                       )
               ),
               tags$li("Graph 2",
                       tags$ul(
                         tags$li("Proportion of female artists by year for the last 20 years, displayed as a percentage")
                       )
               )
             ),
             
             p("In the upload portion found below, please insert the excel file. It can be found in the data folder."),
             p("For ease of usage, a dropdown menu should open up with the ability to choose the excel file of interest."),
             
             selectInput(
               "excel_choice",
               "Choose Excel File:",
               choices = list.files(
                 "../data",
                 pattern = "\\.xlsx$",
                 full.names = FALSE
               )
             ),
             
             h4("Gender Distribution by Year (Last 20 Years)"),
             plotOutput("gender_year_plot"),
             
             h4("Female Artist Acquisition Trend (Last 20 Years)"),
             plotOutput("female_trend_plot")
    ),
    
    
    # ---------------- STATS EXAM 2 ----------------
    tabPanel("Stats Examination 2",
             div(class = "content-wrapper", style = "background-color: #f1f8e9;",  # Very Light Green
                 
                 h3("Statistical Examination 2"),
                 
                 p("This section will answer the following question:"),
                 p("How many objects in the Textiles or Costume departments—traditionally female‑dominated labor—are listed without an artist's name compared to the Sculpture department?"),
                 
                 p("Users must select the Excel file titled Stats_Exam_2. It can be found in the data folder."),
                 p("For seamless use, the directory has already been called. Select the proper Excel file from the dropdown menu below."),
                 
                 selectInput(
                   "plot_excel_choice",
                   "Choose Excel File:",
                   choices = list.files(
                     "../data",
                     pattern = "\\.xlsx$",
                     full.names = FALSE
                   )
                 ),
                 
                 p("Once the Excel file is selected, you can see how the artist name appears (or is missing) across the respective departments."),
                 p("You can compare: Textile vs Sculpture, Costume vs Sculpture, or both Textile and Costume vs Sculpture."),
                 
                 selectInput(
                   "comparison_choice",
                   "Choose Comparison:",
                   choices = c(
                     "Textiles vs Sculpture",
                     "Costume vs Sculpture",
                     "Both vs Sculpture"
                   )
                 ),
                 
                 hr(),
                 h4("Comparison of Missing Artist Names Across Departments"),
                 plotOutput("data_plot")
             )
    ),
    
    
    # ---------------- STATS EXAM 3 ----------------
    tabPanel("Stats Examination 3",
             div(class = "content-wrapper", style = "background-color: #fff3e0;",
                 
                 h3("Statistical Examination 3"),
                 
                 p("This section will answer the following question."),
                 p("What is the percentage of female creators in all departments?"),
                 
                 
                 selectInput(
                   "excel_choice_3",
                   "Choose Excel File:",
                   choices = list.files(
                     "../data",
                     pattern = "\\.xlsx$",
                     full.names = FALSE
                   )
                 ),
                 
                 h4("Bar Chart: Percentage of Female Creators"),
                 plotOutput("female_bar_plot"),
                 
                 h4("Pie Chart: Percentage of Female Creators"),
                 plotOutput("female_pie_plot")
                 
             )
             
             
    ),
    
    # ---------------- TEST TAB ----------------
    tabPanel("User Guide",
             div(class = "content-wrapper", style = "background-color: #f3e5f5;",
                 
                 h3("User Guide"),
                 p("Below is the dropdown menu."),
                 p("This section allows you to create a sheet listing out what art pieces might interest you"),
                 p("In terms of modifying interest areas, one can adjust for specific years of focus, countries and ciontinents of interest, and dpeartment of interest"),
                 p("A sheet should return with the proper filters, which you can donload/email to your email, and use that as a guide"),
                 
                 
                 
                 selectInput(
                   "test_excel_choice",
                   "Choose Excel File:",
                   choices = list.files("../data", pattern = "\\.xlsx$", full.names = FALSE)
                 ),
                 
                 hr(),
                 h4("Filter Options"),
                 
                 uiOutput("year_filter"),
                 uiOutput("country_filter"),
                 uiOutput("continent_filter"),
                 uiOutput("department_filter"),
                 uiOutput("artist_name_filter"),
                 uiOutput("artist_sex_filter"),
                 
                 
                 actionButton("apply_filters", "Apply Filters", class = "btn-primary"),
                 
                 hr(),
                 h4("Filtered Data Preview"),
                 tableOutput("test_preview"),
                 
                 hr(),
                 downloadButton("test_download", "Download Filtered Excel"),
                 
                 br(), br(),
                 actionButton("test_email", "Email Me the File")
             )
    )
    
  ) # end tabsetPanel
) # end fluidPage











server <- function(input, output, session) {
  observeEvent(input$go_exam1, {
    updateTabsetPanel(session, "mainTabs", selected = "Stats Examination 1")
  })
  
  observeEvent(input$go_exam2, {
    updateTabsetPanel(session, "mainTabs", selected = "Stats Examination 2")
  })
  
  observeEvent(input$go_exam3, {
    updateTabsetPanel(session, "mainTabs", selected = "Stats Examination 3")
  })
  
  observeEvent(input$go_userguide, {
    updateTabsetPanel(session, "mainTabs", selected = "User Guide")
  })
  
  
  # ---------------------------------------------------
  # WORD FILE DOWNLOAD
  # ---------------------------------------------------
  output$download_bio <- downloadHandler(
    filename = function() { input$choose_doc },
    content = function(file) {
      file.copy(from = file.path("../data", input$choose_doc), to = file)
    }
  )
  
  # ---------------------------------------------------
  # EXCEL FILE READER FOR STATS EXAM 1
  # ---------------------------------------------------
  dataset <- reactive({
    req(input$excel_choice)
    read_excel(file.path("../data", input$excel_choice))
  })
  
  # ---------------------------------------------------
  # STATS EXAM 1 PLOTS
  # ---------------------------------------------------
  output$gender_year_plot <- renderPlot({
    df <- dataset()
    req(df$Ascension_Year, df$Artist_Sex)
    
    df <- df |>
      mutate(
        Ascension_Year = as.numeric(Ascension_Year),
        Artist_Sex = stringr::str_to_title(trimws(Artist_Sex))  # normalize case
      ) |>
      filter(
        !is.na(Ascension_Year),
        Artist_Sex %in% c("Male", "Female")  # only Male/Female
      )
    
    max_year <- max(df$Ascension_Year, na.rm = TRUE)
    min_year <- max_year - 19
    
    df_filtered <- df |>
      filter(Ascension_Year >= min_year & Ascension_Year <= max_year)
    
    ggplot(df_filtered, aes(x = Ascension_Year, fill = Artist_Sex)) +
      geom_bar(position = "fill") +
      scale_x_continuous(breaks = seq(min_year, max_year, 1)) +
      scale_y_continuous(labels = scales::percent_format()) +
      labs(
        title = paste0("Artist Sex Distribution by Ascension Year (", min_year, "–", max_year, ")"),
        x = "Ascension Year",
        y = "Proportion",
        fill = "Artist Sex"
      ) +
      theme_minimal()
  })
  
  
  output$female_trend_plot <- renderPlot({
    df <- dataset()
    req(df$Ascension_Year, df$Artist_Sex)
    
    df <- df |>
      mutate(
        Ascension_Year = as.numeric(Ascension_Year),
        Artist_Sex = stringr::str_to_title(trimws(Artist_Sex))  # normalize case
      ) |>
      filter(
        !is.na(Ascension_Year),
        Artist_Sex %in% c("Male", "Female")  # only Male/Female
      )
    
    max_year <- max(df$Ascension_Year, na.rm = TRUE)
    min_year <- max_year - 19
    
    df_filtered <- df |>
      filter(Ascension_Year >= min_year & Ascension_Year <= max_year)
    
    trend <- df_filtered |>
      group_by(Ascension_Year) |>
      summarise(female_prop = mean(Artist_Sex == "Female", na.rm = TRUE))
    
    ggplot(trend, aes(x = Ascension_Year, y = female_prop)) +
      geom_line(color = "purple", linewidth = 1.4) +
      geom_point(color = "purple", size = 3) +
      scale_y_continuous(labels = scales::percent_format()) +
      scale_x_continuous(breaks = seq(min_year, max_year, 1)) +
      labs(
        title = paste0("Trend in Female Artist Acquisitions (", min_year, "–", max_year, ")"),
        x = "Ascension Year",
        y = "Proportion Female"
      ) +
      theme_minimal()
  })
  
  
  
  
  # ---------------------------------------------------
  # STATS EXAM 2 PLOT
  # ---------------------------------------------------
  output$data_plot <- renderPlot({
    req(input$plot_excel_choice)
    df <- read_excel(file.path("../data", input$plot_excel_choice))
    
    req(all(c("Department", "Artist_Name") %in% names(df)))
    
    df <- df %>%
      mutate(
        Department  = trimws(Department),
        Artist_Name = trimws(Artist_Name)
      ) %>%
      # keep only rows with an artist name
      filter(!is.na(Artist_Name), Artist_Name != "")
    
    # define comparison groups
    comparison <- switch(
      input$comparison_choice,
      "Textiles vs Sculpture" = list(
        other_label = "Textiles",
        other_depts = c("Textiles")
      ),
      "Costume vs Sculpture" = list(
        other_label = "Costume",
        other_depts = c("Costume")
      ),
      "Both vs Sculpture" = list(
        other_label = "Textiles + Costume",
        other_depts = c("Textiles", "Costume")
      )
    )
    
    # summarise counts: Sculpture vs comparison group
    summary_counts <- bind_rows(
      df %>%
        filter(Department == "Sculpture") %>%
        summarise(
          Group = "Sculpture",
          count = n()
        ),
      df %>%
        filter(Department %in% comparison$other_depts) %>%
        summarise(
          Group = comparison$other_label,
          count = n()
        )
    )
    
    summary_counts$Group <- factor(
      summary_counts$Group,
      levels = c(comparison$other_label, "Sculpture")
    )
    
    ggplot(summary_counts, aes(x = Group, y = count, fill = Group)) +
      geom_col(width = 0.6) +
      labs(
        title = paste(
          "Objects With Artist Names —",
          input$comparison_choice
        ),
        x = "Group",
        y = "Number of Objects with Artist Name",
        fill = "Group"
      ) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")
  })
  
  # ---------------------------------------------------
  # STATS EXAM 3 PLOTS
  # ---------------------------------------------------
  output$female_bar_plot <- renderPlot({
    req(input$excel_choice_3)
    df <- read_excel(file.path("../data", input$excel_choice_3))
    
    # Normalize text
    df$Department <- stringr::str_to_title(trimws(df$Department))
    df$Artist_Sex <- stringr::str_to_title(trimws(df$Artist_Sex))
    
    # Compute female percentage for ALL departments
    pct_df <- df %>%
      group_by(Department) %>%
      summarise(
        female_pct = mean(Artist_Sex == "Female", na.rm = TRUE) * 100
      ) %>%
      mutate(
        female_pct = ifelse(is.na(female_pct), 0, female_pct),
        label = paste0(round(female_pct, 1), "%")   # label for display
      )
    
    ggplot(pct_df, aes(x = Department, y = female_pct, fill = Department)) +
      geom_col() +
      geom_text(aes(label = label), vjust = -0.5, size = 5) +   # <-- ADDED LABELS
      scale_y_continuous(labels = scales::percent_format(scale = 1),
                         expand = expansion(mult = c(0, 0.1))) + # extra space for labels
      labs(
        title = "Percentage of Female Creators by Department",
        x = "Department",
        y = "Percent Female"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1)
      )
  })
  
  
  
  
  output$female_pie_plot <- renderPlot({
    req(input$excel_choice_3)
    df <- read_excel(file.path("../data", input$excel_choice_3))
    
    # Normalize text
    df$Department <- stringr::str_to_title(trimws(df$Department))
    df$Artist_Sex <- stringr::str_to_title(trimws(df$Artist_Sex))
    
    # Compute female percentage for ALL departments
    pct_df <- df %>%
      group_by(Department) %>%
      summarise(
        female_pct = mean(Artist_Sex == "Female", na.rm = TRUE) * 100
      ) %>%
      mutate(
        female_pct = ifelse(is.na(female_pct), 0, female_pct),
        female_pct_adj = ifelse(female_pct == 0, 0.0001, female_pct),  # tiny slice so 0% shows
        label = paste0(Department, ": ", round(female_pct, 1), "%")
      )
    
    ggplot(pct_df, aes(x = "", y = female_pct_adj, fill = Department)) +
      geom_col(width = 1) +
      coord_polar(theta = "y") +
      labs(title = "Female Creator Percentage by Department") +
      theme_void(base_size = 14) +
      geom_text(
        aes(label = label),
        position = position_stack(vjust = 0.5),
        size = 4
      )
  })
  
  
  
  # ---------------------------------------------------
  # TEST TAB — DATA + FILTERS
  # ---------------------------------------------------
  test_data <- reactive({
    req(input$test_excel_choice)
    read_excel(file.path("../data", input$test_excel_choice))
  })
  
  output$year_filter <- renderUI({
    req(test_data())
    textInput(
      "filter_year",
      "Enter  Single Year or Range:",
      placeholder = "Example: 1990 or 1800-2001"
    )
  })
  
  
  output$country_filter <- renderUI({
    df <- test_data()
    req("Cultures" %in% names(df))
    
    selectizeInput(
      "filter_country",
      "Select Country (Cultures):",
      choices = sort(unique(df$Cultures)),
      selected = NULL,
      multiple = TRUE,
      options = list(
        placeholder = "Type to search countries...",
        closeAfterSelect = TRUE
      )
    )
  })
  
  output$continent_filter <- renderUI({
    df <- test_data()
    req("Continent" %in% names(df))
    
    selectizeInput(
      "filter_continent",
      "Select Continent:",
      choices = sort(unique(df$Continent)),
      selected = NULL,
      multiple = TRUE,
      options = list(
        placeholder = "Type to search continents...",
        closeAfterSelect = TRUE
      )
    )
  })
  
  output$department_filter <- renderUI({
    df <- test_data()
    req("Department" %in% names(df))
    
    selectizeInput(
      "filter_department",
      "Select Department:",
      choices = sort(unique(df$Department)),
      selected = NULL,
      multiple = TRUE,
      options = list(
        placeholder = "Type to search departments...",
        closeAfterSelect = TRUE
      )
    )
  })
  
  output$artist_name_filter <- renderUI({
    df <- test_data()
    req("Artist_Name" %in% names(df))
    
    selectizeInput(
      "filter_artist_name",
      "Select Artist Name:",
      choices = sort(unique(df$Artist_Name)),
      selected = NULL,
      multiple = TRUE,
      options = list(
        placeholder = "Type to search artist names...",
        closeAfterSelect = TRUE
      )
    )
  })
  
  output$artist_sex_filter <- renderUI({
    df <- test_data()
    req("Artist_Sex" %in% names(df))
    
    selectizeInput(
      "filter_artist_sex",
      "Select Artist Sex:",
      choices = sort(unique(df$Artist_Sex)),
      selected = NULL,
      multiple = TRUE,
      options = list(
        placeholder = "Type to search artist sex...",
        closeAfterSelect = TRUE
      )
    )
  })
  
  
  # ---------------------------------------------------
  # APPLY FILTERS (FIXED)
  # ---------------------------------------------------
  filtered_data <- eventReactive(input$apply_filters, {
    df <- test_data()
    
    # Build OR conditions
    conditions <- list()
    
    # Year condition (supports single years + ranges)
    if ("Ascension_Year" %in% names(df) && nchar(input$filter_year) > 0) {
      
      # Split by comma
      parts <- trimws(unlist(strsplit(input$filter_year, ",")))
      all_years <- c()
      
      for (p in parts) {
        # Detect range like "1990-1995"
        if (grepl("-", p)) {
          bounds <- trimws(unlist(strsplit(p, "-")))
          nums <- suppressWarnings(as.numeric(bounds))
          
          if (length(nums) == 2 && !any(is.na(nums))) {
            all_years <- c(all_years, seq(nums[1], nums[2]))
          }
          
        } else {
          # Single year
          yr <- suppressWarnings(as.numeric(p))
          if (!is.na(yr)) {
            all_years <- c(all_years, yr)
          }
        }
      }
      
      # Deduplicate
      all_years <- unique(all_years)
      
      if (length(all_years) > 0) {
        conditions[["year"]] <- df$Ascension_Year %in% all_years
      }
    }
    # Country condition
    if ("Cultures" %in% names(df) && length(input$filter_country) > 0) {
      conditions[["country"]] <- df$Cultures %in% input$filter_country
    }
    
    # Continent condition
    if ("Continent" %in% names(df) && length(input$filter_continent) > 0) {
      conditions[["continent"]] <- df$Continent %in% input$filter_continent
    }
    
    # Department condition
    if ("Department" %in% names(df) && length(input$filter_department) > 0) {
      conditions[["department"]] <- df$Department %in% input$filter_department
    }
    
    # Artist Name condition
    if ("Artist_Name" %in% names(df) && length(input$filter_artist_name) > 0) {
      conditions[["artist_name"]] <- df$Artist_Name %in% input$filter_artist_name
    }
    
    # Artist Sex condition
    if ("Artist_Sex" %in% names(df) && length(input$filter_artist_sex) > 0) {
      conditions[["artist_sex"]] <- df$Artist_Sex %in% input$filter_artist_sex
    }
    
    # If no filters selected, return full dataset
    if (length(conditions) == 0) return(df)
    
    # OR logic: keep rows that satisfy ANY condition
    keep <- Reduce(`|`, conditions)
    
    df[keep, ]
  })
  
  # Preview
  output$test_preview <- renderTable({
    req(filtered_data())
    head(filtered_data(), 20)
  })
  
  # Download
  output$test_download <- downloadHandler(
    filename = function() { "filtered_data.xlsx" },
    content = function(file) {
      writexl::write_xlsx(filtered_data(), file)
    }
  )
  
  # ---------------------------------------------------
  # EMAIL (unchanged)
  # ---------------------------------------------------
  observeEvent(input$test_email, {
    req(filtered_data())
    
    temp_file <- tempfile(fileext = ".xlsx")
    writexl::write_xlsx(filtered_data(), temp_file)
    
    outlook_user <- keyring::key_get("outlook_email")
    outlook_pass <- keyring::key_get("outlook_password")
    
    email <- blastula::compose_email(
      body = "
        <p>Hello,</p>
        <p>Your filtered Excel file from the Shiny Test tab is attached.</p>
        <p>Regards,<br>Shiny App</p>
      "
    )
    
    blastula::smtp_send(
      email = email,
      from = outlook_user,
      to = outlook_user,
      subject = "Your Filtered Excel File",
      attachments = temp_file,
      credentials = blastula::creds(
        user = outlook_user,
        pass = outlook_pass,
        host = "smtp.office365.com",
        port = 587,
        use_ssl = FALSE
      )
    )
    
    showNotification("Email sent successfully via Outlook!", type = "message")
  })
  
}



# Run the application 
shinyApp(ui = ui, server = server)