# Flood Lens - Dashboard UI (Improved with consistent styling)

dashboard_ui <- dashboardPage(
  skin = "blue",

  # HEADER
  dashboardHeader(
    title = div(
      style = "font-family: 'Poppins', sans-serif; font-weight: 700; color: white; font-size: 18px;",
      "Jakfloodlens"
    ),
    titleWidth = 300
  ),

  # SIDEBAR
  dashboardSidebar(
    width = 300,

    # Load Poppins font dan custom CSS
    tags$head(
      tags$link(href = "https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap", rel = "stylesheet"),
      tags$style(HTML(paste0("

      /* ===== RESET & BASE STYLES ===== */
      * {
        box-sizing: border-box;
      }

      body, .box-title, h1, h2, h3, h4, h5, h6, p, .sidebar-menu a {
        font-family: 'Poppins', sans-serif !important;
      }

      /* ===== HEADER STYLING ===== */
      .main-header .navbar {
        background: linear-gradient(135deg, ", colors$primary, " 0%, ", colors$secondary, " 100%) !important;
        border-bottom: none !important;
        box-shadow: 0 2px 10px rgba(0,31,63,0.15) !important;
      }

      .main-header .logo {
        background: linear-gradient(135deg, ", colors$secondary, " 0%, ", colors$primary, " 100%) !important;
        font-family: 'Poppins', sans-serif !important;
        border-bottom: none !important;
        transition: all 0.3s ease !important;
      }

      .main-header .logo:hover {
        background: linear-gradient(135deg, ", colors$primary, " 0%, ", colors$secondary, " 100%) !important;
      }

      /* ===== SIDEBAR STYLING ===== */
      .main-sidebar {
        background: linear-gradient(180deg, ", colors$tertiary, " 0%, ", colors$secondary, " 100%) !important;
        box-shadow: 2px 0 10px rgba(0,31,63,0.1) !important;
      }

      .sidebar-menu > li > a {
        color: white !important;
        padding: 15px 20px !important;
        font-weight: 500 !important;
        font-size: 14px !important;
        transition: all 0.3s ease !important;
        border-left: 4px solid transparent !important;
      }

      .sidebar-menu > li > a:hover {
        background: rgba(255,255,255,0.1) !important;
        border-left: 4px solid ", colors$accent, " !important;
        transform: translateX(5px) !important;
      }

      .sidebar-menu > li.active > a {
        background: linear-gradient(135deg, ", colors$primary, " 0%, rgba(255,255,255,0.1) 100%) !important;
        border-left: 4px solid ", colors$accent, " !important;
        font-weight: 600 !important;
        box-shadow: inset 0 0 20px rgba(0,0,0,0.1) !important;
      }

      .sidebar-menu li > a > .fa {
        margin-right: 12px !important;
        font-size: 16px !important;
      }

      /* ===== CONTENT AREA ===== */
      .content-wrapper {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%) !important;
        min-height: 100vh !important;
      }

      .content {
        padding: 20px !important;
      }

      /* ===== CONSISTENT SPACING ===== */
      .row {
        margin-left: -10px !important;
        margin-right: -10px !important;
      }

      .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,
      .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
        padding-left: 10px !important;
        padding-right: 10px !important;
      }

      /* ===== CONFUSION MATRIX IMAGE FIT ===== */
      #confusion_matrix_img img {
        object-fit: contain !important;
      }

      /* ===== BOX STYLING ===== */
      .box {
        border: none !important;
        border-radius: 15px !important;
        box-shadow: 0 4px 25px rgba(0,31,63,0.08) !important;
        margin-bottom: 20px !important;
        overflow: hidden !important;
        transition: all 0.3s ease !important;
        background: ", colors$white, " !important;
      }

      .box:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 8px 35px rgba(0,31,63,0.12) !important;
      }

      .box-header {
        background: linear-gradient(135deg, ", colors$primary, " 0%, ", colors$secondary, " 100%) !important;
        color: white !important;
        padding: 20px 25px !important;
        border-bottom: none !important;
      }

      .box-title {
        font-size: 18px !important;
        font-weight: 600 !important;
        margin: 0 !important;
      }

      .box-body {
        padding: 25px !important;
      }

      /* ===== SECTION HEADERS ===== */
      .section-header {
        background: linear-gradient(135deg, ", colors$primary, " 0%, ", colors$secondary, " 100%) !important;
        color: white !important;
        padding: 15px 25px !important;
        text-align: center !important;
        border-radius: 15px !important;
        margin: 20px 0 20px 0 !important;
        box-shadow: 0 4px 15px rgba(0,31,63,0.1) !important;
      }

      .section-header h2 {
        margin: 0 !important;
        font-size: 24px !important;
        font-weight: 600 !important;
        color: white !important;
      }

      /* ===== MEMBER CARDS ===== */
      .member-card-new {
        background: ", colors$white, " !important;
        border-radius: 20px !important;
        padding: 20px !important;
        text-align: center !important;
        box-shadow: 0 8px 30px rgba(0,31,63,0.1) !important;
        border: 2px solid ", colors$accent, " !important;
        margin-bottom: 30px !important;
        transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94) !important;
        position: relative !important;
        overflow: hidden !important;
      }

      .member-card-new::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
        transition: left 0.5s ease;
      }

      .member-card-new:hover {
        transform: translateY(-8px) scale(1.02) !important;
        box-shadow: 0 15px 40px rgba(0,31,63,0.2) !important;
        border-color: ", colors$secondary, " !important;
      }

      .member-card-new:hover::before {
        left: 100%;
      }

      .photo-container {
        width: 100% !important;
        margin-bottom: 15px !important;
        position: relative !important;
        overflow: hidden !important;
        border-radius: 15px !important;
      }

      .member-photo {
        transition: all 0.3s ease !important;
        display: block !important;
      }

      .member-card-new:hover .member-photo {
        transform: scale(1.05) !important;
      }


      .custom-footer {
        background: linear-gradient(135deg, ", colors$secondary, " 0%, ", colors$primary, " 100%) !important;
        color: white !important;
        padding: 40px 20px 40px 20px !important;
        text-align: left !important;
        border-radius: 20px !important;
        margin-top: 20px !important;
        box-shadow: 0 -5px 25px rgba(0,31,63,0.15) !important;
      }

      /* ===== HISTORY CARDS ===== */
      .history-card {
        background: ", colors$white, " !important;
        border-radius: 12px !important;
        padding: 20px !important;
        margin-bottom: 15px !important;
        border-left: 4px solid ", colors$primary, " !important;
        box-shadow: 0 3px 15px rgba(0,31,63,0.08) !important;
        cursor: pointer !important;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94) !important;
        position: relative !important;
        overflow: hidden !important;
      }

      .history-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 0;
        height: 100%;
        background: linear-gradient(90deg, ", colors$accent, ", transparent);
        transition: width 0.3s ease;
        z-index: 1;
      }

      .history-card:hover {
        transform: translateX(8px) !important;
        box-shadow: 0 8px 25px rgba(0,31,63,0.15) !important;
        border-left-color: ", colors$secondary, " !important;
      }

      .history-card:hover::before {
        width: 100%;
      }

      .history-card > * {
        position: relative;
        z-index: 2;
      }

      /* ===== RISK INDICATORS ===== */
      .risk-indicator {
        display: inline-block !important;
        padding: 8px 16px !important;
        border-radius: 25px !important;
        font-weight: 600 !important;
        font-size: 11px !important;
        color: white !important;
        margin-left: 10px !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
        box-shadow: 0 3px 10px rgba(0,0,0,0.2) !important;
        transition: all 0.3s ease !important;
      }

      .risk-indicator:hover {
        transform: scale(1.05) !important;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3) !important;
      }

      /* ===== FORM CONTROLS ===== */
      .form-control, .selectize-input {
        border: 2px solid #e9ecef !important;
        border-radius: 10px !important;
        padding: 12px 15px !important;
        font-size: 14px !important;
        transition: all 0.3s ease !important;
        background: ", colors$white, " !important;
      }

      .form-control:focus, .selectize-input.focus {
        border-color: ", colors$primary, " !important;
        box-shadow: 0 0 0 3px rgba(0,31,63,0.1) !important;
        outline: none !important;
      }

      /* ===== BUTTONS ===== */
      .btn {
        border-radius: 10px !important;
        padding: 12px 25px !important;
        font-weight: 600 !important;
        font-size: 14px !important;
        transition: all 0.3s ease !important;
        border: none !important;
        cursor: pointer !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
      }

      .btn:hover {
        transform: translateY(-2px) !important;
        box-shadow: 0 8px 20px rgba(0,0,0,0.2) !important;
      }

      .btn:active {
        transform: translateY(0) !important;
      }

      /* ===== SLIDERS ===== */
      .irs-bar {
        background: linear-gradient(to right, ", colors$primary, " 0%, ", colors$secondary, " 100%) !important;
        border-radius: 5px !important;
        height: 8px !important;
      }

      .irs-handle {
        background: ", colors$primary, " !important;
        border: 3px solid white !important;
        box-shadow: 0 3px 10px rgba(0,31,63,0.3) !important;
        border-radius: 50% !important;
        width: 20px !important;
        height: 20px !important;
        cursor: pointer !important;
        transition: all 0.3s ease !important;
      }

      .irs-handle:hover {
        transform: scale(1.2) !important;
        box-shadow: 0 5px 15px rgba(0,31,63,0.4) !important;
      }

      .irs-line {
        background: #e9ecef !important;
        border-radius: 5px !important;
        height: 8px !important;
      }

      /* ===== DATA TABLES ===== */
      .dataTables_wrapper {
        font-family: 'Poppins', sans-serif !important;
      }

      table.dataTable thead th {
        background: linear-gradient(135deg, ", colors$primary, " 0%, ", colors$secondary, " 100%) !important;
        color: white !important;
        border: none !important;
        padding: 15px !important;
        font-weight: 600 !important;
      }

      table.dataTable tbody tr {
        transition: all 0.3s ease !important;
      }

      table.dataTable tbody tr:hover {
        background: ", colors$accent, " !important;
        transform: scale(1.01) !important;
      }

      /* ===== CONFUSION MATRIX TABLE STYLING ===== */
      .conf-matrix-table th {
        border: 2px solid ", colors$primary, ";
        padding: 8px 18px;
        background: ", colors$accent, ";
        text-align: center
      }
      .conf-matrix-table td {
        border: 2px solid ", colors$primary, ";
        padding: 12px 24px;
        font-weight: bold;
        text-align: right;
      }

      /* ===== SECTION TITLES ===== */
      .section-title {
        color: ", colors$primary, " !important;
        font-weight: bold !important;
        margin: 40px 0 20px 0 !important;
      }

      /* ===== PLOTLY STYLING ===== */
      .plotly .modebar {
        display: none !important;
      }

      /* ===== LEAFLET MAP STYLING ===== */
      .leaflet-container {
        border-radius: 15px !important;
        box-shadow: 0 4px 20px rgba(0,31,63,0.1) !important;
      }

      /* ===== RESPONSIVE DESIGN ===== */
      @media (max-width: 768px) {
        .custom-header {
          padding: 30px 20px !important;
        }

        .custom-header h1 {
          font-size: 24px !important;
        }

        .member-card-new {
          padding: 20px 15px !important;
        }

        .box-body {
          padding: 15px !important;
        }

        .content {
          padding: 10px !important;
        }
      }

      p, .text-content, .description, .interpretation {
        color: ", colors$primary, " !important;
      }

      .box-body p {
        color: ", colors$primary, " !important;
      }

      .member-card p, .member-card-new p {
        color: ", colors$primary, " !important;
      }

      ul li, ol li {
        color: ", colors$primary, " !important;
      }

      .custom-footer p, .custom-footer div {
        color: white !important;
      }

      @media (max-width: 768px) {
      .section-header {
        padding: 20px 15px !important;
      }

      .section-header h1 {
        font-size: 24px !important;
      }

      .section-header h4 {
        font-size: 16px !important;
      }
      ")))
    ),
    sidebarMenu(
      id = "tabs",
      menuItem("Beranda", tabName = "beranda", icon = icon("home"), selected = TRUE),
      menuItem("Ringkasan Iklim", tabName = "overview", icon = icon("chart-bar")),
      menuItem("Metode Analisis", tabName = "analysis", icon = icon("microscope")),
      menuItem("Prediksi Real-time", tabName = "prediction", icon = icon("bullseye"))
    )
  ),



  # BODY
  dashboardBody(
    tabItems(
      # NAVBAR BERANDA
      tabItem(
        tabName = "beranda",

        # CUSTOM HEADER
        div(
          class = "section-header",
          h1("Jakfloodlens Dashboard",
            style = "font-weight: bold; margin-bottom: 10px; font-size: 32px;"
          ),
          h4("Sistem Analisis dan Prediksi Dampak Perubahan Iklim terhadap Banjir Jakarta",
            style = "font-weight: 300; opacity: 0.9; margin: 0;"
          )
        ),

        # DESKRIPSI DASHBOARD
        fluidRow(
          column(
            12,
            box(
              width = NULL, status = "primary", solidHeader = TRUE,
              title = "Tentang Dashboard Ini",
              div(
                style = "font-size: 16px; line-height: 1.8; text-align: justify;",
                p(
                  style = paste0("color: ", colors$primary, "; font-weight: 400;"),
                  "Dashboard ini merupakan sistem komprehensif untuk menganalisis hubungan antara variabel iklim
                (curah hujan dan suhu) dengan kejadian banjir di Jakarta. Menggunakan data historis dari tahun
                2020-2024, dashboard ini menyediakan insight mendalam tentang pola iklim dan dampaknya terhadap
                risiko banjir di berbagai wilayah Jakarta."
                ),
                p(
                  style = paste0("color: ", colors$secondary, "; font-weight: 400;"),
                  "Dengan menerapkan metode analisis statistik, dashboard ini membantu dalam
                pemahaman karakteristik iklim Jakarta, identifikasi pola musiman, serta prediksi kejadian banjir
                berdasarkan kondisi cuaca terkini. Sistem ini dirancang untuk mendukung pengambilan keputusan
                dalam mitigasi risiko banjir dan perencanaan adaptasi perubahan iklim."
                ),
                div(
                  style = paste0("background-color: ", colors$accent, "; padding: 15px; border-radius: 8px; margin-top: 20px;"),
                  h5(
                    style = paste0("color: ", colors$primary, "; margin-bottom: 10px; font-weight: 600;"),
                    "Tujuan Utama Dashboard:"
                  ),
                  tags$ul(
                    style = paste0(
                      "color: ", colors$secondary, ";",
                      " list-style-position: inside;",
                      " padding-left: 0.5em;",
                      " margin-left: 5px;"
                    ),
                    tags$li("Menganalisis hubungan antara curah hujan, suhu, dan kejadian banjir"),
                    tags$li("Menyediakan visualisasi data iklim yang mudah dipahami"),
                    tags$li("Memberikan prediksi risiko banjir secara real-time"),
                    tags$li("Mendukung perencanaan mitigasi bencana berbasis data")
                  )
                )
              )
            )
          )
        ),

        # USER GUIDE SECTION
        fluidRow(
          column(
            12,
            box(
              width = NULL, status = "info", solidHeader = TRUE,
              title = "Panduan Penggunaan Dashboard",
              div(
                style = "font-size: 15px; line-height: 1.7;",

                # Step 1
                div(
                  style = paste0("background: ", colors$accent, "; padding: 20px; border-radius: 12px; margin-bottom: 20px; border-left: 5px solid ", colors$primary, ";"),
                  h4("1. Beranda", style = paste0("color: ", colors$primary, "; margin-bottom: 10px; font-weight: 600;")),
                  p("Halaman utama yang menampilkan informasi umum tentang dashboard dan tim penyusun.",
                    style = paste0("color: ", colors$primary, "; margin: 0;")
                  )
                ),

                # Step 2
                div(
                  style = paste0("background: ", colors$light, "; padding: 20px; border-radius: 12px; margin-bottom: 20px; border-left: 5px solid ", colors$secondary, ";"),
                  h4("2. Ringkasan Iklim", style = paste0("color: ", colors$secondary, "; margin-bottom: 10px; font-weight: 600;")),
                  p("Lihat statistik lengkap curah hujan, suhu, dan frekuensi banjir. Gunakan filter wilayah dan tahun untuk analisis spesifik.",
                    style = paste0("color: ", colors$primary, "; margin: 0;")
                  )
                ),

                # Step 3
                div(
                  style = paste0("background: ", colors$accent, "; padding: 20px; border-radius: 12px; margin-bottom: 20px; border-left: 5px solid ", colors$primary, ";"),
                  h4("3. Metode Analisis", style = paste0("color: ", colors$primary, "; margin-bottom: 10px; font-weight: 600;")),
                  p("Penjelasan mengenai metode yang digunakan dalam memperkirakan peluang banjir berdasarkan curah hujan dan suhu.",
                    style = paste0("color: ", colors$primary, "; margin: 0;")
                  )
                ),

                # Step 4
                div(
                  style = paste0("background: ", colors$light, "; padding: 20px; border-radius: 12px; margin-bottom: 20px; border-left: 5px solid ", colors$secondary, ";"),
                  h4("4. Prediksi Real-time", style = paste0("color: ", colors$secondary, "; margin-bottom: 10px; font-weight: 600;")),
                  p("Masukkan data cuaca terkini untuk mendapatkan prediksi risiko banjir di seluruh wilayah Jakarta beserta rekomendasi tindakan.",
                    style = paste0("color: ", colors$primary, "; margin: 0;")
                  )
                )
              )
            )
          )
        ),


        # CUSTOM FOOTER
        div(
          class = "custom-footer",
          fluidRow(
            column(
              4,
              h4("Jakfloodlens", style = "font-weight: bold; margin-bottom: 15px;"),
              p("Sistem analisis dan prediksi dampak perubahan iklim terhadap kejadian banjir di Jakarta.",
                style = "font-size: 14px; line-height: 1.6; opacity: 0.9;"
              )
            ),
            column(
              4,
              h5("Fitur Utama", style = "font-weight: 600; margin-bottom: 15px;"),
              div(
                style = "font-size: 13px; line-height: 1.8; opacity: 0.9;",
                "• Analisis Statistik Komprehensif", br(),
                "• Visualisasi Data Interaktif", br(),
                "• Prediksi Real-time", br(),
                "• Pemetaan Risiko Banjir"
              )
            ),
            column(
              4,
              h5("Data & Metode", style = "font-weight: 600; margin-bottom: 15px;"),
              div(
                style = "font-size: 13px; line-height: 1.8; opacity: 0.9;",
                "• Data GEE dan BNPB (2020-2024)", br(),
                "• Visualisasi Data", br(),
                "• Model Klasifikasi"
              )
            )
          ),
          hr(style = "border-color: rgba(255,255,255,0.3); margin: 25px 0 15px 0;"),
          p("© 2025 Jakfloodlens | Developed for Climate Change Analysis",
            style = "text-align: center; font-size: 12px; opacity: 0.8; margin: 0;"
          )
        )
      ),

      # NAVBAR RINGKASAN IKLIM
      tabItem(
        tabName = "overview",

        # HEADER SECTION
        div(
          class = "section-header",
          h1("Ringkasan Iklim Jakarta", style = "font-weight: bold; margin-bottom: 10px; font-size: 32px;"),
          h4("Statistik Komprehensif Curah Hujan, Suhu, dan Frekuensi Banjir",
            style = "font-weight: 300; opacity: 0.9; margin: 0;"
          )
        ),

        # FILTER SECTION
        fluidRow(
          column(
            6,
            selectInput("selected_city",
              label = h4("Pilih Wilayah:", style = paste0("color: ", colors$primary, "; font-weight: 600;")),
              choices = c("DKI Jakarta", "Jakarta Pusat", "Jakarta Utara", "Jakarta Barat", "Jakarta Selatan", "Jakarta Timur"),
              selected = "DKI Jakarta",
              width = "100%"
            )
          ),
          column(
            6,
            selectInput("selected_year",
              label = h4("Pilih Tahun:", style = paste0("color: ", colors$primary, "; font-weight: 600;")),
              choices = c("Semua Tahun (2020-2024)" = "all", as.character(2020:2024)),
              selected = "all",
              width = "100%"
            )
          )
        ),

        # 1. STATISTIK CURAH HUJAN
        div(
          class = "section-header",
          h2("Statistik Curah Hujan")
        ),
        fluidRow(
          column(3, uiOutput("rainfall_avg_box")),
          column(3, uiOutput("rainfall_max_box")),
          column(3, uiOutput("extreme_days_box")),
          column(3, uiOutput("rainfall_trend_box"))
        ),
        fluidRow(
          column(
            8,
            box(
              width = NULL, status = "primary", solidHeader = TRUE,
              title = "Tren Curah Hujan",
              plotlyOutput("rainfall_trend_plot", height = "350px")
            )
          ),
          column(
            4,
            box(
              width = NULL, status = "info", solidHeader = TRUE,
              title = "Interpretasi Curah Hujan",
              div(
                style = "font-size: 14px; line-height: 1.6;",
                uiOutput("rainfall_interpretation")
              )
            )
          )
        ),

        # 2. STATISTIK SUHU
        div(
          class = "section-header",
          h2("Statistik Suhu Rata-rata Harian")
        ),
        fluidRow(
          column(3, uiOutput("temp_avg_box")),
          column(3, uiOutput("temp_min_box")),
          column(3, uiOutput("temp_max_box")),
          column(3, uiOutput("temp_variation_box"))
        ),
        fluidRow(
          column(
            8,
            box(
              width = NULL, status = "warning", solidHeader = TRUE,
              title = "Tren Suhu",
              plotlyOutput("temperature_trend_plot", height = "350px")
            )
          ),
          column(
            4,
            box(
              width = NULL, status = "info", solidHeader = TRUE,
              title = "Interpretasi Suhu",
              div(
                style = "font-size: 14px; line-height: 1.6;",
                uiOutput("temperature_interpretation")
              )
            )
          )
        ),

        # 3. STATISTIK FREKUENSI BANJIR
        div(
          class = "section-header",
          h2("Statistik Frekuensi Banjir")
        ),
        fluidRow(
          column(6, uiOutput("flood_per_year_box")),
          column(6, uiOutput("flood_location_box"))
        ),
        fluidRow(
          column(
            8,
            box(
              width = NULL, status = "danger", solidHeader = TRUE,
              title = "Tren Frekuensi Banjir",
              plotlyOutput("flood_trend_plot", height = "350px")
            )
          ),
          column(
            4,
            box(
              width = NULL, status = "info", solidHeader = TRUE,
              title = "Interpretasi Banjir",
              div(
                style = "font-size: 14px; line-height: 1.6;",
                uiOutput("flood_interpretation")
              )
            )
          )
        )
      ),

      # NAVBAR Metode Analisis
      tabItem(
        tabName = "analysis",
        # HEADER SECTION
        div(
          class = "section-header",
          h1("Metode Analisis", style = "font-weight: bold; margin-bottom: 10px; font-size: 32px;"),
          h4("Pengaruh curah hujan dan Suhu Rata-Rata Harian terhadap Peluang Terjadinya Banjir",
            style = "font-weight: 300; opacity: 0.9; margin: 0;"
          )
        ),
        create_info_banner("Analisis juga dilakukan menurut kota dalam DKI Jakarta untuk mengurangi efek spasial, misalnya akibat perbedaan kualitas saluran air atau persentase lahan terbangun di setiap kota. Oleh sebab itu, model yang akan digunakan untuk prediksi peluang banjir di setiap kota akan dibangun dari data kota tersebut saja."),
        create_info_banner("Data curah hujan dan suhu rata-rata harian diambil dari Earth Engine Data Catalog oleh Google, sedangkan data ada atau tidaknya banjir di suatu hari diperoleh dari Badan Nasional Penanggulangan Bencana. Rentang waktu data yang digunakan dalam analisis adalah 1 Januari 2020 hingga 31 Desember 2024."),

        # FILTER SECTION
        div(
          selectInput("analysis_city",
            label = h4("Pilih Wilayah:", style = paste0("color: ", colors$primary, "; font-weight: 600;")),
            choices = c("DKI Jakarta", "Jakarta Pusat", "Jakarta Utara", "Jakarta Barat", "Jakarta Selatan", "Jakarta Timur"),
            selected = "DKI Jakarta",
            width = "100%"
          )
        ),
        conditionalPanel(
          condition = "input.analysis_city == 'DKI Jakarta'",
          create_info_banner("Untuk DKI Jakarta, nilai curah hujan dan suhu rata-rata harian di suatu hari dihitung sebagai rata-rata dari Jakarta Pusat, Jakarta Utara, Jakarta Barat, Jakarta Selatan, dan Jakarta Timur di hari itu. Selain itu, banjir dianggap terjadi pada hari tersebut jika ada kejadian banjir di salah satu kota yang telah disebutkan.")
        ),

        # DATA EXPLORATION SECTION
        div(
          class = "section-header",
          h2("Eksplorasi Data")
        ),
        box(
          width = NULL, status = "primary", solidHeader = TRUE,
          title = "Frekuensi Hari Banjir",
          plotlyOutput("flood_pie_chart", height = "350px"),
          footer = div(
            style = "padding: 12px;",
            "Dalam data yang digunakan, banyak hari tanpa banjir jauh lebih banyak dibandingkan dengan hari yang mengalami banjir. Hal tersebut berpotensi mempengaruhi kecenderungan outcome dari model (model akan lebih sering memprediksi hari tanpa banjir). Masalah tersebut sebaiknya menjadi perhatian dalam penelitian selanjutnya. Untuk proyek ini, analisis tetap dilakukan dengan data yang ada apa adanya."
          )
        ),
        box(
          width = NULL, status = "primary", solidHeader = TRUE,
          title = "Perbandingan Distribusi Suhu",
          plotlyOutput("flood_temp_boxplot", height = "350px"),
          footer = div(
            style = "padding: 12px;",
            "Secara rata-rata, suhu rata-rata harian pada hari yang mengalami banjir cenderung lebih rendah dibandingkan dengan hari tanpa banjir. Dengan mengabaikan pencilan, di hari banjir, lebih dari 75% amatan memiliki suhu di bawah 27°C, sedangkan pada hari tanpa banjir, kurang dari 75% amatan memiliki suhu rentang tersebut."
          )
        ),
        box(
          width = NULL, status = "primary", solidHeader = TRUE,
          title = "Perbandingan Distribusi Curah Hujan",
          plotlyOutput("flood_rainfall_boxplot", height = "350px"),
          footer = div(
            style = "padding: 12px;",
            "Secara rata-rata, curah hujan harian pada hari yang mengalami banjir cenderung lebih tinggi dibandingkan dengan hari tanpa banjir. Dengan mengabaikan pencilan, di hari tanpa banjir, lebih dari 75% amatan memiliki curah hujan di bawah 10 mm, sedangkan pada hari banjir, kurang dari 50% amatan memiliki curah hujan di rentang tersebut. Akan tetapi, di hari tanpa banjir, terdapat cukup banyak pencilan dengan curah hujan yang lebih tinggi dibandingkan hari lainnya, bahkan lebih tinggi dibandingkan dengan curah hujan harian tertinggi untuk hari banjir. Dalam penelitian selanjutnya, pengaruh hari tanpa banjir dengan curah hujan yang sangat tinggi ini terhadap peluang terjadinya banjir di hari-hari selanjutnya sebaiknya juga diulik."
          )
        ),
        box(
          width = NULL, status = "primary", solidHeader = TRUE,
          title = "Sebaran Curah Hujan dan Suhu",
          plotlyOutput("flood_scatter_plot", height = "350px"),
          footer = div(
            style = "padding: 12px;",
            "Berdasarkan diagram pencar tersebut, belum terlihat pengelompokkan yang jelas untuk titik-titik hari banjir dan hari tidak banjir (curah hujan dan suhu rata-rata harian untuk hari banjir tidak berbeda jauh dengan hari tidak banjir [sebaran dalam kedua kelompok masih beririsan]). Oleh sebab itu, curah hujan dan suhu rata-rata di suatu hari saja mungkin belum cukup untuk membedakan hari banjir dan tidak banjir."
          )
        ),

        # MODEL EXPLANATION SECTION
        div(
          class = "section-header",
          h2("Model Regresi")
        ),
        box(
          width = NULL, status = "primary", solidHeader = TRUE,
          title = "Model & Persamaan Regresi",
          div(
            style = "font-size: 15px; line-height: 1.7;",
            p("Anggap model regresi logistik biner dan tidak adanya penyesuaian data sudah cukup untuk memprediksi peluang terjadinya banjir berdasarkan variabel suhu rata-rata harian dan total curah hujan harian. Metode tersebut dipilih karena dianggap paling sederhana dan agar interpretasi mudah untuk dilakukan, walaupun hasil eksplorasi data menunjukkan bahwa metode ini mungkin kurang tepat."),
            p("Persamaan regresi akan diestimasi dengan memanfaatkan data harian dari 1 Januari 2020 hingga 31 Desember 2024 yang telah digunakan di bagian Eksplorasi Data sebelumnya."),
            tags$b("Persamaan Regresi:"),
            uiOutput("model_explanation_box")
          )
        ),

        # CONTOUR PLOT OF LOGISTIC REGRESSION
        box(
          width = NULL, status = "primary", solidHeader = TRUE,
          title = "Plot Kontur Probabilitas Banjir",
          plotlyOutput("logistic_contour_plot", height = "400px")
        ),

        # MODEL FITNESS ANALYSES
        div(
          class = "section-header",
          h2("Ketepatan Model")
        ),

        # MODEL FITNESS METRICS & CONFUSION MATRIX
        box(
          width = NULL, status = "info", solidHeader = TRUE,
          title = "Confusion Matrix",
          div(
            style = "width: 100%;",
            uiOutput("confusion_matrix_table")
          ),
          footer = div(
            style = "padding: 12px;",
            "Berdasarkan grafik tersebut, model yang dihasilkan gagal menghasilkan satu pun true positive, sehingga beberapa metrik di bawah ini akan bernilai nol. Hal tersebut mungkin terjadi akibat penggunaan metode yang kurang tepat yang dapat menjadi perhatian bagi penelitian selanjutnya."
          )
        ),
        fluidRow(
          uiOutput("model_metrics_boxes")
        )
      ),

      # NAVBAR PREDIKSI REAL-TIME
      tabItem(
        tabName = "prediction",

        # HEADER SECTION
        div(
          class = "section-header",
          h1("Prediksi Risiko Banjir Real-time", style = "font-weight: bold; margin-bottom: 10px; font-size: 32px;"),
          h4("Masukkan Data Cuaca Terkini untuk Memprediksi Risiko Banjir di Seluruh Wilayah Jakarta",
            style = "font-weight: 300; opacity: 0.9; margin: 0;"
          )
        ),

        # INPUT SECTION
        fluidRow(
          column(
            12,
            box(
              width = NULL, status = "primary", solidHeader = TRUE,
              title = "Input Data Cuaca",
              div(
                style = "padding: 20px;",
                fluidRow(
                  column(
                    6,
                    h4("Curah Hujan (mm/hari)", style = paste0("color: ", colors$primary, "; margin-bottom: 15px;")),
                    sliderInput("rainfall_input",
                      label = NULL,
                      min = 0, max = 78, value = 5, step = 1,
                      width = "100%"
                    ),
                    div(
                      style = "text-align: center; margin-bottom: 25px;",
                      span(textOutput("rainfall_display"),
                        style = paste0("font-size: 18px; font-weight: bold; color: ", colors$primary, ";")
                      )
                    )
                  ),
                  column(
                    6,
                    h4("Suhu Rata-rata (°C)", style = paste0("color: ", colors$secondary, "; margin-bottom: 15px;")),
                    sliderInput("temperature_input",
                      label = NULL,
                      min = 24, max = 30, value = 27, step = 0.1,
                      width = "100%"
                    ),
                    div(
                      style = "text-align: center; margin-bottom: 25px;",
                      span(textOutput("temperature_display"),
                        style = paste0("font-size: 18px; font-weight: bold; color: ", colors$secondary, ";")
                      )
                    )
                  )
                ),
                div(
                  style = "text-align: center; margin-top: 20px;",
                  actionButton("predict_btn", "Prediksi Risiko Banjir",
                    style = paste0("background: ", colors$primary, "; color: white;
                                         font-weight: bold; padding: 15px 40px; border: none;
                                         border-radius: 25px; font-size: 18px;"),
                    width = "300px"
                  )
                )
              )
            )
          )
        ),

        # RISK DISPLAY & RECOMMENDATIONS
        fluidRow(
          column(
            6,
            box(
              width = NULL, status = "info", solidHeader = TRUE,
              title = "Tingkat Risiko Saat Ini",
              div(
                style = "padding: 20px; text-align: center; min-height: 300px;",
                uiOutput("current_risk_display"),
                br(),
                uiOutput("risk_interpretation")
              )
            )
          ),
          column(
            6,
            box(
              width = NULL, status = "warning", solidHeader = TRUE,
              title = "Saran & Rekomendasi",
              div(
                style = "padding: 15px; min-height: 300px;",
                uiOutput("recommendations")
              )
            )
          )
        ),

        # MAP
        fluidRow(
          column(
            12,
            box(
              width = NULL, status = "success", solidHeader = TRUE,
              title = "Peta Risiko Banjir Jakarta",
              leafletOutput("flood_risk_map", height = "600px")
            )
          )
        ),

        # HISTORY
        fluidRow(
          column(
            12,
            box(
              width = NULL, status = "primary", solidHeader = TRUE,
              title = "Histori Pencarian",
              div(
                style = "padding: 20px;",
                uiOutput("search_history")
              )
            )
          )
        )
      )
    )
  )
)
