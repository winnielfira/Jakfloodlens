# Flood Lens
Sebuah dasbor RShiny yang menampilkan tren curah hujan dan suhu rata-rata harian serta frekuensi banjir di DKI Jakarta dan kota-kota di dalamnya (kecuali Kepulauan Seribu). Dasbor ini juga dilengkapi dengan fitur analisis inferensia untuk memprediksi peluang terjadinya banjir di suatu hari berdasarkan curah hujan dan suhu rata-rata di hari tersebut. Model pengklasifikasi yang digunakan untuk keperluan prediksi tersebut adalah model regresi logistik biner. 

Proyek ini masih memiliki beberapa kekurangan, terutama dari segi metode (data kurang ideal dan model yang digunakan juga belum pas). Penelitian selanjutnya dapat memperbaiki kekurangan-kekurangan tersebut agar hasil prediksi yang dihasilkan lebih valid.

Proyek ini dibuat untuk pemenuhan tugas akhir mata kuliah Komputasi Statistik untuk program studi D-4 Komputasi Statistik di Politeknik Statistika STIS. Proposal proyek dapat diakses melalui tautan [ini](https://drive.google.com/file/d/1T_8FW99JkG8-2BXkNCtzfQG9x_luA9rk/view?usp=sharing).

## Struktur Proyek
- File `app.R` merupakan titik mulai aplikasi dan tempat file-file lainnya ikut dimuat.
- Folder `ui` berisi file-file tempat tampilan dan konten dinamis ditentukan. Dalam folder ini, terdapat file `landing_page.R` yang berisi pengaturan tampilan dari landing page (halaman pertama yang akan muncul saat pengguna mengakses halaman ini) dan file `dashboard.R` yang berisi pengaturan tampilan dari dasbor utama (terdiri atas halaman beranda dasbor, halaman ringkasan iklim, halaman metode analisis, dan halaman prediksi real time).
- Folder `server` berisi file-file yang mengatur cara server menampilkan konten ke pengguna (akses antar halaman dan pembuatan konten dinamis). File `navigation.R` berisi pengaturan mengenai cara server menangani permintaan untuk mengakses halaman tertentu. File `dashboard_logic.R` berisi pengaturan untuk konten dinamis yang ditentukan di `dashboard.R`.
- Folder `data` berisi file `data_processing.R` yang akan memuat `data.xlsx` (sumber data) agar dapat digunakan oleh aplikasi.
- Folder `utils` berisi file-file pendukung lain, seperti `functions.R` yang berisi makro (misalnya nilai-nilai default untuk warna), proses penghitungan (pembentukan model, penghitungan ketepatan model), dan fungsi pendukung lain (misalnya fungsi untuk mengambil persamaan regresi, fungsi untuk mengambil ketepatan model regresi).
- Folder `www` berisi aset-aset lain, seperti gambar.

## Cara Memulai Dasbor
1. Instal semua library yang diperlukan (ada dalam file `app.R`)
2. Buka file `app.R` dan eksekusi file (sebagai aplikasi shiny) dari IDE Anda

## Referensi
- [Google Earth Engine Data Catalog](https://developers.google.com/earth-engine/datasets)
- [Data Informasi Bencana Indonesia](https://dibi.bnpb.go.id/superset/dashboard/2/)
- [Dokumentasi R dan package-package R](https://cran.r-project.org/)
- [Regresi logistik biner](https://en.wikipedia.org/wiki/Logistic_regression)