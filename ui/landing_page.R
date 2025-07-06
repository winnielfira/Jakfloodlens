# Flood Lens - Landing Page UI (Updated)

landing_page_ui <- fluidPage(
  tags$head(
    tags$link(href = "https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap", rel = "stylesheet"),
    tags$link(href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css", rel = "stylesheet"),
    tags$style(HTML("
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #001F3F 0%, #3A6D8C 100%);
        min-height: 100vh;
        overflow-x: hidden;
      }

      .landing-container {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        position: relative;
      }

      /* Full-width header */
      .landing-header {
        background: #3A6D8C;
        backdrop-filter: blur(32px);
        padding: 20px 0;
        position: sticky;
        top: 0;
        z-index: 100;
        width: 100vw;
        margin-left: calc(-50vw + 50%);
      }

      .header-content {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 0 20px;
      }

      .logo {
        color: white;
        font-size: 28px;
        font-weight: 700;
        text-decoration: none;
        text-align: center;
      }

      .landing-main {
        flex: 1;
        padding: 40px 20px;
      }

      .hero-section {
        text-align: center;
        margin-bottom: 60px;
        padding: 40px 0;
      }

      .hero-title {
        color: white;
        font-size: 48px;
        font-weight: 700;
        margin-bottom: 20px;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        line-height: 1.2;
      }

      .hero-subtitle {
        color: rgba(255, 255, 255, 0.9) !important;
        font-size: 20px;
        font-weight: 400;
        max-width: 800px;
        margin: 0 auto 40px;
        line-height: 1.6;
      }

      .hero-cta {
        margin-top: 30px;
      }

      .main-cta-button {
        background: linear-gradient(135deg, #6A9AB0, #3A6D8C);
        color: white;
        border: none;
        padding: 30px 80px;  /* EXTRA GEDE */
        border-radius: 30px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        text-transform: uppercase;
        letter-spacing: 2px;
        font-size: 24px;  /* EXTRA GEDE */
        box-shadow: 0 8px 25px rgba(0, 31, 63, 0.3);
      }

      .main-cta-button:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 35px rgba(106, 154, 176, 0.4);
        background: linear-gradient(135deg, #3A6D8C, #001F3F);
      }

      .dashboard-grid {
        max-width: 1200px;
        margin: 0 auto 60px;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 25px;
        padding: 0 20px;
      }

      .dashboard-card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 20px;
        padding: 30px 25px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 280px;
      }

      .card-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }

      .dashboard-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
        transition: left 0.5s ease;
      }

      .dashboard-card:hover::before {
        left: 100%;
      }

      .dashboard-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
      }

      .card-icon {
        font-size: 40px;
        margin-bottom: 15px;
        background: linear-gradient(135deg, #001F3F, #3A6D8C);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
      }

      .card-title {
        font-size: 20px;
        font-weight: 600;
        color: #001F3F;
        margin-bottom: 12px;
      }

      .card-description {
        color: #3A6D8C;
        font-size: 14px;
        line-height: 1.5;
        margin-bottom: 20px;
      }

      .card-button {
        background: linear-gradient(135deg, #001F3F, #3A6D8C);
        color: white;
        border: none;
        padding: 10px 25px;
        border-radius: 20px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        text-transform: uppercase;
        letter-spacing: 1px;
        font-size: 12px;
        margin-top: auto;
        align-self: center;
        min-width: 150px;
      }

      .card-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(58, 109, 140, 0.4);
        background: linear-gradient(135deg, #3A6D8C, #6A9AB0);
      }

      .team-section {
        max-width: 1200px;
        margin: 0 auto 60px;
        padding: 0 20px;
      }

      .section-title-dash {
        text-align: center;
        color: white !important;
        font-size: 36px;
        font-weight: 700;
        margin-bottom: 40px;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
      }

      .member-card-landing {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 20px;
        padding: 20px;
        text-align: center;
        box-shadow: 0 8px 30px rgba(0,31,63,0.1);
        border: 2px solid #EAD8B1;
        transition: all 0.4s ease;
        position: relative;
        overflow: hidden;
      }

      .member-card-landing:hover {
        transform: translateY(-8px);
        box-shadow: 0 15px 40px rgba(0,31,63,0.2);
        border-color: #3A6D8C;
      }

      .photo-placeholder-landing {
        width: 100%;
        height: 300px;
        background: linear-gradient(135deg, #6A9AB0, #EAD8B1);
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 15px;
        border: 2px solid #ddd;
        transition: all 0.3s ease;
        overflow: hidden;
      }

      .photo-placeholder-landing img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 13px;
        transition: all 0.3s ease;
      }

      .member-card-landing:hover .photo-placeholder-landing img {
        transform: scale(1.05);
      }

      /* Full-width footer */
      .landing-footer {
        background: rgba(0, 31, 63, 0.9);
        backdrop-filter: blur(10px);
        color: white !important;
        padding: 40px 20px 20px;
        border-top: 1px solid rgba(234, 216, 177, 0.3);
        width: 100vw;
        margin-left: calc(-50vw + 50%);
      }

      .footer-main {
        text-align: center;
        margin-bottom: 30px;
        max-width: 1200px;
        margin-left: auto;
        margin-right: auto;
      }

      .footer-main h3 {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 15px;
        color: #EAD8B1;
      }

      .footer-main p {
        font-size: 16px;
        line-height: 1.6;
        color: rgba(255, 255, 255, 0.8) !important;
        max-width: 600px;
        margin: 0 auto 20px;
      }

      .footer-features {
        display: flex;
        justify-content: center;
        gap: 20px;
        flex-wrap: wrap;
        margin-top: 20px;
      }

      .footer-features span {
        background: rgba(234, 216, 177, 0.2);
        padding: 8px 15px;
        border-radius: 20px;
        font-size: 14px;
        color: #EAD8B1;
        border: 1px solid rgba(234, 216, 177, 0.3);
      }

      .footer-bottom-dash p {
        text-align: center;
        padding-top: 20px;
        border-top: 1px solid rgba(255, 255, 255, 0.1) !important;
        color: white !important;
        font-size: 12px;
        max-width: 1200px;
        margin: 0 auto;
      }

      /* RESPONSIVE DESIGN */
      @media (max-width: 768px) {
        .hero-title {
          font-size: 32px;
        }

        .hero-subtitle {
          font-size: 16px;
        }

        .section-title-dash {
          font-size: 28px;
        }

        .dashboard-grid {
          grid-template-columns: 1fr;
          gap: 20px;
        }

        .team-grid {
          grid-template-columns: 1fr;
          gap: 20px;
        }

        .landing-main {
          padding: 20px 10px;
        }

        .hero-section {
          padding: 20px 0;
          margin-bottom: 40px;
        }

        .main-cta-button {
          padding: 20px 40px;
          font-size: 16px;
        }
      }

      @media (max-width: 480px) {
        .hero-title {
          font-size: 28px;
        }

        .dashboard-card {
          padding: 25px 20px;
        }

        .member-card-landing {
          padding: 15px;
        }

        .landing-footer {
          padding: 30px 15px 15px;
        }
      }
    ")),

    # JavaScript untuk navigasi cards
    tags$script(HTML("
      $(document).ready(function() {
        // Card navigation
        $('#card-overview').on('click', function() {
          $('#goToOverview').click();
        });

        $('#card-analysis').on('click', function() {
          $('#goToAnalysis').click();
        });

        $('#card-prediction').on('click', function() {
          $('#goToPrediction').click();
        });
      });
    "))
  ),
  div(
    class = "landing-container",
    # Header
    div(
      class = "landing-header",
      div(
        class = "header-content",
        div(
          style = "display: flex; justify-content: space-between; align-items: center; width: 100%;",
          div(class = "logo", "Jakfloodlens"),
          div(class = "logo", "Kelompok 4 2KS2")
        )
      )
    ),

    # Main Content
    div(
      class = "landing-main",
      # Hero Section
      div(
        class = "hero-section",
        h1(class = "hero-title", "Jakfloodlens"),
        p(
          class = "hero-subtitle",
          "Sistem Analisis dan Prediksi Dampak Perubahan Iklim terhadap Banjir Jakarta.
                Menggunakan data historis dan sains data untuk memberikan insight mendalam
                tentang pola iklim dan risiko banjir di berbagai wilayah Jakarta."
        ),
        div(
          class = "hero-cta",
          actionButton("enterDashboardMain", "Explore Dashboard", class = "main-cta-button")
        )
      ),

      # Demo video section - MODIFIED
      h2(class = "section-title-dash", "Dokumentasi"),
      
      # Info boxes menggunakan style yang sama dengan dashboard cards
      div(
        style = "max-width: 1200px; margin: 0 auto 60px; padding: 0 20px;",
        div(
          style = "display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px; margin-bottom: 40px;",
          
          # YouTube Box
          div(
            class = "dashboard-card",
            div(
              class = "card-content",
              div(class = "card-icon", tags$i(class = "fab fa-youtube")),
              h3(class = "card-title", "Video Tutorial"),
              p(
                class = "card-description",
                "Tonton panduan video kami untuk memahami semua fitur yang ada di dashboard ini dari awal hingga akhir."
              )
            ),
            tags$a(
              href = "https://youtu.be/KeFEvhL5F_s?si=bfs_sti8RH461n5Y",
              target = "_blank",
              class = "card-button",
              style = "text-decoration: none;",
              "Kunjungi YouTube"
            )
          ),
          
          # GitHub Box
          div(
            class = "dashboard-card",
            div(
              class = "card-content",
              div(class = "card-icon", tags$i(class = "fab fa-github")),
              h3(class = "card-title", "Kode Sumber"),
              p(
                class = "card-description",
                "Jelajahi kode di balik proyek ini, berkontribusi, atau gunakan sebagai referensi untuk proyek Anda sendiri."
              )
            ),
            tags$a(
              href = "https://github.com/your-username/jakfloodlens",
              target = "_blank",
              class = "card-button",
              style = "text-decoration: none;",
              "Lihat di GitHub"
            )
          )
        ),
      
      
      # Dashboard Cards Section
      h2(class = "section-title-dash", "Dashboard Features"),
      div(
        class = "dashboard-grid",
        # Card 1: Ringkasan Iklim
        div(
          class = "dashboard-card", id = "card-overview",
          div(
            class = "card-content",
            div(class = "card-icon", icon("chart-bar")),
            h3(class = "card-title", "Ringkasan Iklim"),
            p(
              class = "card-description",
              "Statistik komprehensif curah hujan, suhu, dan frekuensi banjir dengan visualisasi interaktif"
            )
          ),
          actionButton("goToOverview", "Lihat Data", class = "card-button")
        ),

        # Card 2: Metode Analisis
        div(
          class = "dashboard-card", id = "card-analysis",
          div(
            class = "card-content",
            div(class = "card-icon", icon("microscope")),
            h3(class = "card-title", "Metode Analisis"),
            p(
              class = "card-description",
              "Penjelasan mengenai metode yang digunakan dalam memperkirakan peluang banjir berdasarkan curah hujan dan suhu"
            )
          ),
          actionButton("goToAnalysis", "Lihat Penjelasan", class = "card-button")
        ),

        # Card 3: Prediksi Real-time
        div(
          class = "dashboard-card", id = "card-prediction",
          div(
            class = "card-content",
            div(class = "card-icon", icon("bullseye")),
            h3(class = "card-title", "Prediksi Real-time"),
            p(
              class = "card-description",
              "Prediksi risiko banjir berdasarkan kondisi cuaca terkini dengan pemetaan interaktif"
            )
          ),
          actionButton("goToPrediction", "Prediksi Sekarang", class = "card-button")
        )
      ),

      # Team Section - DIPERPANJANG + READY UNTUK IMAGES
      div(
        id = "team", class = "team-section",
        h2(class = "section-title-dash", "Our Team"),
        div(
          style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px;",
          # Member 1
          div(
            class = "member-card-landing",
            div(
              class = "photo-placeholder-landing",
              # GUNAKAN INI KALAU SUDAH ADA IMAGE:
              img(src = "images/ayu.PNG", alt = "Diah Ayu Nur Rahmadani", style = "width: 100%; height: 100%; object-fit: cover; border-radius: 13px;")
            ),
            div(
              style = "padding: 20px 0;", # ← Padding diperbesar
              h4("Diah Ayu Nur Rahmadani", style = "color: #001F3F; font-weight: 600; margin: 0; text-align: center; font-size: 18px;")
            )
          ),

          # Member 2
          div(
            class = "member-card-landing",
            div(
              class = "photo-placeholder-landing",
              # GUNAKAN INI KALAU SUDAH ADA IMAGE:
              img(src = "images/razwa.PNG", alt = "Razwa Fazila Wibowo", style = "width: 100%; height: 100%; object-fit: cover; border-radius: 13px;")
            ),
            div(
              style = "padding: 20px 0;",
              h4("Razwa Fazila Wibowo", style = "color: #001F3F; font-weight: 600; margin: 0; text-align: center; font-size: 18px;")
            )
          ),

          # Member 3
          div(
            class = "member-card-landing",
            div(
              class = "photo-placeholder-landing",
              # GUNAKAN INI KALAU SUDAH ADA IMAGE:
              img(src = "images/winni.PNG", alt = "Winni Elfira", style = "width: 100%; height: 100%; object-fit: cover; border-radius: 13px;")
            ),
            div(
              style = "padding: 20px 0;",
              h4("Winni Elfira", style = "color: #001F3F; font-weight: 600; margin: 0; text-align: center; font-size: 18px;")
            )
          )
        )
      )
    ),

    # Footer
    div(
      class = "landing-footer",
      div(
        class = "footer-main",
        h3("Jakfloodlens"),
        p("Sistem analisis dan prediksi dampak perubahan iklim terhadap banjir Jakarta menggunakan data science."),
        div(
          class = "footer-features",
          span("Data Analysis"),
          span("Interactive Maps"),
          span("Real-time Prediction"),
          span("Statistical Modeling")
        )
      ),
      p("© 2025 Jakfloodlens | Developed for Climate Change Analysis",
        style = "text-align: center; font-size: 12px; opacity: 0.8; margin: 0; color: white !important;"
      )
    )
  )
)
)
