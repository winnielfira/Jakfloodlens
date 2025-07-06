# NOTE: sebelum run app, set working directory ke root dari project ya

# Flood Lens - Landing Page + Dashboard Asli
library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(DT)
library(leaflet)
library(readxl)
library(lubridate)
library(shinyjs)

# Source semua file
source("data/data_processing.R")
source("utils/functions.R")
source("ui/landing_page.R")
source("ui/dashboard.R")
source("server/navigation.R")
source("server/dashboard_logic.R")

# ============================================================================
# UI UTAMA - CONDITIONAL RENDERING DIPERBAIKI
# ============================================================================
ui <- div(
  useShinyjs(),
  tags$head(
    tags$script(HTML("
  $(document).ready(function() {
    $(document).on('shiny:connected', function() {
      var showDashboard = false;

      Shiny.addCustomMessageHandler('toggleDashboard', function(message) {
        showDashboard = message;
        Shiny.setInputValue('showDashboard', showDashboard);

        if(showDashboard) {
          $('.landing-container').hide();
          $('.dashboard-container').show();

          // SCROLL TO TOP SETELAH SHOW DASHBOARD
          setTimeout(function() {
            window.scrollTo(0, 0);
            $('html, body').scrollTop(0);
          }, 100);

          $('body').css({
            'background': 'white !important',
            'font-family': 'Poppins, sans-serif !important'
          });

        } else {
          $('.dashboard-container').hide();
          $('.landing-container').show();

          // SCROLL TO TOP KETIKA KEMBALI KE LANDING
          setTimeout(function() {
            window.scrollTo(0, 0);
            $('html, body').scrollTop(0);
          }, 100);

          $('body').css({
            'background': 'linear-gradient(135deg, #001F3F 0%, #3A6D8C 100%) !important',
            'font-family': 'Montserrat, sans-serif !important'
          });
        }
      });

      Shiny.setInputValue('showDashboard', false);
      $('.dashboard-container').hide();
      $('.landing-container').show();
    });
  });
"))
  ),

  # Landing Page Container
  div(
    class = "landing-container",
    landing_page_ui
  ),

  # Dashboard Container - LANGSUNG dashboard_ui TANPA wrapper
  div(
    class = "dashboard-container",
    dashboard_ui,
    style = "display: none;"
  )
)

# ============================================================================
# SERVER - GABUNGAN SEMUA LOGIC
# ============================================================================
server <- function(input, output, session) {
  # REACTIVE VALUES UNTUK PREDIKSI DAN STATE MANAGEMENT
  values <- reactiveValues(
    showDashboard = FALSE,
    current_risks = NULL,
    search_history = data.frame(
      timestamp = character(),
      rainfall = numeric(),
      temperature = numeric(),
      avg_risk = numeric(),
      risk_category = character(),
      stringsAsFactors = FALSE
    )
  )

  # CALL NAVIGATION SERVER
  navigation_server(input, output, session, values)

  # CALL DASHBOARD SERVER
  dashboard_server(input, output, session, values)
}

# RUN SHINY APP
shinyApp(ui = ui, server = server)
