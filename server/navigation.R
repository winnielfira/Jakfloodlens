# Flood Lens - Navigation Server Logic (NO GLITCH)

navigation_server <- function(input, output, session, values) {
  # ============================================================================
  # NAVIGATION HANDLERS - NO GLITCH VERSION
  # ============================================================================

  # MAIN EXPLORE DASHBOARD BUTTON
  observeEvent(input$enterDashboardMain, {
    session$sendCustomMessage(type = "toggleDashboard", message = TRUE)
    # NO IMMEDIATE TAB UPDATE - let it go to default "beranda"
  })

  # INDIVIDUAL BUTTON HANDLERS - DIRECT TAB NAVIGATION
  observeEvent(input$goToOverview, {
    # Set tab FIRST, then show dashboard
    updateTabItems(session, "tabs", "overview")
    Sys.sleep(0.05) # Tiny delay
    session$sendCustomMessage(type = "toggleDashboard", message = TRUE)
  })

  observeEvent(input$goToAnalysis, {
    # Set tab FIRST, then show dashboard
    updateTabItems(session, "tabs", "analysis")
    Sys.sleep(0.05) # Tiny delay
    session$sendCustomMessage(type = "toggleDashboard", message = TRUE)
  })

  observeEvent(input$goToPrediction, {
    # Set tab FIRST, then show dashboard
    updateTabItems(session, "tabs", "prediction")
    Sys.sleep(0.05) # Tiny delay
    session$sendCustomMessage(type = "toggleDashboard", message = TRUE)
  })

  # BACK TO LANDING
  observeEvent(input$backToLanding, {
    session$sendCustomMessage(type = "toggleDashboard", message = FALSE)
  })
}
