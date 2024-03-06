server <- function(input, output, session) {
  

  showSuccessMessage <- reactiveVal(FALSE)
  
  # Function to show modal dialog with custom message
  
  showCustomModal1 <- function(message, easyClose = FALSE, size = "m", position = c("top" = "20%", "left" = "50%")) {
    showModal(
      modalDialog(
        title = "Capturing... Please wait",
        message = message,
        easClose = TRUE,
        size = size,
        style = paste0("top: ", position["top"], "; left: ", position["left"], ";"),
        footer = NULL
      )
    )
    
    # Delay for 2 seconds
    Sys.sleep(5)
    
    # Remove the modal after the delay
    removeModal()
  }
  
  
  showCustomModal2 <- function(message, easyClose = TRUE, size = "m", position = c("top" = "20%", "left" = "50%")) {
    showModal(
      modalDialog(
        title = "Success! Publication Captured",
        message = message,
        easyClose = easyClose,
        size = size,
        style = paste0("top: ", position["top"], "; left: ", position["left"], ";")
      )
    )
  }
  
  
  # Observer for capturing data
  observeEvent(input$submit, {
    
    # Display "Capturing" message
    showCustomModal1("Capturing... Please wait.", easyClose = FALSE, size = "m", position = c("top" = "20%", "left" = "50%"))
    
    # Process the data
    response_data <- getSurveyData()
    
    # Read your sheet
    values <- read_sheet(ss = sheet_id, sheet = "main")
    
    if (nrow(values) == 0) {
      sheet_write(data = response_data, ss = sheet_id, sheet = "main")
    } else {
      sheet_append(data = response_data, ss = sheet_id, sheet = "main")
    }
    
    showSuccessMessage(TRUE)
    
    # Print the survey data (for debugging purposes)
    print(getSurveyData())
  })
  
  # Observer to close the modal when data capturing is successful
  observe({
    if (showSuccessMessage()) {
      showCustomModal2("Success! Your publication has been captured.", easyClose = TRUE, size = "m", position = c("top" = "20%", "left" = "50%"))
      showSuccessMessage(FALSE)  # Reset the reactive variable
    }
  })
  
  renderSurvey()
  
  
  
  ####
  
  
  output$table <- renderDataTable({
    data <- data.frame(
      Category = c(
        "NZ Antarctic & Southern Ocean",
        "Antarctic Science Platform",
        "Antarctica NZ Acknowledged",
        "Antarctica NZ Supported",
        "Total Antarctica NZ"
      ),
      Description = c(
        "All Antarctic and Southern Ocean publications that include at least one NZ author",
        "Publications that originate from Antarctic Science Platform funding",
        "Publication directly acknowledges Antarctica NZ's support",
        "Publications that don't acknowledge Antarctica NZ but received support (e.g. supported instruments or sample collection)",
        "Antarctic Science Platform + Antarctica NZ Acknowledged + Antarctica NZ Supported"
      )
    )
    
    DT::datatable(data, 
                  options = list(
                    dom = 't',  # 't' removes the entire table toolbar
                    paging = FALSE,  # Disable paging
                    ordering = FALSE,
                    autoWidth = TRUE
                  ),
                  rownames = FALSE
    )
  })
  
  

  
  output$totalsPlot <- renderPlotly({
    # Example scatter plot using the mtcars dataset
    ggplotly(ggplot(antnz_totals_graph, aes(x = Year, y = Publications, colour = Origin)) +
               theme_bw() +
               geom_hline(yintercept = seq(0, 250, by = 50), linetype = "solid", color = "lightgray", linewidth = 0.6) +
               geom_line(linewidth = 0.8) +
               scale_y_continuous(limits = c(0, 250), breaks = c(0, 50, 100, 150, 200, 250), expand = c(0, 0)) +
               scale_x_continuous(breaks = seq(2010, 2022, by = 1)) +
               scale_color_manual(values = c("#000000", "#FF8000", "#009900", "#0080FF")) +
               theme(
                 panel.border = element_rect(color = "black", fill = NA, linetype = "solid", linewidth = 1.5),
                 axis.line = element_line(colour = "black", linewidth = 0.6),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(),
                 legend.position = "bottom",
                 legend.box = "horizontal",
                 legend.justification = "center",  # Center the legend horizontally
                 legend.key = element_blank(),
                 legend.title = element_blank(),
                 legend.text = element_text(size = 8, margin = margin(b = 5)),
                 axis.title.y = element_text(size = 11, margin = margin(r = 8)),
                 axis.title.x = element_text(size = 11, margin = margin(t = 8)),
                 axis.text.x = element_text(angle = 0, hjust = 0.95, vjust = 1.05, size = 10, margin = margin(t = 5)),
                 axis.text.y = element_text(size = 10, margin = margin(r = 5)),
                 axis.ticks = element_line(linewidth = 0.6),
                 legend.margin = margin(0, 0, 0, 0),
                 legend.box.spacing = unit(0.5, "lines"),
                 plot.margin = margin(10, 10, 10, 10)) +
               guides(color = guide_legend(title = NULL, ncol = 1)) + # Set ncol to 1 for a single column in the legend
               labs(x = "Publication Year", y = "Total Publications"),
             width = 850,
             height = 500) %>%
      layout(legend = list(orientation = "h",  
                           xanchor = "center",  
                           x = 0.5,
                           y = -0.2))  
  })
  
  output$citationPlot <- renderPlotly({
    # Example scatter plot using the mtcars dataset with a different variable
    
    ggplotly(ggplot(antnz_citation_6y, aes(x = `6-Year Citation Period`, y = `Total Citations`, group = 1, color = Origin)) +
               theme_bw() +
               geom_hline(yintercept = seq(0, 5000, by = 1000), linetype = "solid", color = "lightgray", linewidth = 0.6) +
               geom_line(linewidth = 1, aes(colour = Origin)) +
               scale_color_manual(values = "#FF8000") +  # Specifying color and legend title
               scale_y_continuous(limits = c(0, 5000), breaks = seq(0, 5000, 1000), expand = c(0, 0), labels = c("0", "1k", "2k", "3k", "4k", "5k"))+
               theme(
                 panel.border = element_rect(color = "black", fill = NA, linetype = "solid", linewidth = 1.5),
                 axis.line = element_line(colour = "black", linewidth = 0.6),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(),
                 legend.box = "horizontal",
                 legend.justification = "center",  # Center the legend horizontally
                 legend.key = element_blank(),
                 legend.title = element_blank(),
                 legend.text = element_text(size = 8, margin = margin(b = 5)),
                 axis.title.y = element_text(size = 11, margin = margin(r = 8)),
                 axis.title.x = element_text(size = 11, margin = margin(t = 8)),
                 axis.text.x = element_text(hjust = 0.95, vjust = 1.05, size = 10, margin = margin(t = 5)),
                 axis.text.y = element_text(size = 10, margin = margin(r = 5)),
                 axis.ticks = element_line(linewidth = 0.6),
                 legend.margin = margin(0, 0, 0, 0),
                 legend.box.spacing = unit(0.5, "lines"),
                 plot.margin = margin(10, 10, 10, 10)) +
               guides(color = guide_legend(title = NULL, ncol = 1)) + # Set ncol to 1 for a single column in the legend
               labs(x = "6-Year Citation Period", y = "Total Citations"),
             width = 850,
             height = 500) %>%
      layout(legend = list(orientation = "h",  
                           xanchor = "center",  
                           x = 0.5,
                           y = -0.2))   
    
  })
  
  output$percentilePlot <- renderPlotly({
    ggplotly(ggplot(percentPercentileData, aes(x = Year, y = Publications, colour = `Journal Percentile`)) +
               theme_bw() +
               geom_hline(yintercept = seq(0, 100, by = 10), linetype = "solid", color = "lightgray", linewidth = 0.6) +
               geom_line(linewidth = 1) +
               scale_y_continuous(limits = c(0, 80), breaks = seq(0, 80, 20), expand = c(0, 0)) +
               scale_x_continuous(breaks = seq(2012, 2022, by = 1)) +
               theme(
                 panel.border = element_rect(color = "black", fill = NA, linetype = "solid", linewidth = 1.5),
                 axis.line = element_line(colour = "black", linewidth = 0.6),
                 panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(),
                 panel.background = element_blank(),
                 legend.position = "bottom",
                 legend.box = "horizontal",
                 legend.justification = "center",  # Center the legend horizontally
                 legend.key = element_blank(),
                 legend.title = element_blank(),
                 legend.text = element_text(size = 8, margin = margin(b = 5)),
                 axis.title.y = element_text(size = 11, margin = margin(r = 8)),
                 axis.title.x = element_text(size = 11, margin = margin(t = 8)),
                 axis.text.x = element_text(angle = 0, size = 10, margin = margin(t = 5)),
                 axis.text.y = element_text(size = 10, margin = margin(r = 5)),
                 axis.ticks = element_line(linewidth = 0.6),
                 legend.margin = margin(0, 0, 0, 0),
                 legend.box.spacing = unit(0.5, "lines"),
                 plot.margin = margin(10, 10, 10, 10)) +
               guides(color = guide_legend(title = NULL, ncol = 1)) + # Set ncol to 1 for a single column in the legend
               labs(x = "Publication Year", y = "Total Publications"),
             width = 850,
             height = 500) %>%
      layout(legend = list(orientation = "h",  
                           xanchor = "center",  
                           x = 0.5,
                           y = -0.2))      
    
  })
  
  
  
  
  output$downloadAntnzAck <- downloadHandler(
    filename = function() {
      paste("Antarctica NZ Acknowledged Publications -- 2010-2022 -- Retrieved ", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(antnzAcknowledged, file, row.names = FALSE)
    }
  )
  
  output$downloadAntnzSupport <- downloadHandler(
    filename = function() {
      paste("Antarctica NZ Supported Publications -- 2010-2022 -- Retrieved ", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(antnzSupported, file, row.names = FALSE)
    }
  )
  
  output$downloadAsp <- downloadHandler(
    filename = function() {
      paste("Antarctic Science Platform Publications -- 2020-2022 -- Retrieved ", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(asp, file, row.names = FALSE)
    }
  )
  
  output$downloadTotalAntnz <- downloadHandler(
    filename = function() {
      paste("Total Antarctica New Zealand Publications -- 2010-2022 -- Retrieved ", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(totalAntnz, file, row.names = FALSE)
    }
  )
  
  output$downloadAntSci <- downloadHandler(
    filename = function() {
      paste("New Zealand Antarctic & Southern Ocean Publications -- 1996-2022 -- Retrieved ", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(antSci, file, row.names = FALSE)
    }
  )
  
  
  
}
