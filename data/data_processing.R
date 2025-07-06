# Flood Lens - Data Processing (Updated with Excel Data)
# Load and prepare climate data from Excel file

library(readxl)
library(dplyr)

# ============================================================================
# LOAD EXCEL DATA
# ============================================================================

# Load data from Excel file
climate_data <- read_excel(paste(getwd(), "data/data.xlsx", sep = "/"))

# Ensure proper column names and data types
if (!"City" %in% names(climate_data)) {
  # If City column doesn't exist, add it based on your data structure
  # Adjust this based on your actual Excel structure
  climate_data$City <- "DKI Jakarta" # or map from other columns
}

# Ensure required columns exist
required_columns <- c("Year", "Month", "Day", "City", "Rainfall", "Temperature", "Extreme_Rain_Day", "Flood_Occurred")
missing_columns <- setdiff(required_columns, names(climate_data))

if (length(missing_columns) > 0) {
  cat("Warning: Missing columns:", paste(missing_columns, collapse = ", "), "\n")

  # Create missing columns with default values if needed
  if ("Extreme_Rain_Day" %in% missing_columns) {
    climate_data$Extreme_Rain_Day <- ifelse(climate_data$Rainfall > 5, 1, 0)
  }

  if ("Flood_Occurred" %in% missing_columns) {
    # Simple flood prediction based on rainfall
    climate_data$Flood_Occurred <- ifelse(climate_data$Rainfall > 20, 1, 0)
  }
}

# ============================================================================
# JAKARTA DISTRICTS DATA FOR MAPPING
# ============================================================================

jakarta_districts <- data.frame(
  District = c("Jakarta Pusat", "Jakarta Utara", "Jakarta Barat", "Jakarta Selatan", "Jakarta Timur"),
  lat = c(-6.1805, -6.1388, -6.1664, -6.2615, -6.2146),
  lng = c(106.8284, 106.8650, 106.7593, 106.8106, 106.8998),
  stringsAsFactors = FALSE
)

# ============================================================================
# DATA VALIDATION AND SUMMARY
# ============================================================================

# Print data summary
# cat("\n=== JAKARTA CLIMATE DATA LOADED ===\n")
# cat("Total records:", nrow(climate_data), "\n")
# cat("Date range:", min(climate_data$Year), "-", max(climate_data$Year), "\n")
# cat("Cities:", length(unique(climate_data$City)), "\n")
# cat("Total flood events:", sum(climate_data$Flood_Occurred, na.rm = TRUE), "\n")

# Summary by city
# if (length(unique(climate_data$City)) > 1) {
#   city_summary <- climate_data %>%
#     group_by(City) %>%
#     summarise(
#       Records = n(),
#       Avg_Rainfall = round(mean(Rainfall, na.rm = TRUE), 1),
#       Avg_Temperature = round(mean(Temperature, na.rm = TRUE), 1),
#       Total_Floods = sum(Flood_Occurred, na.rm = TRUE),
#       .groups = "drop"
#     )

#   print(city_summary)
# }

# cat("\n=== DATA READY FOR ANALYSIS ===\n\n")
