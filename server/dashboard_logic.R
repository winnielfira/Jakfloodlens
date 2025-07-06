# Flood Lens - Dashboard Server Logic (Updated with Excel Data)

dashboard_server <- function(input, output, session, values) {
  # ============================================================================
  # REACTIVE DATA
  # ============================================================================

  # ANALISIS DATA - REACTIVE DATA
  analysis_filtered_data <- reactive({
    data <- climate_data

    if (input$analysis_city != "DKI Jakarta") {
      data <- data %>% filter(City == input$analysis_city)
    }

    return(data)
  })

  # GET ANALYSIS CITY NAME
  get_analysis_city_name <- reactive({
    if (is.null(input$analysis_city) || input$analysis_city == "DKI Jakarta") {
      return("DKI Jakarta")
    }

    return(input$analysis_city)
  })

  # REACTIVE DATA BERDASARKAN FILTER
  filtered_data <- reactive({
    data <- climate_data

    if (input$selected_city != "DKI Jakarta") {
      data <- data %>% filter(City == input$selected_city)
    }

    if (input$selected_year != "all") {
      data <- data %>% filter(Year == as.numeric(input$selected_year))
    }

    return(data)
  })

  # ============================================================================
  # OVERVIEW TAB OUTPUTS
  # ============================================================================

  # 1. CURAH HUJAN OUTPUTS
  output$rainfall_avg_box <- renderUI({
    data <- filtered_data()
    avg_rainfall <- round(mean(data$Rainfall, na.rm = TRUE), 1)
    create_infobox(paste0(avg_rainfall, " mm"), "Rata-rata Harian", "cloud-rain", colors$primary)
  })

  output$rainfall_max_box <- renderUI({
    data <- filtered_data()
    max_rainfall <- round(max(data$Rainfall, na.rm = TRUE), 0)
    create_infobox(paste0(max_rainfall, " mm"), "Curah Hujan Maksimum", "cloud-showers-heavy", colors$secondary)
  })

  output$extreme_days_box <- renderUI({
    data <- filtered_data()
    extreme_days <- data %>%
      filter(Extreme_Rain_Day == 1) %>%
      distinct(Year, Month, Day) %>%
      nrow()
    create_infobox(paste0(extreme_days, " hari"), "Hari Hujan Ekstrem (>5mm)", "bolt", colors$tertiary)
  })

  output$rainfall_trend_box <- renderUI({
    data <- filtered_data()
    if (input$selected_year == "all") {
      yearly_data <- data %>%
        group_by(Year) %>%
        summarise(Total = sum(Rainfall, na.rm = TRUE))
      if (nrow(yearly_data) >= 2) {
        trend <- round(((yearly_data$Total[nrow(yearly_data)] - yearly_data$Total[1]) / yearly_data$Total[1]) * 100, 1)
        trend_text <- ifelse(trend > 0, paste0("+", trend, "%"), paste0(trend, "%"))
      } else {
        trend_text <- "N/A"
      }
    } else {
      trend_text <- "N/A"
    }
    create_infobox(trend_text, "Tren Tahunan", "chart-line", colors$accent)
  })

  output$rainfall_trend_plot <- renderPlotly({
    data <- filtered_data()

    if (input$selected_year == "all") {
      plot_data <- data %>%
        group_by(Year, Month) %>%
        summarise(Avg_Rainfall = mean(Rainfall, na.rm = TRUE), .groups = "drop") %>%
        mutate(Date = as.Date(paste(Year, Month, "01", sep = "-")))
    } else {
      plot_data <- data %>%
        group_by(Month) %>%
        summarise(Avg_Rainfall = mean(Rainfall, na.rm = TRUE), .groups = "drop") %>%
        mutate(Month_Name = month.abb[Month])
    }

    if (input$selected_year == "all") {
      p <- plot_ly(plot_data,
        x = ~Date, y = ~Avg_Rainfall, type = "scatter", mode = "lines+markers",
        line = list(color = colors$primary, width = 3),
        marker = list(color = colors$primary, size = 6)
      ) %>%
        layout(
          title = list(text = paste("Tren Curah Hujan -", input$selected_city), font = list(family = "Poppins")),
          xaxis = list(title = "Tahun", titlefont = list(family = "Poppins")),
          yaxis = list(title = "Curah Hujan (mm)", titlefont = list(family = "Poppins")),
          font = list(family = "Poppins")
        )
    } else {
      p <- plot_ly(plot_data,
        x = ~Month_Name, y = ~Avg_Rainfall, type = "bar",
        marker = list(color = colors$primary)
      ) %>%
        layout(
          title = list(
            text = paste("Curah Hujan Bulanan", input$selected_year, "-", input$selected_city),
            font = list(family = "Poppins")
          ),
          xaxis = list(title = "Bulan", titlefont = list(family = "Poppins")),
          yaxis = list(title = "Curah Hujan (mm)", titlefont = list(family = "Poppins")),
          font = list(family = "Poppins")
        )
    }

    p %>% config(displayModeBar = FALSE)
  })

  output$rainfall_interpretation <- renderUI({
    data <- filtered_data()
    avg_rainfall <- round(mean(data$Rainfall, na.rm = TRUE), 1)
    max_rainfall <- round(max(data$Rainfall, na.rm = TRUE), 0)
    extreme_days <- sum(data$Extreme_Rain_Day, na.rm = TRUE)

    div(
      style = paste0("color: ", colors$primary, ";"),
      p(style = "font-weight: 600; margin-bottom: 10px;", "Analisis Curah Hujan:"),
      p(style = "margin-bottom: 8px;", paste0("• Rata-rata harian: ", avg_rainfall, " mm")),
      p(style = "margin-bottom: 8px;", paste0("• Intensitas maksimum: ", max_rainfall, " mm")),
      p(style = "margin-bottom: 8px;", paste0("• Hari hujan ekstrem: ", extreme_days, " hari")),
      p(
        style = "margin-bottom: 8px; font-style: italic;",
        ifelse(avg_rainfall > 150, "Curah hujan tinggi, risiko banjir meningkat",
          ifelse(avg_rainfall > 100, "Curah hujan sedang, perlu monitoring",
            "Curah hujan rendah, risiko banjir minimal"
          )
        )
      )
    )
  })

  # 2. SUHU OUTPUTS
  output$temp_avg_box <- renderUI({
    data <- filtered_data()
    avg_temp <- round(mean(data$Temperature, na.rm = TRUE), 1)
    create_infobox(paste0(avg_temp, "°C"), "Rata-rata Tahunan", "thermometer-half", colors$secondary)
  })

  output$temp_max_box <- renderUI({
    data <- filtered_data()
    max_temp <- round(max(data$Temperature, na.rm = TRUE), 1)
    create_infobox(paste0(max_temp, "°C"), "Suhu Maksimum", "thermometer-full", colors$tertiary)
  })

  output$temp_min_box <- renderUI({
    data <- filtered_data()
    min_temp <- round(min(data$Temperature, na.rm = TRUE), 1)
    create_infobox(paste0(min_temp, "°C"), "Suhu Minimum", "thermometer-empty", colors$primary)
  })

  output$temp_variation_box <- renderUI({
    data <- filtered_data()
    temp_sd <- round(sd(data$Temperature, na.rm = TRUE), 1)
    create_infobox(paste0("±", temp_sd, "°C"), "Variasi Harian", "arrows-alt-v", colors$accent)
  })

  output$temperature_trend_plot <- renderPlotly({
    data <- filtered_data()

    if (input$selected_year == "all") {
      plot_data <- data %>%
        group_by(Year, Month) %>%
        summarise(Avg_Temperature = mean(Temperature, na.rm = TRUE), .groups = "drop") %>%
        mutate(Date = as.Date(paste(Year, Month, "01", sep = "-")))

      p <- plot_ly(plot_data,
        x = ~Date, y = ~Avg_Temperature, type = "scatter", mode = "lines+markers",
        line = list(color = colors$secondary, width = 3),
        marker = list(color = colors$secondary, size = 6)
      )
    } else {
      plot_data <- data %>%
        group_by(Month) %>%
        summarise(Avg_Temperature = mean(Temperature, na.rm = TRUE), .groups = "drop") %>%
        mutate(Month_Name = factor(month.abb[Month], levels = month.abb))

      p <- plot_ly(plot_data,
        x = ~Month_Name, y = ~Avg_Temperature, type = "scatter", mode = "lines+markers",
        line = list(color = colors$secondary, width = 3),
        marker = list(color = colors$secondary, size = 8)
      )
    }

    p %>%
      layout(
        title = list(text = paste("Tren Suhu -", input$selected_city), font = list(family = "Poppins")),
        xaxis = list(
          title = ifelse(input$selected_year == "all", "Tahun", "Bulan"),
          titlefont = list(family = "Poppins")
        ),
        yaxis = list(title = "Suhu (°C)", titlefont = list(family = "Poppins")),
        font = list(family = "Poppins")
      ) %>%
      config(displayModeBar = FALSE)
  })

  output$temperature_interpretation <- renderUI({
    data <- filtered_data()
    avg_temp <- round(mean(data$Temperature, na.rm = TRUE), 1)
    max_temp <- round(max(data$Temperature, na.rm = TRUE), 1)
    min_temp <- round(min(data$Temperature, na.rm = TRUE), 1)

    div(
      style = paste0("color: ", colors$secondary, ";"),
      p(style = "font-weight: 600; margin-bottom: 10px;", "Analisis Suhu:"),
      p(style = "margin-bottom: 8px;", paste0("• Rata-rata: ", avg_temp, "°C")),
      p(style = "margin-bottom: 8px;", paste0("• Rentang: ", min_temp, "°C - ", max_temp, "°C")),
      p(style = "margin-bottom: 8px;", paste0("• Variasi: ±", round(sd(data$Temperature, na.rm = TRUE), 1), "°C")),
      p(
        style = "margin-bottom: 8px; font-style: italic;",
        ifelse(avg_temp > 29, "Suhu tinggi, meningkatkan evaporasi",
          ifelse(avg_temp > 27, "Suhu normal untuk wilayah tropis",
            "Suhu relatif sejuk"
          )
        )
      )
    )
  })

  # 3. BANJIR OUTPUTS
  output$flood_per_year_box <- renderUI({
    data <- filtered_data()
    if (input$selected_year == "all") {
      floods_in_a_year <- data %>%
        filter(Flood_Occurred == 1) %>%
        distinct(Year, Month, Day) %>%
        nrow()

      floods_per_year <- round(floods_in_a_year / length(unique(data$Year)), 1)
      subtitle <- "Kejadian per Tahun"

      create_infobox(paste0(floods_per_year, " kejadian"), subtitle, "exclamation-triangle", colors$tertiary)
    } else {
      floods_in_a_year <- data %>%
        filter(Flood_Occurred == 1) %>%
        distinct(Year, Month, Day) %>%
        nrow()

      subtitle <- paste("Kejadian Tahun", input$selected_year)

      create_infobox(paste0(floods_in_a_year, " kejadian"), subtitle, "exclamation-triangle", colors$tertiary)
    }
  })

  output$flood_location_box <- renderUI({
    if (input$selected_city == "DKI Jakarta") {
      city_floods <- climate_data %>%
        filter(City != "DKI Jakarta") %>%
        group_by(City) %>%
        summarise(Total_Floods = sum(Flood_Occurred, na.rm = TRUE)) %>%
        arrange(desc(Total_Floods))

      if (nrow(city_floods) > 0) {
        top_location <- city_floods$City[1]
        percentage <- round((city_floods$Total_Floods[1] / sum(city_floods$Total_Floods)) * 100, 0)
        value_text <- gsub("Jakarta ", "", top_location)
        subtitle <- paste0("Lokasi Terbanyak (", percentage, "%)")
      } else {
        value_text <- "Data Kota"
        subtitle <- "Lokasi Terpilih"
      }
    } else {
      value_text <- "Data Kota"
      subtitle <- "Lokasi Terpilih"
    }
    create_infobox(value_text, subtitle, "map-marker-alt", colors$accent)
  })

  output$flood_trend_plot <- renderPlotly({
    data <- filtered_data()

    if (input$selected_year == "all") {
      plot_data <- data %>%
        group_by(Year) %>%
        summarise(Total_Floods = sum(Flood_Occurred, na.rm = TRUE), .groups = "drop")

      p <- plot_ly(plot_data,
        x = ~Year, y = ~Total_Floods, type = "bar",
        marker = list(color = colors$tertiary)
      )
    } else {
      plot_data <- data %>%
        group_by(Month) %>%
        summarise(Total_Floods = sum(Flood_Occurred, na.rm = TRUE), .groups = "drop") %>%
        mutate(Month_Name = month.abb[Month])

      p <- plot_ly(plot_data,
        x = ~Month_Name, y = ~Total_Floods, type = "bar",
        marker = list(color = colors$tertiary)
      )
    }

    p %>%
      layout(
        title = list(
          text = paste("Tren Frekuensi Banjir -", input$selected_city),
          font = list(family = "Poppins")
        ),
        xaxis = list(
          title = ifelse(input$selected_year == "all", "Tahun", "Bulan"),
          titlefont = list(family = "Poppins")
        ),
        yaxis = list(title = "Kejadian Banjir", titlefont = list(family = "Poppins")),
        font = list(family = "Poppins")
      ) %>%
      config(displayModeBar = FALSE)
  })

  output$flood_interpretation <- renderUI({
    data <- filtered_data()
    total_floods <- sum(data$Flood_Occurred, na.rm = TRUE)

    if (input$selected_year == "all") {
      floods_per_year <- round(total_floods / length(unique(data$Year)), 1)
      interpretation <- paste0("Rata-rata ", floods_per_year, " kejadian per tahun")
    } else {
      interpretation <- paste0("Total ", total_floods, " kejadian pada tahun ", input$selected_year)
    }

    div(
      style = paste0("color: ", colors$tertiary, ";"),
      p(style = "font-weight: 600; margin-bottom: 10px;", "Analisis Banjir:"),
      p(style = "margin-bottom: 8px;", paste0("• ", interpretation)),
      p(style = "margin-bottom: 8px;", "• Korelasi dengan curah hujan tinggi"),
      p(style = "margin-bottom: 8px;", "• Pola musiman terlihat jelas"),
      p(
        style = "margin-bottom: 8px; font-style: italic;",
        ifelse(total_floods > 50, "Frekuensi tinggi, perlu mitigasi",
          ifelse(total_floods > 20, "Frekuensi sedang, monitoring ketat",
            "Frekuensi rendah, kondisi terkendali"
          )
        )
      )
    )
  })

  # ============================================================================
  # ANALYSIS TAB OUTPUTS
  # ============================================================================

  # PIE CHART: RASIO BANJIR VS TIDAK BANJIR
  output$flood_pie_chart <- renderPlotly({
    city <- get_analysis_city_name()
    counts <- get_flood_counts(city)
    labels <- c("Banjir", "Tidak Banjir")
    values <- c(counts$flood, counts$no_flood)
    colors_pie <- c(colors$danger, colors$success)
    plot_ly(
      labels = labels,
      values = values,
      type = "pie",
      marker = list(colors = colors_pie),
      textinfo = "percent",
      insidetextorientation = "radial"
    ) %>%
      layout(
        showlegend = TRUE
      )
  })

  # BOX PLOT: DISTRIBUSI SUHU BANJIR VS NON-BANJIR
  output$flood_temp_boxplot <- renderPlotly({
    data <- analysis_filtered_data()

    # If DKI Jakarta, aggregate average temperature for each date across all sub-cities
    if (input$analysis_city == "DKI Jakarta") {
      # Group by date, take mean temperature and flood status for each day (if any subcity flooded, mark as flood)
      data <- data %>%
        group_by(Year, Month, Day) %>%
        summarise(
          Temperature = mean(Temperature, na.rm = TRUE),
          Flood_Occurred = as.integer(any(Flood_Occurred == 1)),
          .groups = "drop"
        )
    }

    # Prepare data for plotting
    data$Flood_Label <- ifelse(data$Flood_Occurred == 1, "Banjir", "Tidak Banjir")

    p <- plot_ly(
      data = data,
      y = ~Temperature,
      color = ~Flood_Label,
      colors = c("#FF4444", colors$primary),
      type = "box",
      boxpoints = "outliers",
      jitter = 0.3,
      pointpos = 0,
      marker = list(size = 4, opacity = 0.5),
      line = list(width = 2)
    ) %>%
      layout(
        yaxis = list(title = "Suhu Rata-Rata Harian (°C)", titlefont = list(family = "Poppins")),
        xaxis = list(title = "", showticklabels = FALSE),
        boxmode = "group",
        legend = list(title = list(text = "Kondisi")),
        font = list(family = "Poppins")
      )
    p
  })

  # BOX PLOT: DISTRIBUSI CURAH HUJAN BANJIR VS NON-BANJIR
  output$flood_rainfall_boxplot <- renderPlotly({
    data <- analysis_filtered_data()

    # If DKI Jakarta, aggregate average rainfall for each date across all sub-cities
    if (input$analysis_city == "DKI Jakarta") {
      # Group by date, take mean rainfall and flood status for each day (if any subcity flooded, mark as flood)
      data <- data %>%
        group_by(Year, Month, Day) %>%
        summarise(
          Rainfall = mean(Rainfall, na.rm = TRUE),
          Flood_Occurred = as.integer(any(Flood_Occurred == 1)),
          .groups = "drop"
        )
    }

    # Prepare data for plotting
    data$Flood_Label <- ifelse(data$Flood_Occurred == 1, "Banjir", "Tidak Banjir")

    p <- plot_ly(
      data = data,
      y = ~Rainfall,
      color = ~Flood_Label,
      colors = c("#FF4444", colors$primary),
      type = "box",
      boxpoints = "outliers",
      jitter = 0.3,
      pointpos = 0,
      marker = list(size = 4, opacity = 0.5),
      line = list(width = 2)
    ) %>%
      layout(
        yaxis = list(title = "curah hujan Harian (mm)", titlefont = list(family = "Poppins")),
        xaxis = list(title = "", showticklabels = FALSE),
        boxmode = "group",
        legend = list(title = list(text = "Kondisi")),
        font = list(family = "Poppins")
      )
    p
  })

  # SCATTER PLOT: CURAH HUJAN VS SUHU BERDASARKAN KELAS BANJIR
  output$flood_scatter_plot <- renderPlotly({
    data <- analysis_filtered_data()

    # If DKI Jakarta, aggregate mean rainfall and temperature for each date across all sub-cities
    if (input$analysis_city == "DKI Jakarta") {
      data <- data %>%
        group_by(Year, Month, Day) %>%
        summarise(
          Rainfall = mean(Rainfall, na.rm = TRUE),
          Temperature = mean(Temperature, na.rm = TRUE),
          Flood_Occurred = as.integer(any(Flood_Occurred == 1)),
          .groups = "drop"
        )
    }

    data$Flood_Label <- ifelse(data$Flood_Occurred == 1, "Banjir", "Tidak Banjir")

    p <- plot_ly(
      data = data,
      x = ~Rainfall,
      y = ~Temperature,
      color = ~Flood_Label,
      colors = c("#FF4444", colors$primary),
      type = "scatter",
      mode = "markers",
      marker = list(size = 8, opacity = 0.7, line = list(width = 1, color = '#333'))
    ) %>%
      layout(
        xaxis = list(title = "curah hujan Harian (mm)", titlefont = list(family = "Poppins")),
        yaxis = list(title = "Suhu Rata-rata Harian (°C)", titlefont = list(family = "Poppins")),
        legend = list(title = list(text = "Kondisi"), groupclick = "toggleitem"),
        font = list(family = "Poppins"),
        margin = list(l = 60, r = 30, t = 30, b = 60)
      )
    p
  })

  

  # MODEL EXPLANATION & REGRESSION FUNCTION
  output$model_explanation_box <- renderUI({
    city <- get_analysis_city_name()
    model_detail <- get_model_detail(city)
    if (is.null(model_detail)) {
      return(div("Model tidak tersedia untuk wilayah ini."))
    }

    # Format regression equation
    eq <- paste0(
      "logit(P(Banjir)) = ",
      format_number(model_detail$intercept, 3), " + ",
      format_number(model_detail$coef_temp, 3), " × Suhu + ",
      format_number(model_detail$coef_rain, 3), " × Curah Hujan"
    )

    # Interpretation
    interpret <- div(
      style = paste0("color: ", colors$primary, "; margin-top: 10px;"),
      p(
        style = "margin-bottom: 0;",
        paste0(
          "Berdasarkan persamaan regresi yang dihasilkan, setiap kenaikan 1°C suhu rata-rata harian, peluang banjir berubah sebesar ",
          format_number(model_detail$coef_temp, 3), " pada skala logit (dengan curah hujan harian tetap). ",
          "Setiap kenaikan 1 mm curah hujan harian, peluang banjir berubah sebesar ",
          format_number(model_detail$coef_rain, 3), " pada skala logit (dengan suhu rata-rata harian tetap)."
        )
      )
    )

    div(
      div(
        style = paste0("background: ", colors$accent, "; color: ", colors$primary, "; padding: 12px; border-radius: 8px; margin: 10px 0; font-family: monospace; font-size: 16px;"),
        eq
      ),
      interpret
    )
  })

  # CONTOUR PLOT OF LOGISTIC REGRESSION
  output$logistic_contour_plot <- renderPlotly({
    city <- get_analysis_city_name()
    model_detail <- get_model_detail(city)
    if (is.null(model_detail)) {
      return(NULL)
    }

    # Define grid for Temperature and Rainfall
    temp_seq <- seq(24, 32, length.out = 80)
    rain_seq <- seq(0, 80, length.out = 80)
    grid <- expand.grid(Temperature = temp_seq, Rainfall = rain_seq)

    # Calculate probability using logistic regression equation
    logit <- model_detail$intercept + model_detail$coef_temp * grid$Temperature + model_detail$coef_rain * grid$Rainfall
    grid$prob <- 1 / (1 + exp(-logit))

    # Reshape for plotly (fix orientation)
    zmat <- matrix(grid$prob, nrow = length(rain_seq), ncol = length(temp_seq))
    zmat <- t(zmat)

    plot_ly(
      x = temp_seq, y = rain_seq, z = zmat,
      type = "contour",
      colorscale = "YlOrRd",
      contours = list(
        coloring = "heatmap",
        showlabels = TRUE,
        labelfont = list(size = 12, color = "black")
      )
    ) %>%
      layout(
        xaxis = list(title = "Suhu Rata-Rata Harian (°C)", tickfont = list(family = "Poppins")),
        yaxis = list(title = "curah hujan Harian (mm)", tickfont = list(family = "Poppins")),
        font = list(family = "Poppins"),
        margin = list(l = 60, r = 30, t = 60, b = 60)
      )
  })

  # Render confusion matrix as a table (UI)
  output$confusion_matrix_table <- renderUI({
    req(input$analysis_city)
    metrics <- get_model_metrics(input$analysis_city)
    if (is.null(metrics) || any(is.na(metrics[1, c("TP", "TN", "FP", "FN")]))) {
      return(div("Tidak ada data confusion matrix untuk wilayah ini."))
    }

    # Build confusion matrix table (styling handled by CSS)
    matrix_html <- tags$table(
      class = "conf-matrix-table",
      style = "margin: 0 auto",
      tags$tr(
        tags$th(rowspan = 2, colspan = 2, style = "border: none; background: none;"),
        tags$th(colspan = 2, "Actual"),
      ),
      tags$tr(
        tags$th("Flood"),
        tags$th("No Flood"),
      ),
      tags$tr(
        tags$th(rowspan = 2, "Predicted"),
        tags$th("Flood"),
        tags$td(style = paste0("background: ", colors$success), metrics$TP),
        tags$td(style = paste0("background: ", colors$warning), metrics$FP),
      ),
      tags$tr(
        tags$th("No Flood"),
        tags$td(style = paste0("background: ", colors$warning), metrics$FN),
        tags$td(style = paste0("background: ", colors$success), metrics$TN),
      )
    )

    div(
      style = "margin-bottom: 10px; overflow-x: auto",
      matrix_html
    )
  })

  # Render model metrics as infoboxes
  output$model_metrics_boxes <- renderUI({
    req(input$analysis_city)
    metrics <- get_model_metrics(input$analysis_city)
    if (is.null(metrics) || all(is.na(metrics))) {
      return(div("Tidak ada data metrik untuk wilayah ini."))
    }
    # Format metrics for display
    metrics_list <- list(
      column(6, create_infobox(format_number(metrics$accuracy, 3), "Akurasi", "check-circle", colors$success)),
      column(6, create_infobox(format_number(metrics$precision, 3), "Presisi", "bullseye", colors$primary)),
      column(6, create_infobox(format_number(metrics$recall, 3), "Recall", "redo", colors$secondary)),
      column(6, create_infobox(format_number(metrics$specificity, 3), "Spesifisitas", "filter", colors$accent)),
      column(6, create_infobox(format_number(metrics$f1, 3), "F1 Score", "star", colors$tertiary))
    )
    do.call(tagList, metrics_list)
  })


  # ============================================================================
  # PREDICTION TAB OUTPUTS
  # ============================================================================

  # DISPLAY INPUT VALUES PREDIKSI
  output$rainfall_display <- renderText({
    if (is.null(input$rainfall_input) || is.na(input$rainfall_input)) {
      return("0.0 mm")
    }
    paste(format_number(input$rainfall_input, 1), "mm")
  })

  output$temperature_display <- renderText({
    if (is.null(input$temperature_input) || is.na(input$temperature_input)) {
      return("0.0°C")
    }
    paste(format_number(input$temperature_input, 1), "°C")
  })

  # PREDIKSI RISIKO
  observeEvent(input$predict_btn, {
    if (is.null(input$rainfall_input) || is.null(input$temperature_input) ||
      is.na(input$rainfall_input) || is.na(input$temperature_input)) {
      showNotification("Mohon masukkan nilai curah hujan dan suhu yang valid", type = "error")
      return()
    }

    if (!validate_input(input$rainfall_input, 0, 500) ||
      !validate_input(input$temperature_input, 20, 40)) {
      showNotification("Nilai input di luar rentang yang diizinkan", type = "error")
      return()
    }

    tryCatch(
      {
        district_risks <- predict_flood_risk(input$rainfall_input, input$temperature_input)

        values$current_risks <- data.frame(
          District = jakarta_districts$District,
          lat = jakarta_districts$lat,
          lng = jakarta_districts$lng,
          risk_value = district_risks,
          risk_category = sapply(district_risks, get_risk_category),
          risk_color = sapply(district_risks, get_risk_color),
          stringsAsFactors = FALSE
        )

        new_entry <- data.frame(
          timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
          rainfall = input$rainfall_input,
          temperature = input$temperature_input,
          avg_risk = round(mean(district_risks), 3),
          risk_category = get_risk_category(mean(district_risks)),
          stringsAsFactors = FALSE
        )

        values$search_history <- rbind(new_entry, values$search_history)
        if (nrow(values$search_history) > 10) {
          values$search_history <- values$search_history[1:10, ]
        }

        showNotification("Prediksi berhasil dilakukan!", type = "message")
      },
      error = function(e) {
        showNotification(paste("Error dalam prediksi:", e$message), type = "error")
      }
    )
  })

  # DISPLAY RISIKO SAAT INI
  output$current_risk_display <- renderUI({
    if (is.null(values$current_risks)) {
      div(
        style = paste0("color: ", colors$tertiary, "; font-size: 16px;"),
        icon("info-circle", style = "font-size: 48px; margin-bottom: 15px;"),
        br(),
        "Masukkan data cuaca dan klik tombol prediksi untuk melihat tingkat risiko banjir"
      )
    } else {
      avg_risk <- mean(as.numeric(values$current_risks$risk_value))
      risk_category <- get_risk_category(avg_risk)
      risk_color <- get_risk_color(avg_risk)

      div(
        div(
          style = paste0("font-size: 48px; color: ", risk_color, "; margin-bottom: 15px;"),
          icon(ifelse(risk_category == "Tinggi", "exclamation-triangle",
            ifelse(risk_category == "Sedang", "exclamation-circle", "check-circle")
          ))
        ),
        h3(paste0("Risiko ", risk_category),
          style = paste0("color: ", risk_color, "; font-weight: bold; margin-bottom: 10px;")
        ),
        h4(paste0(round(avg_risk * 100, 1), "%"),
          style = paste0("color: ", colors$primary, "; margin-bottom: 15px;")
        ),
        p("Probabilitas rata-rata kejadian banjir di Jakarta",
          style = paste0("color: ", colors$secondary, "; font-size: 14px;")
        )
      )
    }
  })

  # INTERPRETASI RISIKO
  output$risk_interpretation <- renderUI({
    if (is.null(values$current_risks)) {
      return(NULL)
    }

    avg_risk <- mean(values$current_risks$risk_value)
    risk_category <- get_risk_category(avg_risk)

    interpretation <- switch(risk_category,
      "Tinggi" = paste0(
        "Kondisi cuaca saat ini menunjukkan risiko banjir yang TINGGI. ",
        "Curah hujan ", format_number(input$rainfall_input, 1), "mm dan suhu ", format_number(input$temperature_input, 1),
        "°C menciptakan kondisi yang sangat kondusif untuk terjadinya banjir."
      ),
      "Sedang" = paste0(
        "Kondisi cuaca menunjukkan risiko banjir SEDANG. ",
        "Perlu waspada dan monitoring ketat terhadap perkembangan cuaca."
      ),
      "Rendah" = paste0(
        "Kondisi cuaca relatif AMAN. Risiko banjir rendah, ",
        "namun tetap perlu monitoring rutin."
      )
    )

    div(
      style = paste0("background: ", colors$accent, "; padding: 15px; border-radius: 10px; margin-top: 15px;"),
      p(interpretation, style = paste0("color: ", colors$primary, "; font-size: 14px; line-height: 1.6; margin: 0;"))
    )
  })

  # PETA CHOROPLETH
  output$flood_risk_map <- renderLeaflet({
    if (is.null(values$current_risks)) {
      leaflet() %>%
        addTiles() %>%
        setView(lng = 106.8456, lat = -6.2088, zoom = 11) %>%
        addMarkers(
          data = jakarta_districts,
          lng = ~lng, lat = ~lat,
          popup = ~ paste0("<b>", District, "</b><br>Klik 'Prediksi' untuk melihat risiko")
        )
    } else {
      leaflet(values$current_risks) %>%
        addTiles() %>%
        setView(lng = 106.8456, lat = -6.2088, zoom = 11) %>%
        addCircleMarkers(
          lng = ~lng, lat = ~lat,
          radius = ~ 15 + (risk_value * 20),
          color = "white",
          fillColor = ~risk_color,
          fillOpacity = 0.8,
          weight = 2,
          popup = ~ paste0(
            "<b>", District, "</b><br>",
            "Risiko: ", risk_category, "<br>",
            "Probabilitas: ", round(risk_value * 100, 1), "%"
          )
        ) %>%
        addLegend(
          position = "bottomright",
          colors = c("#32CD32", "#FFD700", "#FF4444"),
          labels = c("Risiko Rendah (0-39%)", "Risiko Sedang (40-69%)", "Risiko Tinggi (70-100%)"),
          title = "Tingkat Risiko Banjir"
        )
    }
  })

  # SARAN & REKOMENDASI
  output$recommendations <- renderUI({
    if (is.null(values$current_risks)) {
      div(
        style = paste0("color: ", colors$tertiary, "; text-align: center; padding: 20px;"),
        icon("lightbulb", style = "font-size: 36px; margin-bottom: 15px;"),
        br(),
        "Saran akan muncul setelah prediksi dilakukan"
      )
    } else {
      avg_risk <- mean(values$current_risks$risk_value)
      risk_category <- get_risk_category(avg_risk)

      recommendations <- switch(risk_category,
        "Tinggi" = list(
          title = "TINDAKAN DARURAT",
          color = "#FF4444",
          actions = c(
            "Hindari perjalanan yang tidak perlu",
            "Siapkan tas darurat dan dokumen penting",
            "Pantau informasi cuaca dan peringatan dini",
            "Koordinasi dengan RT/RW setempat",
            "Siapkan jalur evakuasi alternatif",
            "Amankan kendaraan di tempat tinggi"
          )
        ),
        "Sedang" = list(
          title = "WASPADA TINGGI",
          color = "#FFD700",
          actions = c(
            "Pantau perkembangan cuaca secara berkala",
            "Siapkan peralatan darurat (senter, radio)",
            "Periksa sistem drainase di sekitar rumah",
            "Hindari area rawan genangan",
            "Informasikan kondisi ke keluarga",
            "Siaga untuk tindakan lebih lanjut"
          )
        ),
        "Rendah" = list(
          title = "KONDISI NORMAL",
          color = "#32CD32",
          actions = c(
            "Lakukan aktivitas normal dengan hati-hati",
            "Tetap pantau informasi cuaca",
            "Periksa kondisi saluran air secara rutin",
            "Siapkan rencana darurat untuk antisipasi",
            "Edukasi keluarga tentang mitigasi banjir",
            "Laporkan kerusakan infrastruktur jika ada"
          )
        )
      )

      div(
        h4(recommendations$title,
          style = paste0("color: ", recommendations$color, "; font-weight: bold; margin-bottom: 15px; text-align: center;")
        ),
        div(
          style = "text-align: left;",
          lapply(recommendations$actions, function(action) {
            div(
              style = paste0("margin-bottom: 8px; color: ", colors$primary, "; font-size: 13px;"),
              icon("check", style = paste0("color: ", recommendations$color, "; margin-right: 8px;")),
              action
            )
          })
        ),
        div(
          style = paste0("background: ", colors$accent, "; padding: 10px; border-radius: 8px; margin-top: 15px; text-align: center;"),
          p(paste0("Hubungi 112 untuk keadaan darurat"),
            style = paste0("color: ", colors$primary, "; font-weight: bold; margin: 0; font-size: 12px;")
          )
        )
      )
    }
  })

  # HISTORI PENCARIAN
  output$search_history <- renderUI({
    if (nrow(values$search_history) == 0) {
      div(
        style = paste0("text-align: center; color: ", colors$tertiary, "; padding: 30px;"),
        icon("history", style = "font-size: 36px; margin-bottom: 15px;"),
        br(),
        "Belum ada histori pencarian. Lakukan prediksi pertama Anda!"
      )
    } else {
      div(
        h4("Riwayat Prediksi Terakhir", style = paste0("color: ", colors$primary, "; margin-bottom: 20px;")),
        lapply(1:nrow(values$search_history), function(i) {
          entry <- values$search_history[i, ]
          risk_color <- get_risk_color(entry$avg_risk)

          div(
            class = "history-card",
            onclick = paste0("Shiny.setInputValue('history_click', ", i, ", {priority: 'event'});"),
            fluidRow(
              column(
                8,
                div(
                  h5(paste0("🕒 ", entry$timestamp),
                    style = paste0("color: ", colors$primary, "; margin-bottom: 5px; font-weight: 600;")
                  ),
                  p(paste0("🌧️ Curah Hujan: ", format_number(entry$rainfall, 1), " mm | 🌡️ Suhu: ", format_number(entry$temperature, 1), "°C"),
                    style = paste0("color: ", colors$secondary, "; margin-bottom: 5px; font-size: 13px;")
                  ),
                  p(paste0("📊 Risiko Rata-rata: ", round(entry$avg_risk * 100, 1), "%"),
                    style = paste0("color: ", colors$tertiary, "; margin: 0; font-size: 12px;")
                  )
                )
              ),
              column(
                4,
                div(
                  style = "text-align: right; padding-top: 10px;",
                  span(entry$risk_category,
                    class = "risk-indicator",
                    style = paste0("background-color: ", risk_color, ";")
                  )
                )
              )
            )
          )
        })
      )
    }
  })

  # HANDLE HISTORY CLICK
  observeEvent(input$history_click, {
    if (input$history_click > 0 && input$history_click <= nrow(values$search_history)) {
      entry <- values$search_history[input$history_click, ]

      updateNumericInput(session, "rainfall_input", value = entry$rainfall)
      updateNumericInput(session, "temperature_input", value = entry$temperature)

      district_risks <- predict_flood_risk(entry$rainfall, entry$temperature)

      values$current_risks <- data.frame(
        District = jakarta_districts$District,
        lat = jakarta_districts$lat,
        lng = jakarta_districts$lng,
        risk_value = district_risks,
        risk_category = sapply(district_risks, get_risk_category),
        risk_color = sapply(district_risks, get_risk_color),
        stringsAsFactors = FALSE
      )
    }
  })
}
