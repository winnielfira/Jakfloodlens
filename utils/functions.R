# Flood Lens - Utility Functions (Updated)

# Color palette
colors <- list(
  primary = "#001F3F", # Navy blue
  secondary = "#3A6D8C", # Medium blue
  tertiary = "#6A9AB0", # Light blue
  accent = "#EAD8B1", # Cream/beige
  success = "#28a745", # Green
  warning = "#ffc107", # Yellow
  danger = "#dc3545", # Red
  light = "#f8f9fa", # Light gray
  white = "#ffffff"
)

# impor data
data <- read_excel(paste(getwd(), "data/data.xlsx", sep = "/"))

# Hitung jumlah hari banjir dan tidak banjir untuk setiap kota di luar fungsi
flood_counts_list <- lapply(unique(data$City), function(city) {
  city_data <- filter(data, City == city)
  flood_days <- sum(city_data$Flood_Occurred == 1, na.rm = TRUE)
  no_flood_days <- sum(city_data$Flood_Occurred == 0, na.rm = TRUE)
  list(flood = flood_days, no_flood = no_flood_days)
})
names(flood_counts_list) <- unique(data$City)

# Tambahkan DKI Jakarta (flood day: jika minimal satu kota banjir di hari itu, berdasarkan Year, Month, Day)
dki_flood_by_day <- aggregate(Flood_Occurred ~ Year + Month + Day, data = data, FUN = function(x) any(x == 1, na.rm = TRUE))
dki_flood_days <- sum(dki_flood_by_day$Flood_Occurred == TRUE, na.rm = TRUE)
dki_no_flood_days <- sum(dki_flood_by_day$Flood_Occurred == FALSE, na.rm = TRUE)
flood_counts_list[["DKI Jakarta"]] <- list(
  flood = dki_flood_days,
  no_flood = dki_no_flood_days
)

# FUNGSI MENGAMBIL JUMLAH HARI BANJIR DAN TIDAK BANJIR UNTUK KOTA TERTENTU
get_flood_counts <- function(City) {
  if (!City %in% names(flood_counts_list)) {
    return(list(flood = NA, no_flood = NA))
  }
  return(flood_counts_list[[City]])
}

# buat model regresi logistik untuk masing-masing distrik
jakarta_utara_model <- glm(Flood_Occurred ~ Temperature + Rainfall, data = filter(data, City == "Jakarta Utara"), family = binomial)
jakarta_barat_model <- glm(Flood_Occurred ~ Temperature + Rainfall, data = filter(data, City == "Jakarta Barat"), family = binomial)
jakarta_pusat_model <- glm(Flood_Occurred ~ Temperature + Rainfall, data = filter(data, City == "Jakarta Pusat"), family = binomial)
jakarta_timur_model <- glm(Flood_Occurred ~ Temperature + Rainfall, data = filter(data, City == "Jakarta Timur"), family = binomial)
jakarta_selatan_model <- glm(Flood_Occurred ~ Temperature + Rainfall, data = filter(data, City == "Jakarta Selatan"), family = binomial)


# Buat data agregat harian untuk DKI Jakarta:
dki_jakarta_daily <- data %>%
  group_by(Year, Month, Day) %>%
  summarise(
    Temperature = mean(Temperature, na.rm = TRUE),
    Rainfall = mean(Rainfall, na.rm = TRUE),
    Flood_Occurred = as.integer(any(Flood_Occurred == 1)),
    .groups = "drop"
  )

# Model untuk DKI Jakarta (menggunakan data agregat harian)
dki_jakarta_model <- glm(Flood_Occurred ~ Temperature + Rainfall, data = dki_jakarta_daily, family = binomial)

# FUNGSI MENGAMBIL DETAIL MODEL REGRESI UNTUK WILAYAH TERTENTU
get_model_detail <- function(City) {
  model <- switch(City,
    "Jakarta Pusat" = jakarta_pusat_model,
    "Jakarta Utara" = jakarta_utara_model,
    "Jakarta Barat" = jakarta_barat_model,
    "Jakarta Timur" = jakarta_timur_model,
    "Jakarta Selatan" = jakarta_selatan_model,
    "DKI Jakarta" = dki_jakarta_model,
  )

  cf <- coef(model)
  return(list(
    intercept = unname(cf[1]),
    coef_temp = unname(cf["Temperature"]),
    coef_rain = unname(cf["Rainfall"])
  ))
}

# FUNGSI MENGHITUNG AKURASI MODEL LOGISTIK UNTUK KOTA TERTENTU
calculate_model_metrics <- function(City) {
  # Filter data untuk kota yang dipilih
  model <- switch(City,
    "Jakarta Utara" = jakarta_utara_model,
    "Jakarta Barat" = jakarta_barat_model,
    "Jakarta Pusat" = jakarta_pusat_model,
    "Jakarta Timur" = jakarta_timur_model,
    "Jakarta Selatan" = jakarta_selatan_model,
    "DKI Jakarta" = dki_jakarta_model,
  )

  if (City == "DKI Jakarta") {
    city_data <- dki_jakarta_daily
  } else {
    city_data <- filter(data, City == !!City)
  }

  # Prediksi probabilitas dan konversi ke kelas (threshold 0.5)
  probs <- predict(model, newdata = city_data, type = "response")
  preds <- ifelse(probs >= 0.5, 1, 0)
  actuals <- city_data$Flood_Occurred

  # Confusion matrix components
  TP <- sum(preds == 1 & actuals == 1, na.rm = TRUE)
  TN <- sum(preds == 0 & actuals == 0, na.rm = TRUE)
  FP <- sum(preds == 1 & actuals == 0, na.rm = TRUE)
  FN <- sum(preds == 0 & actuals == 1, na.rm = TRUE)

  # Metrics
  accuracy <- (TP + TN) / (TP + TN + FP + FN)
  precision <- ifelse((TP + FP) == 0, NA, TP / (TP + FP))
  recall <- ifelse((TP + FN) == 0, NA, TP / (TP + FN))
  specificity <- ifelse((TN + FP) == 0, NA, TN / (TN + FP))
  f1 <- ifelse(is.na(precision) | is.na(recall) | (precision + recall) == 0, NA, 2 * precision * recall / (precision + recall))

  return(data.frame(TP = TP, TN = TN, FP = FP, FN = FN, accuracy = accuracy, precision = precision, recall = recall, specificity = specificity, f1 = f1))
}

# Calculate metrics for each city and bind as rows for easier averaging
model_metrics <- rbind(
  calculate_model_metrics("Jakarta Pusat"),
  calculate_model_metrics("Jakarta Utara"),
  calculate_model_metrics("Jakarta Barat"),
  calculate_model_metrics("Jakarta Timur"),
  calculate_model_metrics("Jakarta Selatan"),
  calculate_model_metrics("DKI Jakarta")
)
rownames(model_metrics) <- c("Jakarta Pusat", "Jakarta Utara", "Jakarta Barat", "Jakarta Timur", "Jakarta Selatan", "DKI Jakarta")

get_model_metrics <- function(City) {
  model_metrics[City, , drop = FALSE]
}

# FUNGSI PREDIKSI RISIKO BANJIR - Updated for DKI Jakarta
predict_flood_risk <- function(rainfall, temperature) {
  # Validate inputs
  if (is.null(rainfall) || is.null(temperature) || is.na(rainfall) || is.na(temperature)) {
    return(rep(0.1, 5)) # Default low risk for all districts
  }

  new_data <- data.frame(Temperature = temperature, Rainfall = rainfall)

  # lakukan prediksi, urutan dalam vector output: pusat, utara, barat, selatan, timur
  district_risks <- c(
    predict(jakarta_pusat_model, newdata = new_data, type = "response"),
    predict(jakarta_utara_model, newdata = new_data, type = "response"),
    predict(jakarta_barat_model, newdata = new_data, type = "response"),
    predict(jakarta_selatan_model, newdata = new_data, type = "response"),
    predict(jakarta_timur_model, newdata = new_data, type = "response")
  )

  return(district_risks)
}

# FUNGSI KATEGORI RISIKO
get_risk_category <- function(risk_value) {
  if (is.null(risk_value) || is.na(risk_value)) {
    return("Rendah")
  }
  if (risk_value >= 0.7) {
    return("Tinggi")
  } else if (risk_value >= 0.4) {
    return("Sedang")
  } else {
    return("Rendah")
  }
}

# FUNGSI WARNA RISIKO
get_risk_color <- function(risk_value) {
  if (is.null(risk_value) || is.na(risk_value)) {
    return("#32CD32")
  }
  if (risk_value >= 0.7) {
    return("#FF4444")
  } # Merah
  else if (risk_value >= 0.4) {
    return("#FFD700")
  } # Kuning
  else {
    return("#32CD32")
  } # Hijau
}

# HELPER FUNCTION UNTUK INFOBOX - Updated untuk konsistensi
create_infobox <- function(value, subtitle, icon_name, color) {
  # Determine icon background color based on the color parameter
  icon_bg_color <- switch(color,
    "#001F3F" = "#001F3F", # Navy blue
    "#3A6D8C" = "#3A6D8C", # Orange for secondary
    "#6A9AB0" = "#6A9AB0", # Cyan for tertiary
    "#EAD8B1" = "#EAD8B1", # Green for accent
    color # Default to provided color
  )

  div(
    style = paste0("background: white; border-left: 4px solid ", icon_bg_color, ";
                   border-radius: 15px; padding: 20px; box-shadow: 0 4px 15px rgba(0,31,63,0.1);
                   text-align: center; margin-bottom: 20px; position: relative; overflow: hidden;"),

    # Icon section with background
    div(
      style = paste0("background: ", icon_bg_color, "; color: white;
                       width: 50px; height: 50px; border-radius: 50%;
                       display: flex; align-items: center; justify-content: center;
                       margin: 0 auto 15px auto; font-size: 20px;"),
      icon(icon_name)
    ),

    # Value
    div(
      style = "color: #001F3F; font-size: 24px; font-weight: bold; margin-bottom: 5px;",
      value
    ),

    # Subtitle
    div(
      style = "color: #3A6D8C; font-size: 12px; font-weight: 500;",
      subtitle
    )
  )
}

create_info_banner <- function(message) {
  div(
    style = paste0("background: ", colors$accent, "; color: ", colors$primary, "; padding: 12px; border-radius: 8px; margin-top: 10px; margin-bottom: 20px; display: flex; gap: 12px; font-size: 15px;"),
    icon("info-circle", style = "margin-top: 4px;"),
    span(
      message,
      style = "font-weight: 400; line-height: 1.5;"
    )
  )
}

# HELPER FUNCTION UNTUK FORMAT ANGKA
format_number <- function(x, digits = 1) {
  if (is.null(x) || is.na(x)) {
    return("0")
  }
  return(format(round(x, digits), nsmall = digits))
}

# HELPER FUNCTION UNTUK VALIDASI INPUT
validate_input <- function(value, min_val, max_val) {
  if (is.null(value) || is.na(value)) {
    return(FALSE)
  }
  return(value >= min_val && value <= max_val)
}
